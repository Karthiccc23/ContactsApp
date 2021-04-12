//
//  ContactDetailTableViewCell.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/2/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit

class ContactDetailTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var contactDetailLabel: UILabel!
    @IBOutlet weak var contactDetailTxtField: UITextField!
    
    func set(contactDetailValue: String, DetailPlaceHolder: String) {
        self.selectionStyle = .none
        contactDetailLabel.text = DetailPlaceHolder
        contactDetailTxtField.text = contactDetailValue
    }
}
