//
//  ContactListTests.swift
//  ContactsTests
//
//  Created by Karthic Paramasivam on 7/5/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactListTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTableViewOutletConnections() {
        //Given
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "ContactNavigationController")
        if let view = navigationController.children.first as? ContactListView {
            //When
            view.loadView()
            
            //Then
            XCTAssert(view.contactTableView != nil, "Table is not initialized properly")
            
            XCTAssert((view.contactTableView.delegate?.isEqual(view))!, "Table delegate is not initialized properly")
            XCTAssert((view.contactTableView.dataSource?.isEqual(view))!, "Table datasource not initialized properly")
        }
    }
    
    func testDisplayContactListWithContacts(){
        //Given
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "ContactNavigationController")
        if let viewController = navigationController.children.first as? ContactListView {
            
        let contact1 = Contacts(id: 1, firstNameFromAPI: "test1", lastNameFromAPI: "one", favouriteFromAPI: false, profilePicFromAPI: "test1Image", urlFromAPI: "next.com")
        let contact2 = Contacts(id: 2, firstNameFromAPI: "test2", lastNameFromAPI: "two", favouriteFromAPI: true, profilePicFromAPI: "test2Image", urlFromAPI: "next2.com")
        
        //When
        viewController.loadView()
        viewController.sortContacts(contacts: [contact1,contact2])
        viewController.showContacts(contacts: [contact1,contact2])
        
        //Then
        XCTAssertEqual(viewController.tableView(viewController.contactTableView, numberOfRowsInSection: 0), 2,"The number of rows should match the number of contacts")
        }
    }
    
    // MARK:- Presenter tests
    func testdidRecievedContactListWithValidContacts(){
        //GIVEN
        let presenter = ContactListPresenter()
        let contact1 = Contacts(id: 1, firstNameFromAPI: "test1", lastNameFromAPI: "one", favouriteFromAPI: false, profilePicFromAPI: "test1Image", urlFromAPI: "next.com")
        let contact2 = Contacts(id: 2, firstNameFromAPI: "test2", lastNameFromAPI: "two", favouriteFromAPI: true, profilePicFromAPI: "test2Image", urlFromAPI: "next2.com")
        let mockView = MockContactListView()
        presenter.view = mockView
        
        //WHEN
        presenter.onContactsRetrieved(contacts: [contact1,contact2])
        
        //THEN
        XCTAssert(mockView.contactList != nil, "Fetch contact set invalid value in presenter")
        XCTAssert(mockView.contactList?.count == 2, "Fetch contact set invalid value in presenter")
        XCTAssert(mockView.contactList?[0].firstName == "test1", "Fetch contact set invalid value in presentet")
    }
    
    func testdidRecievedContactListWithInvalidContacts(){
        //GIVEN
        let presenter = ContactListPresenter()

        let mockView = MockContactListView()
        presenter.view = mockView
        
        //WHEN
        presenter.onError(message: "No Contacts Found")
        
        //THEN
        XCTAssert(mockView.errorMessage == "No Contacts Found", "Should throw proper error message")
    }
    
    // MARK:- Interactor tests
    func testContactListInterectorFetchContactsWithValidContactList(){
        //GIVEN
        let contactListInteractor = ContactListInteractor()
        
        let mockContactListPresenter = MockContactListPresenter()
        let mockGetContactsService = MockGetContactListService()
        let mockContactListOuput = MockGetContactListOutput()
        
        contactListInteractor.presenter = mockContactListPresenter
        contactListInteractor.getContactsManager = mockGetContactsService
        mockGetContactsService.requestHandler = mockContactListOuput
        
        //WHEN
        contactListInteractor.getContactList()
                
        //THEN
        XCTAssert(mockContactListOuput.contactList?.count == 2, "Fetch Contact set invalid value in presenter")
        XCTAssert(mockContactListOuput.contactList?[1].id == 2, "Fetch Contact set invalid value in presenter")
    }

}
