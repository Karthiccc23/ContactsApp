//
//  MockViews.swift
//  ContactsTests
//
//  Created by Karthic Paramasivam on 7/5/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
@testable import Contacts

class MockContactListView : ContactListViewProtocol{
    var presenter: ContactListPresenterProtocol?
    var contactList:[Contacts]?
    var errorMessage:String?
    var loading:Bool?
    var contactDetails:ContactDetails?
    
    func showContacts(contacts: [Contacts]) {
        self.contactList = contacts
    }
    
    func sortContacts(contacts: [Contacts]) {
        self.contactList = contacts
    }
    
    func showError(message: String) {
        self.errorMessage = message
    }
    
    func showLoading() {
        loading = true
    }
    
    func hideLoading() {
        loading = false
    }
    
    func updateListFromNewContact(contactDetails: ContactDetails) {
        self.contactDetails = contactDetails
    }
}

class MockContactDetailsView: ContactDetailViewProtocol{
    var presenter: ContactDetailPresenterProtocol?
    var favouriteSelected:Bool?
    var email:String?
    var contactDetails:ContactDetails?
    var contactNumber: String?
    var errorMessage:String?
    
    func favouriteContactSelected(contactDetails: ContactDetails) {
        self.favouriteSelected = contactDetails.favourite
    }
    
    func createEmail(email: String) {
        self.email = email
    }
    
    func showContactDetails(contactDetails: ContactDetails) {
        self.contactDetails = contactDetails
    }
    
    func createMessage(contactNumber: String) {
        self.contactNumber = contactNumber
    }
    
    func callContact(contactNumber: String) {
        self.contactNumber = contactNumber
    }
    
    func showDialog(message: String) {
        errorMessage = message
    }
}

class MockContactAddOrUpdateView: ContactAUViewProtocol{
    var presenter: ContactAUPresenterProtocol?
    var contactDetails:ContactDetails?
    var resultType:Bool?
    var errorMessage:String?
    
    func setContactDetailsToView(contactDetails: ContactDetails) {
        self.contactDetails = contactDetails
    }
    
    func showDialog(resultType: Bool, message: String) {
        self.resultType = resultType
        self.errorMessage = message
    }
}
