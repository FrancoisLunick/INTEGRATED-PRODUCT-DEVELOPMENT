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
    
    init() {
        
    }
    
    init(dictionary: NSDictionary) {
        
        id = dictionary["taskID"] as? String
        createdAt = dictionary["createdAt"] as? String
        title = dictionary["title"] as? String
        note = dictionary["note"] as? String
        
    }
    
}

func saveTaskToFirestore(_ task: Task) {
    
    FBReference(.Tasks).document(task.id).setData(taskDictionaryFrom(task) as! [String : Any])
}

func taskDictionaryFrom(_ task: Task) -> NSDictionary {
    
    return NSDictionary(objects: [task.id, task.createdAt, task.title, task.note], forKeys: ["taskID" as NSCopying, "createdAt" as NSCopying, "title" as NSCopying, "note" as NSCopying])
    
}

func downloadTasksFromFirebase(_ withTaskId: String, completion: @escaping (_ tasks: [Task]) -> Void) {
    
    var tasks: [Task] = []
    
    FBReference(.Tasks).whereField("taskID", isEqualTo: withTaskId).getDocuments { snapchat, error in
        
        guard let snapchat = snapchat else {
            
            completion(tasks)
            return
        }
        
        if !snapchat.isEmpty {
            
            for taskDictionary in snapchat.documents {
                
                tasks.append(Task(dictionary: taskDictionary.data() as NSDictionary))
            }
        }
        
        completion(tasks)
    }
}
