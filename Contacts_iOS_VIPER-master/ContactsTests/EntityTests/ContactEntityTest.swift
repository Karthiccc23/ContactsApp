//
//  ContactEntityTest.swift
//  ContactsTests
//
//  Created by Karthic Paramasivam on 7/5/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactEntityTest: XCTestCase {
    
    func testContactSetGet() {
        let contact = Contacts(id: 25, firstNameFromAPI: "Karthic", lastNameFromAPI: "Par", favouriteFromAPI: true, profilePicFromAPI: "noImage", urlFromAPI: "ContactInfo.com")
        XCTAssertEqual(contact.id, 25)
        XCTAssertEqual(contact.firstName, "Karthic")
        XCTAssertEqual(contact.lastName, "Par")
        XCTAssertEqual(contact.favourite, true)
        XCTAssertEqual(contact.profilePic, "noImage")
        XCTAssertEqual(contact.url, "ContactInfo.com")
    }
}
