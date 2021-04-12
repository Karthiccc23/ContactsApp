//
//  ContactDetailInteractor.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/2/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation

class ContactDetailInteractor: ContactDetailsInteractorInputProtocol{
    //MARK: Variables
    weak var presenter: ContactDetailInteratorOutputProtocol?
    var contactDetailsManager: ContactDetailsManagerInputProtocol?
    
    func getContactDetails(contactId: Int) {
        contactDetailsManager?.getContactDetailsAPI(contactId: contactId)
    }
    func deleteContact(contactId: Int) {
        contactDetailsManager?.deleteContactAPI(contactId: contactId)
    }
    
    //MARK: Validation
    func validateContact(contactNumber: String,action: String) {
        let phoneNumberRegEx = "^((\\+)?)[0-9]{10}$"
        let phoneNumberPredicate = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegEx)
        if ((contactNumber.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty) && ( !(phoneNumberPredicate.evaluate(with: contactNumber))) {
            presenter?.onValidateContactNumber(contactNumber: contactNumber, resultType: false, action: action)
        }else{
            presenter?.onValidateContactNumber(contactNumber: contactNumber, resultType: true,action: action)
        }
    }
    func validateEmail(email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if ((email.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty) && ( !(emailPredicate.evaluate(with: email))) {
            presenter?.onValidateEmail(email: email, resultType: false)
        }else{
            presenter?.onValidateEmail(email: email, resultType: true)
        }
    }
    
    func updateContactFavourite(favouriteContact: Bool,contactId:Int) {
        contactDetailsManager?.updateContactFavouriteAPI(contactFavourite: favouriteContact,contactId: contactId)
    }
}

extension ContactDetailInteractor: ContactDetailsManagerOutputProtocol {
    func onContactDetailsRetrievedFromAPI(contactDetails: ContactDetails) {
        presenter?.onContactDetailsRetrieved(contactDetails: contactDetails)
    }
    
    func onUpdateFavouriteSuccess(contactDetails: ContactDetails) {
        presenter?.onUpdateFavouriteUI(contactDetails: contactDetails)
    }
    func onUpdateFavouriteFailed() {
        
    }
    
    func onDeleteSuccess() {
        presenter?.onDeleteCompleted()
    }
    
    func onError(message:String) {
        presenter?.onError(message: message)
    }
}
