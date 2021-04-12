//
//  ContactAUInteractor.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/3/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation

class ContactAUInteractor:ContactAUInteractorInputProtocol{
    
    var presenter: ContactAUInteratorOutputProtocol?
    
    var contactAUManager: ContactAUManagerInputProtocol?
    
    //VALIDATE CONTACT DETAILS
    func contactDetailsValidation(contactDetails: ContactDetails) {
        
        var errorMessage:String = "Success"
        var resultType:Bool = true
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let phoneNumberRegEx = "^((\\+)?)[0-9]{10}$"
        let phoneNumberPredicate = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegEx)

        // MARK: OPTIONAL PARAMETERS
        if (!(contactDetails.email.isEmpty) || (!(contactDetails.email.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty)){
            if !(emailPredicate.evaluate(with: contactDetails.email)) {
                resultType = false
                errorMessage = "Please enter valid email address"
            }
        }
        
        if (!(contactDetails.phoneNumber.isEmpty) || (!(contactDetails.phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty)){
            if !(phoneNumberPredicate.evaluate(with: contactDetails.phoneNumber)) {
                resultType = false
                errorMessage = "Please enter valid mobile number.Maximum 10 digits"
            }
        }
        
        //MARK: REQUIRED PARAMETERS
        if contactDetails.lastName.isEmpty || ((contactDetails.lastName.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty) && !(contactDetails.lastName.count > 2){
            resultType = false
            errorMessage = "Please enter valid LastName.Minimum of 2 characters"
        }
        if contactDetails.firstName.isEmpty || ((contactDetails.firstName.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty) && !(contactDetails.firstName.count > 2){
            resultType = false
            errorMessage = "Please enter valid FirstName.Minimum of 2 characters"
        }
        presenter?.onValidationComplete(resultType: resultType, message: errorMessage,contactDetails: contactDetails)
    }
    
    func updateContactDetails(contactDetails: ContactDetails) {
        contactAUManager?.updateContactDetailsAPI(contactDetails: contactDetails)
    }
    
    func addContactDetails(contactDetails: ContactDetails) {
        contactAUManager?.addContactDetailsAPI(contactDetails: contactDetails)
    }
}

extension ContactAUInteractor: ContactAUManagerOutputProtocol {
    func onUpdateContactDetailsSuccess(contactDetails: ContactDetails) {
        presenter?.onCompleteUpdateContactDetails(contactDetails: contactDetails)
    }
    
    func onAddedContactDetailsSuccess(contactDetails: ContactDetails) {
        presenter?.onCompleteAddedContactDetails(contactDetails: contactDetails)
    }
    
    func onError(message: String) {
        presenter?.showErrorMessage(message: message)
    }
}

