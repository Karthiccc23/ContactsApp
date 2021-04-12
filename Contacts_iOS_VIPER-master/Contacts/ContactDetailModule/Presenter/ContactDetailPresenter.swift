//
//  ContactDetailPresenter.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/2/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit

class ContactDetailPresenter: ContactDetailPresenterProtocol{
    
    //MARK: Variables
    var view: ContactDetailViewProtocol?
    var interactor: ContactDetailsInteractorInputProtocol?
    var router: ContactDetailRouterProtocol?
    var contactId: Int?
    
    func viewDidLoad() {
        interactor?.getContactDetails(contactId: contactId!)
    }
    
    func deleteContact(contactId:Int) {
        interactor?.deleteContact(contactId: contactId)
    }
    
    func editContact(contactDetails: ContactDetails) {
        router?.showEditContactScreen(view: view! , contactDetails: contactDetails , delegate: self)
    }
    
    func sendMessage(contactNumber: String, action: String) {
        interactor?.validateContact(contactNumber: contactNumber,action: action)
    }
    
    func emailContact(email: String) {
        interactor?.validateEmail(email: email)
    }
    
    func makeContactFavourite(updateFavouriteContact: Bool,contactId:Int) {
        interactor?.updateContactFavourite(favouriteContact: updateFavouriteContact,contactId: contactId)
    }
    
    func callContact(contactNumber: String, action: String) {
        interactor?.validateContact(contactNumber: contactNumber, action: action)
    }
}

extension ContactDetailPresenter: ContactDetailInteratorOutputProtocol,ContactUpdateDelegate{
    func onUpdateFavouriteUI(contactDetails: ContactDetails) {
        view?.favouriteContactSelected(contactDetails: contactDetails)
    }
    
    
    func onValidateEmail(email: String, resultType: Bool) {
        if resultType {
            view?.createEmail(email: email)
        }else{
            view?.showDialog(message: "Please edit to valid Email Address")
        }
    }
    
    func onValidateContactNumber(contactNumber: String, resultType: Bool,action: String) {
        if resultType {
            switch action{
            case "MESSAGE":
                view?.createMessage(contactNumber: contactNumber)
                break
            case "CALL":
                view?.callContact(contactNumber: contactNumber)
                break
            default:
                break
            }
        }else{
            view?.showDialog(message: "Please edit to valid Phone number")
        }
    }
    
    func contactUpdateResponse(contactDetails: ContactDetails) {
        view?.showContactDetails(contactDetails: contactDetails)
    }
    
    func onContactDetailsRetrieved(contactDetails: ContactDetails) {
        view?.showContactDetails(contactDetails: contactDetails)
    }
    
    func onDeleteCompleted() {
        router?.showContactsScreen(view: view!)
    }
    
    func onError(message:String) {
        view?.showDialog(message: message)
    }
}
