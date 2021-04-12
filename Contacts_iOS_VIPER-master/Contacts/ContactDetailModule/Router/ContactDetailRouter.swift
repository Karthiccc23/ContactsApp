//
//  ContactDetailRouter.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/2/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit

class ContactDetailRouter: ContactDetailRouterProtocol {
    static func constructContactDetailModule(contactId: Int, updateContactListDelegate:ContactListView?) -> UIViewController{
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ContactDetailsController")
            if let view = viewController as? ContactDetailView {
                let presenter: ContactDetailPresenterProtocol & ContactDetailInteratorOutputProtocol = ContactDetailPresenter()
                let interactor: ContactDetailsInteractorInputProtocol & ContactDetailsManagerOutputProtocol = ContactDetailInteractor()
                let contactDetailsManager: ContactDetailsManagerInputProtocol = GETContactDetailsService()
                let router: ContactDetailRouterProtocol = ContactDetailRouter()
                
                view.presenter = presenter
                view.updateContactListDelegate = updateContactListDelegate
                presenter.view = view
                presenter.router = router
                presenter.contactId = contactId
                presenter.interactor = interactor
                interactor.presenter = presenter
                interactor.contactDetailsManager = contactDetailsManager
                contactDetailsManager.requestHandler = interactor
                return viewController
            }
            return UIViewController()
        }
        
        static var mainStoryboard: UIStoryboard {
            return UIStoryboard(name: "Main", bundle: Bundle.main)
        }
    
    func showContactsScreen(view: ContactDetailViewProtocol) {
        if let sourceView = view as? UIViewController {
            DispatchQueue.main.async {
                sourceView.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showEditContactScreen(view: ContactDetailViewProtocol, contactDetails:ContactDetails,delegate: ContactDetailPresenter){
        let contactAUViewController = ContactAURouter.constructContactAUModule(contactDetails: contactDetails, action: "UPDATE", delegate: delegate,contactListDelegate: nil)
        
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(contactAUViewController, animated: true)
        }
    }
}
