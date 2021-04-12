//
//  ContactAUView.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/3/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ContactAUView: UIViewController {
    
    //MARK: Variables
    var presenter: ContactAUPresenterProtocol?
    var contactDetails:ContactDetails = ContactDetails(id: 0, firstNameFromAPI: "", lastNameFromAPI: "", favouriteFromAPI: false, emailFromAPI: "", phoneNumberFromAPI: "", profilePicFromAPI: "")
    
    //MARK: Constants
    let contactDetailsUpdatePlaceHolders = ["First Name","Last Name","mobile","email"]
    
    //Outlets
    @IBOutlet weak var contactsUpdateTableView: UITableView!
    @IBOutlet weak var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    @IBAction func saveOrUpdateContact(_ sender: Any) {
        self.view.endEditing(true)
        presenter?.validateContactDetails(contactDetails: self.contactDetails)
    }
    @IBAction func cancel(_ sender: Any) {
        contactDetails.reset()
        presenter?.cancelAction()
    }
    @IBAction func profilePicEdit(_ sender: Any) {
      checkPermissionForPhotoPickerAccess()
    }
}

extension ContactAUView: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func getImageFromImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func checkPermissionForPhotoPickerAccess() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            self.getImageFromImagePicker()
            print("Access granted")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.getImageFromImagePicker()
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("No access")
        case .denied:
            print("Permission Denied.")
        @unknown default:
            fatalError()
        }
    }
    
    //TRIED UPDATING WITH IMAGE base64 encoding still not working
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.imageURL] as? URL) != nil{
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            _ = image.pngData()! as NSData
            self.profilePic.image = image
            let contactDetailsUpdate = ContactDetails(id: self.contactDetails.id, firstNameFromAPI: self.contactDetails.firstName, lastNameFromAPI: self.contactDetails.lastName, favouriteFromAPI: self.contactDetails.favourite, emailFromAPI: self.contactDetails.email, phoneNumberFromAPI: self.contactDetails.phoneNumber, profilePicFromAPI: "")
            self.contactDetails = contactDetailsUpdate
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ContactAUView: ContactAUViewProtocol {
    func setContactDetailsToView(contactDetails: ContactDetails) {
        self.contactDetails = contactDetails
        self.profilePic.circleMask()
        self.profilePic.image = UIImage(named: "PlaceholderPhoto")
        if !(contactDetails.profilePic.isEmpty){
        self.profilePic.downloadImageFrom(link: baseUrl + contactDetails.profilePic, contentMode: UIView.ContentMode.scaleAspectFit)
        }
        self.contactsUpdateTableView.reloadData()
    }
    
    func showDialog(resultType: Bool, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ContactAUView : UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetailsUpdatePlaceHolders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactDetailsUpdate = [self.contactDetails.firstName,self.contactDetails.lastName,self.contactDetails.phoneNumber , self.contactDetails.email]
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailsTableCell", for: indexPath) as! ContactDetailTableViewCell
            cell.set(contactDetailValue: contactDetailsUpdate[indexPath.row] , DetailPlaceHolder: contactDetailsUpdatePlaceHolders[indexPath.row])
            if(indexPath.row > 1){ // phone number and email are optional entries
                cell.contactDetailTxtField.placeholder = "optional"
            }
            cell.contactDetailTxtField.tag = indexPath.row
            cell.contactDetailTxtField.delegate = self
            return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch textField.tag {
        case 0:
            contactDetails.firstNameFromAPI = textField.text!
        case 1:
            contactDetails.lastNameFromAPI = textField.text!
        case 2:
            contactDetails.phoneNumberFromAPI = textField.text!
        case 3:
            contactDetails.emailFromAPI = textField.text!
        default:
            print("no data entered")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
