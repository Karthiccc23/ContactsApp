//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/1/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
import UIKit

class ContactTableViewCell: UITableViewCell{
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var favourite: UIImageView!
    
    let baseUrl = Environment.production.baseURL()
    
    func set(contact: Contacts) {
        self.selectionStyle = .none
        contactName?.text = "\(contact.firstName) \(contact.lastName)"
        if !(contact.favourite) {
            favourite.isHidden = true
        }else{
            favourite.isHidden = false
        }
        contactImage.circleMask()
        contactImage.image = UIImage(named: "PlaceholderPhoto")
        if !(contact.profilePic.isEmpty){
        contactImage.downloadImageFrom(link: baseUrl + contact.profilePic, contentMode: UIView.ContentMode.scaleAspectFit)
        }
    }
}
