//
//  ContactDetailProtocols.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/2/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit

//PRESENTER - > VIEW
protocol ContactDetailViewProtocol: class {
    var presenter: ContactDetailPresenterProtocol? {get set}
    
    func favouriteContactSelected(contactDetails: ContactDetails)
    func createEmail(email:String)
    func showContactDetails(contactDetails: ContactDetails)
    func createMessage(contactNumber:String)
    func callContact(contactNumber:String)
    func showDialog(message: String)
}
//PRESENTER -> INTERACTOR
protocol ContactDetailsInteractorInputProtocol : class{
    var presenter: ContactDetailInteratorOutputProtocol? {get set}
    var contactDetailsManager: ContactDetailsManagerInputProtocol? {get set}
    
    func validateContact(contactNumber:String, action: String)
    func getContactDetails(contactId: Int)
    func deleteContact(contactId: Int)
    func validateEmail(email:String)
    func updateContactFavourite(favouriteContact: Bool,contactId:Int)
}

//INTERACTOR - > PRESENTER
protocol ContactDetailInteratorOutputProtocol: class {
    func onUpdateFavouriteUI(contactDetails: ContactDetails)
    func onContactDetailsRetrieved(contactDetails: ContactDetails)
    func onValidateEmail(email:String,resultType:Bool)
    func onValidateContactNumber(contactNumber:String,resultType:Bool,action:String)
    func onDeleteCompleted()
    func onError(message:String)
}

//PRESENTER - > ROUTER
protocol ContactDetailRouterProtocol: class {
    static func constructContactDetailModule(contactId: Int,updateContactListDelegate: ContactListView?) -> UIViewController
    func showContactsScreen(view: ContactDetailViewProtocol)
    func showEditContactScreen(view: ContactDetailViewProtocol , contactDetails: ContactDetails , delegate: ContactDetailPresenter)
}

// VIEW -> PRESENTER
protocol ContactDetailPresenterProtocol: class {
    var view: ContactDetailViewProtocol? {get set}
    var interactor: ContactDetailsInteractorInputProtocol? {get set}
    var router: ContactDetailRouterProtocol?{get set}
    var contactId: Int?{get set}
    
    func viewDidLoad()
    func emailContact(email:String)
    func callContact(contactNumber:String, action: String)
    func sendMessage(contactNumber: String, action: String)
    func deleteContact(contactId: Int)
    func editContact(contactDetails: ContactDetails)
    func makeContactFavourite(updateFavouriteContact: Bool,contactId:Int)
}

//INTERATOR - > WEBSERVICE
protocol ContactDetailsManagerInputProtocol: class{
    var requestHandler : ContactDetailsManagerOutputProtocol? {get set}
    func getContactDetailsAPI(contactId :Int)
    func deleteContactAPI(contactId: Int)
    func updateContactFavouriteAPI(contactFavourite: Bool,contactId:Int)
}

protocol ContactDetailsManagerOutputProtocol: class {
    func onDeleteSuccess()
    func onContactDetailsRetrievedFromAPI(contactDetails: ContactDetails)
    func onUpdateFavouriteSuccess(contactDetails:ContactDetails)
    func onError(message:String)
}

protocol ContactListUpdateProtocol: class{
    func updateContactListOnDeletion(contactId: Int)
    func updateContactListOnEdit(contactDetails: ContactDetails)
}
