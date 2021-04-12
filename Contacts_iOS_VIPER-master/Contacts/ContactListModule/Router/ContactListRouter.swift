//
//  ContactListRouter.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/1/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit

class ContactListRouter:ContactListRouterProtocol {
    static func constructContactListModule() -> UIViewController {
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "ContactNavigationController")
        if let view = navigationController.children.first as? ContactListView {
            let presenter: ContactListPresenterProtocol & ContactListInteratorOutputProtocol = ContactListPresenter()
            let interactor: ContactListInteractorInputProtocol & GetContactsManagerOutputProtocol = ContactListInteractor()
            let getContactsManager: GetContactsManagerInputProtocol = GETContactsService()
            let router: ContactListRouterProtocol = ContactListRouter()
            
            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.getContactsManager = getContactsManager
            getContactsManager.requestHandler = interactor
            return navigationController
        }
        return UIViewController()
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func showContactDetails(view: ContactListViewProtocol, contactId: Int,updateContactListDelegate: ContactListView) {
        let contactDetailViewController = ContactDetailRouter.constructContactDetailModule(contactId: contactId,updateContactListDelegate: updateContactListDelegate)
            if let sourceView = view as? UIViewController {
                sourceView.navigationController?.pushViewController(contactDetailViewController, animated: true)
            }
    }
    
    func showAddContactScreen(view: ContactListViewProtocol,contactDetails: ContactDetails,contactListDelegate: ContactListPresenter) {
        let contactAUViewController = ContactAURouter.constructContactAUModule(contactDetails: contactDetails,action: "ADD", delegate: nil,contactListDelegate: contactListDelegate)
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(contactAUViewController, animated: true)
        }
    }
}
