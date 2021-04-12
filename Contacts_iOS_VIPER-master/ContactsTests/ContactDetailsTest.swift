//
//  ContactDetailsTest.swift
//  ContactsTests
//
//  Created by Karthic Paramasivam on 7/5/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactDetailsTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testOutletsConnections(){
        //Given
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let view = storyboard.instantiateViewController(withIdentifier: "ContactDetailsController")
        if let viewController = view as? ContactDetailView {
            //When
            viewController.loadView()
            
            //Then
            let outletsStatus = (viewController.callBtn == nil || viewController.delete == nil || viewController.favBtn == nil || viewController.emailBtn == nil || viewController.messageBtn == nil)
            
            XCTAssertFalse(outletsStatus, "Outlets are not initialized properly")
        }
    }
    
    // MARK:- Interacter tests
    func testContactDetailInterectorFetchDetailWithValidContactData(){
        //GIVEN
        let contactDetailInteractor = ContactDetailInteractor()
        
        let contactDetailPresenter = ContactDetailPresenter()
        let mockGetContactDetailsInputService = MockGetContactDetailsInputService()
        let mockGetContactDetailsOutput = MockGetContactDetailsOutputService()
        
        contactDetailInteractor.presenter = contactDetailPresenter
        contactDetailInteractor.contactDetailsManager = mockGetContactDetailsInputService
        mockGetContactDetailsInputService.requestHandler = mockGetContactDetailsOutput
        
        //WHEN
        contactDetailInteractor.getContactDetails(contactId: 25)
        
        //THEN
        XCTAssert(mockGetContactDetailsOutput.contactDetails != nil, "Contact details should be fetched")
        XCTAssert(mockGetContactDetailsOutput.contactDetails?.firstName == "test1", "Fetched Contact detail is not correct")
    }

}
