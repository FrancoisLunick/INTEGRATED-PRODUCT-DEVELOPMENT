//
//  Service.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/29/22.
//

import Firebase

struct Service {
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        
        var users = [User]()
        
        COLLECTION_USERS.getDocuments { snapshot, error in
            
            snapshot?.documents.forEach({ document in
                
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                
                users.append(user)
                
                completion(users)
            })
        }
        
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            
            guard let dictionary = snapshot?.data() else { return }
            
            let user = User(dictionary: dictionary)
            
            completion(user)
        }
        
    }
    
    //static func updateUser(withUid uid: String, )
    
}
