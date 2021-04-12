//
//  ContactListProtocols.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/1/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit

//PRESENTER - > VIEW
protocol ContactListViewProtocol: class {
    var presenter: ContactListPresenterProtocol? {get set}
    
    func showContacts(contacts: [Contacts])
    func sortContacts(contacts:[Contacts])
    func showError (message:String)
    func showLoading()
    func hideLoading()
    func updateListFromNewContact(contactDetails:ContactDetails)
}

//PRESENTER - > ROUTER
protocol ContactListRouterProtocol: class {
    static func constructContactListModule() -> UIViewController
    func showContactDetails(view: ContactListViewProtocol , contactId:Int, updateContactListDelegate: ContactListView)
    func showAddContactScreen(view: ContactListViewProtocol , contactDetails:ContactDetails, contactListDelegate: ContactListPresenter)
}

//VIEW - > PRESENTER
protocol ContactListPresenterProtocol: class{
    var view : ContactListViewProtocol? {get set}
    var interactor: ContactListInteractorInputProtocol? {get set}
    var router: ContactListRouterProtocol? {get set}
    
    func viewDidLoad()
    func showContactDetails(contactId: Int, delegate: ContactListView)
    func addNewContact()
}

//PRESENTER -> INTERACTOR
protocol ContactListInteractorInputProtocol: class {
    var presenter: ContactListInteratorOutputProtocol? {get set}
    var getContactsManager: GetContactsManagerInputProtocol? {get set}
    
    func getContactList()
}

//INTERACTOR - > PRESENTER
protocol ContactListInteratorOutputProtocol: class {
    func onContactsRetrieved(contacts: [Contacts])
    func onError(message:String)
}

//INTERATOR - > WEBSERVICE
protocol GetContactsManagerInputProtocol: class{
    var requestHandler : GetContactsManagerOutputProtocol? {get set}
    
    func getContactListAPI()
}

protocol GetContactsManagerOutputProtocol: class {
    func onContactsRetrievedFromAPI(contacts: [Contacts])
    func onError(message:String)
}
