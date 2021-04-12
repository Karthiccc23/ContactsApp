//
//  ContactDetailView.swift
//  Contacts
//
//  Created by Karthic on 7/1/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ContactDetailView : UIViewController{
    
    //MARK: Variables
    var presenter: ContactDetailPresenterProtocol?
    var contactDetails:ContactDetails = ContactDetails(id: 0, firstNameFromAPI: "", lastNameFromAPI: "", favouriteFromAPI: false, emailFromAPI: "", phoneNumberFromAPI: "", profilePicFromAPI: "")
    var updateContactListDelegate : ContactListUpdateProtocol?
    
    //MARK: Outlets
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var favBtn: UIImageView!
    @IBOutlet weak var emailBtn: UIImageView!
    @IBOutlet weak var callBtn: UIImageView!
    @IBOutlet weak var messageBtn: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var ContactDetailsTableView: UITableView!
    @IBOutlet weak var delete: UIButton!
    
    //MARK: Constants
    let contactDetailsPlaceHolders = ["mobile","email"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showContactDetails(contactDetails: self.contactDetails)
    }
    
    @IBAction func deleteContact(_ sender: Any) {
        presenter?.deleteContact(contactId: self.contactDetails.id)
        updateContactListDelegate?.updateContactListOnDeletion(contactId: self.contactDetails.id)
    }
    
    @IBAction func editContact(_ sender: Any) {
        presenter?.editContact(contactDetails: self.contactDetails)
    }
    @IBAction func messageContactTap(_ sender: Any) {
        presenter?.sendMessage(contactNumber: contactDetails.phoneNumber, action: "MESSAGE")
    }
    @IBAction func callContactTap(_ sender: Any) {
        presenter?.callContact(contactNumber: contactDetails.phoneNumber, action: "CALL")
    }
    @IBAction func emailContactTap(_ sender: Any) {
        presenter?.emailContact(email: contactDetails.email)
    }
    @IBAction func favouriteContactTap(_ sender: Any) {
        var contactUpdateFavourite:Bool = false
        if contactDetails.favourite {
            contactUpdateFavourite = false
        }else{
           contactUpdateFavourite = true
        }
        presenter?.makeContactFavourite(updateFavouriteContact: contactUpdateFavourite,contactId:contactDetails.id)
    }
}

extension ContactDetailView: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ContactDetailView: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ContactDetailView: ContactDetailViewProtocol{
    func favouriteContactSelected(contactDetails: ContactDetails) {
        self.contactDetails = contactDetails
        DispatchQueue.main.async {
            if contactDetails.favourite{
                self.favBtn.image = UIImage(named: "FavBtnSelected")
            }else{
                self.favBtn.image = UIImage(named: "FavBtnUnselected")
            }
        }
        updateContactListDelegate?.updateContactListOnEdit(contactDetails: self.contactDetails)
    }
    
    func createEmail(email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("", isHTML: true)
            present(mail, animated: true)
        }
    }
    
    func callContact(contactNumber: String) {
        guard let callNumber = URL(string: "tel://" + contactNumber) else { return }
        UIApplication.shared.open(callNumber)
    }
    
    func createMessage(contactNumber: String) {
        if MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            composeVC.recipients = [contactNumber]
            composeVC.body = ""
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    func showContactDetails(contactDetails: ContactDetails) {
        let baseUrl = Environment.production.baseURL()
        self.contactDetails = contactDetails
        updateContactListDelegate?.updateContactListOnEdit(contactDetails: contactDetails)
        DispatchQueue.main.async {
            self.ContactDetailsTableView.reloadData()
            if(self.contactDetails.favourite){
                self.favBtn.image = UIImage(named: "FavBtnSelected")
            }else{
                self.favBtn.image = UIImage(named: "FavBtnUnselected")
            }
            self.fullName.text = "\(contactDetails.firstName) \(contactDetails.lastName)"
            self.profilePic.circleMask()
            self.profilePic.image = UIImage(named: "PlaceholderPhoto")
            if !(contactDetails.profilePic.isEmpty){
            self.profilePic.downloadImageFrom(link: baseUrl + contactDetails.profilePic, contentMode: UIView.ContentMode.scaleAspectFit)
            }
        }
    }
    func showDialog(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ContactDetailView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetailsPlaceHolders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailsTableCell", for: indexPath) as! ContactDetailTableViewCell
        cell.contactDetailTxtField.isUserInteractionEnabled = false
        cell.contactDetailTxtField.placeholder = "optional"
        let contactDetails = [self.contactDetails.phoneNumber, self.contactDetails.email]
        cell.set(contactDetailValue: contactDetails[indexPath.row] , DetailPlaceHolder: contactDetailsPlaceHolders[indexPath.row])
        return cell
    }
}
