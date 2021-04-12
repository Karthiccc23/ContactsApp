//
//  ContactAUProtocols.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/3/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit


//PRESENTER - > VIEW
protocol ContactAUViewProtocol: class {
    var presenter: ContactAUPresenterProtocol? {get set}
    func setContactDetailsToView(contactDetails: ContactDetails)
    func showDialog(resultType:Bool,message: String)
}

//PRESENTER -> INTERACTOR
protocol ContactAUInteractorInputProtocol : class{
    var presenter: ContactAUInteratorOutputProtocol? {get set}
    var contactAUManager: ContactAUManagerInputProtocol? {get set}
    
    func contactDetailsValidation(contactDetails: ContactDetails)
    func updateContactDetails(contactDetails: ContactDetails)
    func addContactDetails(contactDetails: ContactDetails)
}

//INTERACTOR - > PRESENTER
protocol ContactAUInteratorOutputProtocol: class {
    func onValidationComplete(resultType: Bool,message: String, contactDetails: ContactDetails)
    func onCompleteUpdateContactDetails(contactDetails: ContactDetails)
    func onCompleteAddedContactDetails(contactDetails: ContactDetails)
    func showErrorMessage(message:String)
}

//PRESENTER - > ROUTER
protocol ContactAURouterProtocol: class {
    static func constructContactAUModule(contactDetails: ContactDetails,action:String,delegate: ContactDetailPresenter?,contactListDelegate:ContactListPresenter?) -> UIViewController
    func showContactsListScreen(view: ContactAUViewProtocol)
    func showContactDetailsScreen(view: ContactAUViewProtocol)
}

// VIEW -> PRESENTER
protocol ContactAUPresenterProtocol: class {
    var view: ContactAUViewProtocol? {get set}
    var interactor: ContactAUInteractorInputProtocol? {get set}
    var router: ContactAURouterProtocol?{get set}
    var contactDetails: ContactDetails? {get set}
    var contactAction: String? {get set}
    var delegate: ContactUpdateDelegate? {get set}
    var contactAddedDelegate:ContactAddedDelegate? {get set}
    
    func viewDidLoad()
    func cancelAction()
    func validateContactDetails(contactDetails:ContactDetails)
}

//INTERATOR - > WEBSERVICE
protocol ContactAUManagerInputProtocol: class{
    var requestHandler : ContactAUManagerOutputProtocol? {get set}
    func updateContactDetailsAPI(contactDetails:ContactDetails)
    func addContactDetailsAPI(contactDetails:ContactDetails)
}

//WEBSERVICE -> INTERACTOR
protocol ContactAUManagerOutputProtocol: class {
    func onUpdateContactDetailsSuccess(contactDetails: ContactDetails)
    func onAddedContactDetailsSuccess(contactDetails: ContactDetails)
    func onError(message:String)
}

protocol ContactUpdateDelegate: class{
    func contactUpdateResponse(contactDetails: ContactDetails)
}

protocol ContactAddedDelegate: class {
    func contactAddedResponse(contactDetails:ContactDetails)
}
