//
//  MockServiceManager.swift
//  ContactsTests
//
//  Created by Karthic Paramasivam on 7/5/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
@testable import Contacts


class MockGetContactListService:GetContactsManagerInputProtocol{
    var requestHandler: GetContactsManagerOutputProtocol?
    var contactList:[Contacts]?
    var errorMessage:String?
    
    func getContactListAPI() {
        let contact1 = Contacts(id: 1, firstNameFromAPI: "test1", lastNameFromAPI: "one", favouriteFromAPI: false, profilePicFromAPI: "test1Image", urlFromAPI: "next.com")
        let contact2 = Contacts(id: 2, firstNameFromAPI: "test2", lastNameFromAPI: "two", favouriteFromAPI: true, profilePicFromAPI: "test2Image", urlFromAPI: "next2.com")
        let contactList = [contact1,contact2]
        self.contactList = contactList
        requestHandler?.onContactsRetrievedFromAPI(contacts: self.contactList!)
    }
}

class MockGetContactListOutput:GetContactsManagerOutputProtocol {
    var contactList:[Contacts]?
    var errorMessage:String?
    
    func onContactsRetrievedFromAPI(contacts: [Contacts]) {
        self.contactList = contacts
    }
    
    func onError(message: String) {
        self.errorMessage = message
    }    
}

class MockGetContactDetailsInputService:ContactDetailsManagerInputProtocol{
    var requestHandler: ContactDetailsManagerOutputProtocol?
    
    func getContactDetailsAPI(contactId: Int) {
        let contactDetails = ContactDetails(id: 25, firstNameFromAPI: "test1", lastNameFromAPI: "test", favouriteFromAPI: true, emailFromAPI: "test@gmail.com", phoneNumberFromAPI: "1234567890", profilePicFromAPI: "noImage")
        requestHandler?.onContactDetailsRetrievedFromAPI(contactDetails: contactDetails)
    }
    
    func deleteContactAPI(contactId: Int) {
        requestHandler?.onDeleteSuccess()
    }
    
    func updateContactFavouriteAPI(contactFavourite: Bool, contactId: Int) {
       let contactDetails = ContactDetails(id: 25, firstNameFromAPI: "test1", lastNameFromAPI: "test", favouriteFromAPI: true, emailFromAPI: "test@gmail.com", phoneNumberFromAPI: "1234567890", profilePicFromAPI: "noImage")
        requestHandler?.onUpdateFavouriteSuccess(contactDetails: contactDetails)
    }
}



class MockGetContactDetailsOutputService:ContactDetailsManagerOutputProtocol{
    var resultType:Bool?
    var contactDetails:ContactDetails?
    var contactFavourite:Bool?
    var errorMessage:String?
    
    func onDeleteSuccess() {
        resultType = true
    }
    
    func onContactDetailsRetrievedFromAPI(contactDetails: ContactDetails) {
        self.contactDetails = contactDetails
    }
    
    func onUpdateFavouriteSuccess(contactDetails: ContactDetails) {
        self.contactFavourite = contactDetails.favourite
    }
    
    func onError(message: String) {
        let message = "No Contact Details Found"
        self.errorMessage = message
    }
}

class MockAddOrUpdateContactService: ContactAUManagerOutputProtocol{
    var contactDetails:ContactDetails?
    var errorMessage:String?
    
    
    func onUpdateContactDetailsSuccess(contactDetails: ContactDetails) {
        let contactDetails = ContactDetails(id: 22, firstNameFromAPI: "karthic", lastNameFromAPI: "par", favouriteFromAPI: true, emailFromAPI: "kar@gmail.com", phoneNumberFromAPI: "1234567890", profilePicFromAPI: "noImage")
        self.contactDetails = contactDetails
    }
    
    func onAddedContactDetailsSuccess(contactDetails: ContactDetails) {
        let contactDetails = ContactDetails(id: 22, firstNameFromAPI: "karthic", lastNameFromAPI: "par", favouriteFromAPI: true, emailFromAPI: "kar@gmail.com", phoneNumberFromAPI: "1234567890", profilePicFromAPI: "noImage")
        self.contactDetails = contactDetails
    }
    
    func onError(message: String) {
        let message = "Update Contact Failed"
        self.errorMessage = message
    }
}
