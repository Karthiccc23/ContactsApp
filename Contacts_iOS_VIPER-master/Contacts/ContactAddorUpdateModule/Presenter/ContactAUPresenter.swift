//
//  ContactAUPresenter.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/3/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit

class ContactAUPresenter: ContactAUPresenterProtocol {
    var view: ContactAUViewProtocol?
    var interactor: ContactAUInteractorInputProtocol?
    var router: ContactAURouterProtocol?
    
    var contactDetails:ContactDetails? = ContactDetails(id: 0, firstNameFromAPI: "", lastNameFromAPI: "", favouriteFromAPI: false, emailFromAPI: "", phoneNumberFromAPI: "", profilePicFromAPI: "")
    var contactAction:String?
    var delegate: ContactUpdateDelegate?
    var contactAddedDelegate:ContactAddedDelegate?
    
    func viewDidLoad() {
        view?.setContactDetailsToView(contactDetails: contactDetails!)
    }
    
    func cancelAction() {
        router?.showContactDetailsScreen(view: view!)
    }
    
    func validateContactDetails(contactDetails: ContactDetails) {
        interactor?.contactDetailsValidation(contactDetails: contactDetails)
    }
}

extension ContactAUPresenter: ContactAUInteratorOutputProtocol {
    func onValidationComplete(resultType: Bool, message: String,contactDetails: ContactDetails) {
        if(resultType){
            if self.contactAction == "ADD"{
                self.interactor?.addContactDetails(contactDetails: contactDetails)
            }else if self.contactAction == "UPDATE"{
                self.interactor?.updateContactDetails(contactDetails: contactDetails)
            }
        }else{
           view?.showDialog(resultType: resultType, message: message)
        }
    }
    
    func onCompleteUpdateContactDetails(contactDetails: ContactDetails) {
        delegate?.contactUpdateResponse(contactDetails: contactDetails)
        router?.showContactDetailsScreen(view: view!)
    }
    
    func onCompleteAddedContactDetails(contactDetails: ContactDetails) {
        contactAddedDelegate?.contactAddedResponse(contactDetails: contactDetails)
        router?.showContactsListScreen(view: view!)
    }
    
    func showErrorMessage(message: String) {
        view?.showDialog(resultType: true, message: message)
    }
}

