//
//  ContactDetailsEntityTest.swift
//  ContactsTests
//
//  Created by Karthic Paramasivam on 7/5/19.
//  Copyright © 2019 Karthic. All rights reserved.
//


import XCTest
@testable import Contacts

class ContactDetailsEntityTest: XCTestCase {
    
    func testContactDetailsSetGet() {
        let contactDetails = ContactDetails(id: 25, firstNameFromAPI: "Karthic", lastNameFromAPI: "Par", favouriteFromAPI: true, emailFromAPI: "kar@gmail.com", phoneNumberFromAPI: "1234567890", profilePicFromAPI: "noImage")
        XCTAssertEqual(contactDetails.id, 25)
        XCTAssertEqual(contactDetails.firstName, "Karthic")
        XCTAssertEqual(contactDetails.lastName, "Par")
        XCTAssertEqual(contactDetails.favourite, true)
        XCTAssertEqual(contactDetails.profilePic, "noImage")
        XCTAssertEqual(contactDetails.email, "kar@gmail.com")
        XCTAssertEqual(contactDetails.phoneNumber, "1234567890")
    }
}
