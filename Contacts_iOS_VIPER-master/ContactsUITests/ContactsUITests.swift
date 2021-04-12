//
//  ContactsUITests.swift
//  ContactsUITests
//
//  Created by Karthic Paramasivam on 7/1/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import XCTest

class ContactsUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        super.setUp()
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        print(app.debugDescription)
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testContactNavigation() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        sleep(2)
        XCTAssert(app.tables.staticTexts.count > 0,"No data found for ContactLists listing")
        
        //Assert if Mobilelabel exists in ContactDetails View
        let mobileLabel = self.app.staticTexts["mobile"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: mobileLabel, handler: nil)

        //Tap on first row of table
        let firstCell = app.tables.cells.element(boundBy: 0)
        firstCell.tap()
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(mobileLabel.exists)
        
        //Assert if FirstNameLabel exists in Add/Edit Contact View
        let firstNameLabel = self.app.staticTexts["First Name"]
        expectation(for: exists, evaluatedWith: firstNameLabel, handler: nil)
        
        app.navigationBars["Contacts.ContactDetailView"].buttons["Edit"].tap()

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(firstNameLabel.exists)
    }

    
    func testAddNewContact(){
        sleep(1)
        //Assert if Contact List is Loaded
        XCTAssert(app.tables.staticTexts.count > 0,"No data found for ContactLists listing")
        
        //Tap Add Button
        app.navigationBars["Contacts"].buttons["Add"].tap()
        
        // Enter FirstName and LastName
        let tablesQuery = app.tables
        let firstNameTextField = tablesQuery.cells.containing(.staticText, identifier:"First Name").children(matching: .textField).element
        firstNameTextField.tap()
        firstNameTextField.typeText("AAA")
        let lastNameTextField = tablesQuery.cells.containing(.staticText, identifier:"Last Name").children(matching: .textField).element
        lastNameTextField.tap()
        lastNameTextField.typeText("AAA")
        
        //Tap Done
        app.navigationBars["Contacts.ContactAUView"].buttons["Done"].tap()
        
        //Check Added Contact Exists in ContactList
        let fullName = self.app.staticTexts["AAA AAA"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: fullName, handler: nil)
        
        waitForExpectations(timeout: 9, handler: nil)
        XCTAssert(fullName.exists)
    }    
}
