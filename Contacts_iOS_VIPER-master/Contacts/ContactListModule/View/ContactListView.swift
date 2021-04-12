//
//  ContactListView.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/1/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit
import Network

class ContactListView: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var contactTableView: UITableView!
    
    //MARK: Variables
    var presenter: ContactListPresenterProtocol?
    var contactList: [Contacts] = []
    var sortedFirstLetters: [String] = []
    var sections: [[Contacts]] = []
    var activityIndicator: UIActivityIndicatorView? = nil
    var errorMessage:String?
    
    //MARK: Constants
    let monitor = NWPathMonitor()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator = UIActivityIndicatorView()
            presenter?.viewDidLoad()
    }
    
    @IBAction func addContact(_ sender: Any) {
        presenter?.addNewContact()
    }
}

//MARK: Update Contact List From Other Controllers using Delegate
extension ContactListView: ContactListUpdateProtocol{
    func updateContactListOnEdit(contactDetails: ContactDetails) {
        for index in 0..<contactList.count {
            if contactList[index].id == contactDetails.id {
                contactList[index].firstNameFromAPI = contactDetails.firstName
                contactList[index].lastNameFromAPI = contactDetails.lastName
                contactList[index].profilePicFromAPI = contactDetails.profilePic
                contactList[index].favouriteFromAPI = contactDetails.favourite
            }
        }
        self.sortContacts(contacts: contactList)
        self.showContacts(contacts: contactList)
    }
    
    func updateContactListOnDeletion(contactId: Int) {
        let contactDetails = self.contactList.filter{$0.id != contactId}
        self.sortContacts(contacts: contactDetails)
        self.showContacts(contacts: contactDetails)
    }
}

extension ContactListView: ContactListViewProtocol{
    func showContacts(contacts: [Contacts]) {
        contactList = contacts
        DispatchQueue.main.async {
            self.contactTableView.reloadData()
        }
    }
    
    func updateListFromNewContact(contactDetails: ContactDetails) {
        let newContact = Contacts(id: contactDetails.id, firstNameFromAPI: contactDetails.firstName, lastNameFromAPI: contactDetails.lastName, favouriteFromAPI: contactDetails.favourite, profilePicFromAPI: contactDetails.profilePic, urlFromAPI: "")
        self.contactList.append(newContact)
        self.sortContacts(contacts: self.contactList)
        self.showContacts(contacts: self.contactList)
    }
    
    func showError(message:String) {
        self.hideLoading()
        self.errorMessage = message
        DispatchQueue.main.async {
            self.contactTableView.reloadData()
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            if let activityIndicator = self.activityIndicator {
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.style = UIActivityIndicatorView.Style.gray
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator!.stopAnimating();
            UIApplication.shared.endIgnoringInteractionEvents();
        }
    }
    
    func sortContacts(contacts: [Contacts]){
        if contacts.count > 0 {
            let firstLetters = contacts.map { $0.getFirstLetter }
            let uniqueFirstLetters = Array(Set(firstLetters))
            sortedFirstLetters = uniqueFirstLetters.sorted()
            sections = sortedFirstLetters.map{ firstLetter in
                return contacts
                    .filter{$0.getFirstLetter == firstLetter}
                    .sorted{$0.firstName < $1.firstName}
            }
            //Move Remaining Contacts to End of List ' # '
            if sortedFirstLetters.contains("#"){
                sortedFirstLetters.insert(sortedFirstLetters.remove(at: 0), at: sortedFirstLetters.count)
                sections.insert(sections.remove(at: 0), at: sections.count)
            }
        }
    }
}

//MARK: Contacts List Table View Delegate methods
extension ContactListView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sections.count > 0{
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        else{
            let errorMessage: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            errorMessage.text          = self.errorMessage ?? ""
            errorMessage.textColor     = UIColor.black
            errorMessage.textAlignment = .center
            tableView.backgroundView  = errorMessage
            tableView.separatorStyle  = .none
        }
        return sections.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedFirstLetters
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedFirstLetters[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as! ContactTableViewCell
        let contact = sections[indexPath.section][indexPath.row]
        cell.set(contact: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = sections[indexPath.section][indexPath.row]
        presenter?.showContactDetails(contactId: contact.id,delegate: self)
    }
}

