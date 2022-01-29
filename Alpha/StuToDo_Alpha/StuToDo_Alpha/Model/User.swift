//
//  User.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/29/22.
//

import Foundation

struct User {
    
    let uid: String
    let profileImageUrl: String
    let firstName: String
    let lastName: String
    let age: String
    let university: String
    let email: String
    
    init(dictionary: [String: Any]) {
        
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.firstName = dictionary["firstname"] as? String ?? ""
        self.lastName = dictionary["lastname"] as? String ?? ""
        self.age = dictionary["age"] as? String ?? ""
        self.university = dictionary["university"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
    }
}
