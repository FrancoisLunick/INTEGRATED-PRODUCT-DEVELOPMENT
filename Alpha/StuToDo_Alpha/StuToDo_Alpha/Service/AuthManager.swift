//
//  AuthManager.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/28/22.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    let auth = Auth.auth()
    
    func login(with email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getUserId() -> String? {
        
        return auth.currentUser?.uid
        
    }
    
    func isUserLoggedIn() -> Bool {
        
        return auth.currentUser != nil
        
    }
    
    func logout(completion: (Result<Void, Error>) -> Void) {
        
        do {
            try auth.signOut()
            completion(.success(()))
            
        } catch(let error) {
            completion(.failure(error))
        }
    }
}
