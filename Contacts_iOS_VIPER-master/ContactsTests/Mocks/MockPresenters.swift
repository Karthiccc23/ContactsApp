//
//  MockPresenters.swift
//  ContactsTests
//
//  Created by Karthic Paramasivam on 7/5/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
@testable import Contacts

class MockContactListPresenter: ContactListInteratorOutputProtocol {
    var contactList:[Contacts]?
    var errorMessage:String?
    func onContactsRetrieved(contacts: [Contacts]) {
        self.contactList = contacts
    }
    
    func onError(message: String) {
        self.errorMessage = message
    }
}

class MockContactDetailPresenter: ContactDetailInteratorOutputProtocol{
    var contactDetails:ContactDetails?
    var email:String?
    var resultType:Bool?
    var action:String?
    var contactNumber:String?
    var errorMessage:String?
    
    func onUpdateFavouriteUI(contactDetails: ContactDetails) {
        self.contactDetails = contactDetails
    }
    
    func onContactDetailsRetrieved(contactDetails: ContactDetails) {
        self.contactDetails = contactDetails
    }
    
    func onValidateEmail(email: String, resultType: Bool) {
        self.email = email
        self.resultType = resultType
    }
    
    func onValidateContactNumber(contactNumber: String, resultType: Bool, action: String) {
        self.action = action
        self.contactNumber = contactNumber
        self.resultType = resultType
    }
    
    func onDeleteCompleted() {
        self.resultType = true
    }
    
    func onError(message: String) {
        self.errorMessage = message
    }
}

class MockContactAddOrUpdatePresenter: ContactAUInteratorOutputProtocol{
    var contactDetails:ContactDetails?
    var resultType:Bool?
    var errorMessage:String?
    
    func onValidationComplete(resultType: Bool, message: String, contactDetails: ContactDetails) {
        self.contactDetails = contactDetails
    }
    
    func onCompleteUpdateContactDetails(contactDetails: ContactDetails) {
        self.contactDetails = contactDetails
    }
    
    func onCompleteAddedContactDetails(contactDetails: ContactDetails) {
        self.contactDetails = contactDetails
    }
    
    func showErrorMessage(message: String) {
        self.errorMessage = message
    }
}

