//
//  ServiceConstants.swift
//  Contacts
//
//  Created by Karthic Paramasivam on 7/2/19.
//  Copyright © 2019 Karthic. All rights reserved.
//

import Foundation

//MARK: Environment Setup
enum Environment {
    
    case development
    case staging
    case production
    
    func baseURL() -> String {
        return "\(urlProtocol())://\(domain())"
    }
    
    func urlProtocol() -> String {
        switch self {
        case .production:
            return "http"
        default:
            return "http"
        }
    }
    
    func domain() -> String {
        switch self {
        case .development, .staging, .production:
            return "contacts.com"
        }
    }
}

extension Environment {
    func host() -> String {
        return "\(self.domain())"
    }
}


// MARK:- APIs
#if DEBUG
let environment: Environment = Environment.development
#else
let environment: Environment = Environment.staging
#endif

let baseUrl = environment.baseURL()

struct Path {
    var contacts: String {return "\(baseUrl)/contacts.json"}
    var contactsCUD : String {return "\(baseUrl)/contacts/"}
}

