//
//  ServiceManager.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/2/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation
// MARK: GET Contacts -  /contacts.json
class GETContactsService: GetContactsManagerInputProtocol {
    var requestHandler: GetContactsManagerOutputProtocol?
    
    func getContactListAPI() {
        let apiUrl = URL(string: Path().contacts)!
        let datatask = URLSession.shared.dataTask(with: apiUrl) { (result) in
            switch result {
            case .success( let response, let data):
                // Handle Data and Response
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        do{
                            let decoder = JSONDecoder()
                            let contacts = try decoder.decode([Contacts].self, from:
                                data)
                            self.requestHandler?.onContactsRetrievedFromAPI(contacts: contacts)
                        } catch let parsingError {
                            print("Error", parsingError)
                            self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                        }
                        break
                    case 404:
                        self.requestHandler?.onError(message: "No Contacts Found")
                        break
                    case 500:
                        self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                        break
                    default:
                        self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                        break
                    }
                }
                break
            case .failure(let error):
                // Handle Error
                self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                print(error)
                break
            }
        }
        datatask.resume()
    }
}

//MARK: GET Contact Details - /contacts/{id}
class GETContactDetailsService: ContactDetailsManagerInputProtocol {
    var requestHandler: ContactDetailsManagerOutputProtocol?
    func getContactDetailsAPI(contactId: Int) {
        let apiUrl = URL(string: "\(Path().contactsCUD)\(contactId).json")!
        let datatask = URLSession.shared.dataTask(with: apiUrl) { (result) in
            switch result {
            case .success( let response, let data):
                // Handle Data and Response
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                        case 200:
                            do{
                                let decoder = JSONDecoder()
                                let contactDetails = try decoder.decode(ContactDetails.self, from:
                                    data)
                                self.requestHandler?.onContactDetailsRetrievedFromAPI(contactDetails: contactDetails)
                            } catch let error as NSError {
                                self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                                print("Failed to get contacts: \(error.localizedDescription)")
                            }
                            break
                        case 404:
                            self.requestHandler?.onError(message: "No Contact Details Found")
                            break
                        case 500:
                            self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                            break
                        default:
                            self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                            break
                    }
                }
                break
            case .failure(let error):
                // Handle Error
                print(error)
                self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                break
            }
        }
        datatask.resume()
    }
    
    //MARK: DELETE Contact /contacts/{id}
    func deleteContactAPI(contactId: Int) {
        let apiUrl = URL(string: "\(Path().contactsCUD)\(contactId).json")!
        var urlDeleteRequest = URLRequest(url: apiUrl)
        urlDeleteRequest.httpMethod = "DELETE"
        let datatask = URLSession.shared.dataTask(with: urlDeleteRequest) { (result) in
            switch result {
            case .success( let response,_):
                // Handle Data and Response
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 204:
                        self.requestHandler?.onDeleteSuccess()
                        print("Deleted")
                        break
                    case 404:
                        self.requestHandler?.onError(message: "No Contact Found to Delete")
                        break
                    case 500:
                        self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                        break
                    default:
                        self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                        break
                    }
                }
                break
            case .failure(let error):
                // Handle Error
                self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                print(error)
                break
            }
        }
        datatask.resume()
    }
    
    //MARK: PUT Update Contact Favourite /contacts/{id}
    func updateContactFavouriteAPI(contactFavourite: Bool,contactId:Int) {
        let apiUrl = URL(string: "\(Path().contactsCUD)\(contactId).json")!
        var urlUpdateRequest = URLRequest(url: apiUrl)
        urlUpdateRequest.httpMethod = "PUT"
        urlUpdateRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonRequest : [String: Any]  = ["favorite": contactFavourite]
        do {
            let requestJson = try JSONSerialization.data(withJSONObject: jsonRequest, options: [])
            urlUpdateRequest.httpBody = requestJson
            
        } catch let error as NSError{
            self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
            print("Failed to ParseJson: \(error.localizedDescription)")
        }
        
        let datatask = URLSession.shared.dataTask(with: urlUpdateRequest) { (result) in
            switch result {
            case .success( let response,let data):
                // Handle Data and Response
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                        case 200:
                            do {
                                 var contactDetailsUpdated:ContactDetails = ContactDetails(id: 0, firstNameFromAPI: "", lastNameFromAPI: "", favouriteFromAPI: false, emailFromAPI: "", phoneNumberFromAPI: "", profilePicFromAPI: "")
                            
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                                    if let id = json["id"] as? Int {
                                        contactDetailsUpdated.id = id
                                    }
                                    if let firstName = json["first_name"] as? String {
                                        contactDetailsUpdated.firstNameFromAPI = firstName
                                    }
                                    if let lastName = json["last_name"] as? String {
                                        contactDetailsUpdated.lastNameFromAPI = lastName
                                    }
                                    if let favourite = json["favorite"] as? Bool {
                                        contactDetailsUpdated.favouriteFromAPI = favourite
                                    }
                                    if let profilePic = json["profile_pic"] as? String {
                                        contactDetailsUpdated.profilePicFromAPI = profilePic
                                    }
                                    if let email = json["email"] as? String {
                                        contactDetailsUpdated.emailFromAPI = email
                                    }
                                    if let phone_number = json["phone_number"] as? String {
                                        contactDetailsUpdated.phoneNumberFromAPI = phone_number
                                    }
                                    self.requestHandler?.onUpdateFavouriteSuccess(contactDetails: contactDetailsUpdated)
                                    print("Updated Favourite Contact")
                                }
                            } catch let error as NSError {
                                self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                                print("Failed to load: \(error.localizedDescription)")
                            }
                        break
                    case 404:
                        self.requestHandler?.onError(message: "Favourite Contact Failed - No Contact Found")
                        break
                    case 500:
                        self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                        break
                    default:
                        self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                        break
                    }
                }
                break
            case .failure(let error):
                // Handle Error
                self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                print(error)
                break
            }
        }
        datatask.resume()
    }
}

//MARK: ADD/Edit Contacts
class ADDorUPDATEContactDetailsService : ContactAUManagerInputProtocol {
    var requestHandler: ContactAUManagerOutputProtocol?
    
    //MARK: PUT Edit Contact /contacts/{id}
    func updateContactDetailsAPI(contactDetails: ContactDetails){
        let apiUrl = URL(string: "\(Path().contactsCUD)\(contactDetails.id).json")!
        var urlUpdateRequest = URLRequest(url: apiUrl)
        urlUpdateRequest.httpMethod = "PUT"
        urlUpdateRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(contactDetails)
            urlUpdateRequest.httpBody = jsonData
        }
        catch let err {
            print(err)
        }
        let datatask = URLSession.shared.dataTask(with: urlUpdateRequest) { (result) in
            switch result {
            case .success( let response,let data):
                // Handle Data and Response
                if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200:
                        do {
                            var contactDetailsNew:ContactDetails = ContactDetails(id: contactDetails.id, firstNameFromAPI: contactDetails.firstName, lastNameFromAPI: contactDetails.lastName, favouriteFromAPI: contactDetails.favourite, emailFromAPI: contactDetails.email, phoneNumberFromAPI: contactDetails.phoneNumber, profilePicFromAPI: contactDetails.profilePic)
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                                if let id = json["id"] as? Int {
                                    contactDetailsNew.id = id
                                }
                                if let firstName = json["first_name"] as? String {
                                    contactDetailsNew.firstNameFromAPI = firstName
                                }
                                if let lastName = json["last_name"] as? String {
                                    contactDetailsNew.lastNameFromAPI = lastName
                                }
                                if let favourite = json["favorite"] as? Bool {
                                    contactDetailsNew.favouriteFromAPI = favourite
                                }
                                if let profilePic = json["profile_pic"] as? String {
                                    contactDetailsNew.profilePicFromAPI = profilePic
                                }
                                if let email = json["email"] as? String {
                                    contactDetailsNew.emailFromAPI = email
                                }
                                if let phone_number = json["phone_number"] as? String {
                                    contactDetailsNew.phoneNumberFromAPI = phone_number
                                }
                                self.requestHandler?.onUpdateContactDetailsSuccess(contactDetails: contactDetails)
                                print("Updated")
                            }
                        } catch let error as NSError {
                            self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                            print("Failed to load: \(error.localizedDescription)")
                    }
                    break
                case 422:
                    self.requestHandler?.onError(message: "Validation error")
                    break
                case 404:
                    self.requestHandler?.onError(message: "Contact Not Found")
                    break
                case 500:
                    self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                    break
                default:
                    self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                    }
                }
                break
            case .failure(let error):
                self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                print(error)
                break
            }
        }
        datatask.resume()
    }
    
    //MARK: POST Add Contact /contacts.json
    func addContactDetailsAPI(contactDetails: ContactDetails){
        let apiUrl = URL(string: Path().contacts)!
        var urlUpdateRequest = URLRequest(url: apiUrl)
        urlUpdateRequest.httpMethod = "POST"
        urlUpdateRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(contactDetails)
            urlUpdateRequest.httpBody = jsonData
        }
        catch let err {
            self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
            print(err)
        }
        let datatask = URLSession.shared.dataTask(with: urlUpdateRequest) { (result) in
            switch result {
            case .success( let response,let data):
                // Handle Data and Response
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                        case 201:
                            do {
                                var contactDetailsNew:ContactDetails = ContactDetails(id: contactDetails.id, firstNameFromAPI: contactDetails.firstName, lastNameFromAPI: contactDetails.lastName, favouriteFromAPI: contactDetails.favourite, emailFromAPI: contactDetails.email, phoneNumberFromAPI: contactDetails.phoneNumber, profilePicFromAPI: contactDetails.profilePic)
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                                    if let id = json["id"] as? Int {
                                        contactDetailsNew.id = id
                                    }
                                    if let firstName = json["first_name"] as? String {
                                        contactDetailsNew.firstNameFromAPI = firstName
                                    }
                                    if let lastName = json["last_name"] as? String {
                                        contactDetailsNew.lastNameFromAPI = lastName
                                    }
                                    if let favourite = json["favorite"] as? Bool {
                                        contactDetailsNew.favouriteFromAPI = favourite
                                    }
                                    if let profilePic = json["profile_pic"] as? String {
                                        contactDetailsNew.profilePicFromAPI = profilePic
                                    }
                                    self.requestHandler?.onAddedContactDetailsSuccess(contactDetails: contactDetailsNew)
                                    print("Added")
                                }
                            } catch let error as NSError {
                                self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                                print("Failed to load: \(error.localizedDescription)")
                            }
                        break
                    case 422:
                        self.requestHandler?.onError(message: "Validation error")
                        break
                    case 404:
                        self.requestHandler?.onError(message: "Contact Not Found")
                        break
                    case 500:
                        self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                        break
                    default:
                        self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                        break
                    }
                }
                break
            case .failure(let error):
                // Handle Error
                self.requestHandler?.onError(message: "INTERNAL_SERVER_ERROR")
                print(error)
                break
            }
        }
        datatask.resume()
    }
}



