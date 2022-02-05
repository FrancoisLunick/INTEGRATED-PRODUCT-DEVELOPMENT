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
    
    func signUp(with email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
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
    
    func resetPassword(with email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        auth.sendPasswordReset(withEmail: email) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success(()))
                
            }
            
        }
        
    }
    
    func changePassword(with email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        
        auth.currentUser?.reauthenticate(with: credential, completion: { Result, error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        })
        
    }
    
    func changeEmail(with email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        
        auth.currentUser?.reauthenticate(with: credential, completion: { Result, error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        })
    }
}
