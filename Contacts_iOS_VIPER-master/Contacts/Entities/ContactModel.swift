//
//  ContactModel.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/1/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation

struct Contacts: Codable {
     var id:Int
     var firstNameFromAPI:String?
     var lastNameFromAPI:String?
     var favouriteFromAPI:Bool?
     var profilePicFromAPI:String?
     var urlFromAPI:String?
    
    var lastName : String {
        if let lastName = lastNameFromAPI {
            return lastName
        }
        return ""
    }
    
    var firstName : String {
        if let firstName = firstNameFromAPI {
            return firstName
        }
        return ""
    }
    
    var favourite : Bool {
        if let result = favouriteFromAPI {
            return result
        }
        return false
    }
    
    var profilePic : String {
        if let result = profilePicFromAPI {
            return result
        }
        return ""
    }
    
    var url : String {
        if let result = urlFromAPI {
            return result
        }
        return ""
    }
    
    //Custom Keys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstNameFromAPI = "first_name"
        case lastNameFromAPI = "last_name"
        case favouriteFromAPI = "favorite"
        case urlFromAPI = "url"
        case profilePicFromAPI = "profile_pic"
    }
}

extension Contacts {
    var getFirstLetter: String {
        let fLetter = self.firstName[self.firstName.startIndex]
        if (fLetter.lowercased() >= "a" && fLetter.lowercased() <= "z") {
            return String(self.firstName[self.firstName.startIndex]).uppercased()
        }else{
            return "#"
        }
    }
}

struct ContactDetails :Codable {
    var id:Int
    var firstNameFromAPI:String?
    var lastNameFromAPI:String?
    var favouriteFromAPI:Bool?
    var emailFromAPI:String?
    var phoneNumberFromAPI:String?
    var profilePicFromAPI:String?
    
    var lastName : String {
        if let lastName = lastNameFromAPI {
            return lastName
        }
        return ""
    }
    
    var firstName : String {
        if let firstName = firstNameFromAPI {
            return firstName
        }
        return ""
    }
    
    var phoneNumber : String {
        if let result = phoneNumberFromAPI {
            return result
        }
        return ""
    }
    
    var email : String {
        if let result = emailFromAPI {
            return result
        }
        return ""
    }
    
    var favourite : Bool {
        if let result = favouriteFromAPI {
            return result
        }
        return false
    }
   
    var profilePic : String {
        if let result = profilePicFromAPI {
            return result
        }
        return ""
    }
    

    //Custom Keys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstNameFromAPI = "first_name"
        case lastNameFromAPI = "last_name"
        case favouriteFromAPI = "favorite"
        case emailFromAPI = "email"
        case phoneNumberFromAPI = "phone_number"
        case profilePicFromAPI = "profile_pic"
    }
    
    mutating func reset() {
        id = 0
        firstNameFromAPI = ""
        lastNameFromAPI = "No"
        favouriteFromAPI =  false
        emailFromAPI = ""
        phoneNumberFromAPI = ""
        profilePicFromAPI = ""
    }
}

