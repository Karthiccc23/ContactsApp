//
//  ContactListPresenter.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/1/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit

class ContactListPresenter: ContactListPresenterProtocol, ContactAddedDelegate{
    weak var view: ContactListViewProtocol?
    var interactor: ContactListInteractorInputProtocol?
    var router: ContactListRouterProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getContactList()
    }
    
    func contactAddedResponse(contactDetails: ContactDetails) {
        view?.updateListFromNewContact(contactDetails: contactDetails)
    }
    
    func showContactDetails(contactId: Int, delegate :ContactListView) {
        router?.showContactDetails(view: view!, contactId: contactId, updateContactListDelegate: delegate)
    }
    
    func addNewContact() {
        let contactDetails =  ContactDetails.init(id: 0, firstNameFromAPI: "", lastNameFromAPI: "", favouriteFromAPI: false, emailFromAPI: "", phoneNumberFromAPI: "", profilePicFromAPI: "")
        router?.showAddContactScreen(view: view! , contactDetails: contactDetails,contactListDelegate: self)
    }
}

extension ContactListPresenter: ContactListInteratorOutputProtocol{
    func onContactsRetrieved(contacts: [Contacts]) {
        view?.hideLoading()
        view?.sortContacts(contacts: contacts)
        view?.showContacts(contacts: contacts)
    }
    
    func onError(message:String) {
        view?.hideLoading()
        view?.showError(message : message)
    }
}
