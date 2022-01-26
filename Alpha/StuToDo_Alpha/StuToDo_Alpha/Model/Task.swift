//
//  Task.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/26/22.
//

import Foundation
import FirebaseFirestore

class Task: Codable {
    
    //var id: ObjectIdentifier
    var id: String?
    var createdAt: Date?
    let title: String!
    
    init() {
        
    }
    
    init(dictionary: NSDictionary) {
        
        title = dictionary["title"] as? String
        
    }
    
}

func saveTaskToFirestore
