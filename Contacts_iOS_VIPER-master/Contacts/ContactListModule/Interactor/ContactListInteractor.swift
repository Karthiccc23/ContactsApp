//
//  ContactListInteractor.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/1/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation

class ContactListInteractor: ContactListInteractorInputProtocol {
    weak var presenter: ContactListInteratorOutputProtocol?
    var getContactsManager: GetContactsManagerInputProtocol?
    func getContactList() {
        getContactsManager?.getContactListAPI()
    }
}

extension ContactListInteractor: GetContactsManagerOutputProtocol {
    func onContactsRetrievedFromAPI(contacts: [Contacts]) {
        presenter?.onContactsRetrieved(contacts: contacts)
    }
    
    func onError(message:String) {
        presenter?.onError(message: message)
    }
}
