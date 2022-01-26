//
//  FirebaseReference.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/26/22.
//

import Foundation
import FirebaseFirestore

enum FirebaseReference: String {
    
    case Tasks
}

func FBReference(_ reference: FirebaseReference) -> CollectionReference {
    
    return Firestore.firestore().collection(reference.rawValue)
    
}
