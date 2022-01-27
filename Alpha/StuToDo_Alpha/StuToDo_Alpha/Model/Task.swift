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
    var id: String!
    var createdAt: String!
    var title: String!
    var note: String!
    var isDone: Bool!
    
    init() {
        
    }
    
    init(id: String, createdAt: String, title: String, note: String, isDone: Bool) {
        
        self.createdAt = createdAt
        self.title = title
        self.note = note
        self.id = id
        self.isDone = isDone
        
    }
    
    init(dictionary: NSDictionary) {
        
        id = dictionary["taskID"] as? String
        createdAt = dictionary["createdAt"] as? String
        title = dictionary["title"] as? String
        note = dictionary["note"] as? String
        isDone = dictionary["isDone"] as? Bool
        
    }
    
}

func saveTaskToFirestore(_ task: Task) {
    
    FBReference(.Tasks).document(task.id).setData(taskDictionaryFrom(task) as! [String : Any])
}

func taskDictionaryFrom(_ task: Task) -> NSDictionary {
    
    return NSDictionary(objects: [task.id, task.createdAt, task.title, task.note, task.isDone], forKeys: ["taskID" as NSCopying, "createdAt" as NSCopying, "title" as NSCopying, "note" as NSCopying, "isDone" as NSCopying])
    
}

func downloadTasksFromFirebase(_ tasks: [Task]) {
    
    var tasks: [Task] = tasks
//completion: @escaping (_ tasks: [Task]) -> Void
//
//    FBReference(.Tasks).whereField("taskID", isEqualTo: withTaskId).getDocuments { snapshot, error in
        
//        guard let snapchat = snapchat else {
//
//            completion(tasks)
//            return
//        }
//
//        if !snapchat.isEmpty {
//
//            for taskDictionary in snapchat.documents {
//
//                tasks.append(Task(dictionary: taskDictionary.data() as NSDictionary))
//            }
//        }
//        let db = Firestore.firestore()
//        let docRef = db.collection("tasks").document("title")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
        
//        if let snapshot = snapshot {
//
//            tasks = snapshot.documents.map { doc in
//
//                //tasks.append(Task(dictionary: taskDictionary.data() as NSDictionary))
//
//                return ["title" : doc.data()["title"] as! String]
//
//            }
//        }
//
        //completion(tasks)
    //}
    
    let db = Firestore.firestore()
    
    db.collection("Tasks").getDocuments { snapshot, error in
        
        if error == nil {
            
            if let snapshot = snapshot {
                
                DispatchQueue.main.async {
                    
                    tasks = snapshot.documents.map { doc in
                        
                        return Task(id: doc.documentID, createdAt: doc["createdAt"] as? String ?? "", title: doc["title"] as? String ?? "", note: doc["note"] as? String ?? "", isDone: doc["isDone"] as? Bool ?? false)
                    }
                    
                }
                
            }
            
        } else {
            
        }
    }
}
