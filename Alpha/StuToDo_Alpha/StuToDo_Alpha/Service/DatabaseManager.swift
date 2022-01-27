//
//  DatabaseManager.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/26/22.
//

import FirebaseFirestore

class DatabaseManager {
    
    private var listener: ListenerRegistration?
    
    private let db = Firestore.firestore()
//
    private lazy var tasksCollection = db.collection("Tasks")
//    
//    func addTask(_ task: Task, completion: (Result<Void, Error>) -> Void) {
//
//        try tasksCollection.addDocument(data: <#T##[String : Any]#>, completion: T##((Error?) -> Void)?)
//
//    }
    
//    func addTaskListener(completion: (Result<Void, Error>) -> Void) {
//
//        listener = tasksCollection.addSnapshotListener({ snapchat, error in
//
//            if let error = error {
//
//                completion(.failure(error))
//
//            } else {
//                
//                var tempTasks = [Task]()
//
//                snapchat?.documents.forEach({ queryDocumentSnapshot in
//
//                    if let task = try? queryDocumentSnapshot.data(as: Task.self) {
//                        
//                        tempTasks.append(task)
//                        
//                    }
//
//                })
//                
//                completion(.success(tempTasks))
//            }
//
//        })
//
//    }
    
    func updateTaskToDone(id: String, completion: (Result<Void, Error>) -> Void) {
        
        
        
    }
    
}
