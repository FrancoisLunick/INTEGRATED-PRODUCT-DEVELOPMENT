//
//  DatabaseManager.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/26/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class DatabaseManager {
    
    private var listener: ListenerRegistration?
    
    private let db = Firestore.firestore()

    private lazy var tasksCollection = db.collection("Tasks")
//    
//    func addTask(_ task: Task, completion: (Result<Void, Error>) -> Void) {
//
//        try tasksCollection.addDocument(data: <#T##[String : Any]#>, completion: T##((Error?) -> Void)?)
//
//    }
    
    func addTaskListener(isDone: Bool, completion: @escaping (Result<[Task], Error>) -> Void) {

        listener = tasksCollection
            .whereField("isDone", isEqualTo: isDone)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener({ snapshot, error in

            if let error = error {

                completion(.failure(error))

            } else {
                
                var tasks = [Task]()
                
                do {
                    
                    tasks = try snapshot?.documents.compactMap({
                        
                        return try $0.data(as: Task.self)
                        
                    }) ?? []
                    
                } catch(let error) {
                    
                    completion(.failure(error))
                    
                }
                
                completion(.success(tasks))
            }

        })

    }
    
    func updateTaskToDone(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let fields: [String : Any] = ["isDone" : true, "completedAt" : Date()]
        tasksCollection.document(id).updateData(fields) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success(()))
                
            }
        }
        
    }
    
}
