//
//  DatabaseManager.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/26/22.
//

import FirebaseFirestore

class DatabaseManager {
    
    private let db = Firestore.firestore()
    
    private lazy var tasksCollection = db.collection("tasks")
    
    func addTask(_ task: Task, completion: (Result<Void, Error) -> Void) {
        
        try tasksCollection.addDocument(data: <#T##[String : Any]#>, completion: T##((Error?) -> Void)?)
        
    }
    
}
