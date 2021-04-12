//
//  ContactAURouter.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/3/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit

class ContactAURouter: ContactAURouterProtocol {
    static func constructContactAUModule(contactDetails: ContactDetails,action: String,delegate:ContactDetailPresenter?,contactListDelegate:ContactListPresenter?) -> UIViewController {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ContactAUViewController")
        if let view = viewController as? ContactAUView {
            let presenter: ContactAUPresenterProtocol & ContactAUInteratorOutputProtocol = ContactAUPresenter()
            let interactor: ContactAUInteractorInputProtocol & ContactAUManagerOutputProtocol = ContactAUInteractor()
            let contactAUManager: ContactAUManagerInputProtocol = ADDorUPDATEContactDetailsService()
            let router: ContactAURouterProtocol = ContactAURouter()
            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.delegate = delegate
            presenter.contactAddedDelegate = contactListDelegate
            presenter.contactDetails = contactDetails
            presenter.contactAction = action
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.contactAUManager = contactAUManager
            contactAUManager.requestHandler = interactor
            return viewController
        }
        return UIViewController()
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func showContactsListScreen(view: ContactAUViewProtocol){
        if let sourceView = view as? UIViewController {
            DispatchQueue.main.async {
                sourceView.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showContactDetailsScreen(view: ContactAUViewProtocol){
        if let sourceView = view as? UIViewController {
            DispatchQueue.main.async {
                sourceView.navigationController?.popViewController(animated: true)
            }
        }
    }
}
