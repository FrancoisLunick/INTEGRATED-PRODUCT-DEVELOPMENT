//
//  ChangeEmailViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 2/4/22.
//

import UIKit
import Firebase

class ChangeEmailViewController: UIViewController, Animations {

    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var currentEmailTextField: UITextField!
    
    public var user: User?
    
    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newEmailTextField.delegate = self
        currentEmailTextField.delegate = self
        currentPasswordTextField.delegate = self
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let tap = UIGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
//        view.addGestureRecognizer(tap)
//    }
    
    private func getData() {
        
    }
    
    private func logoutUser() {
        
        authManager.logout { [unowned self] result in
            
            switch result {
            case .success:
                // Dismiss Screen
                navigationManager.show(scene: .onboarding)
                
            case .failure(let error):
                toast(loafState: .error, message: error.localizedDescription, duration: 3.0)
            }
        }
        
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        
        guard let currentEmail = currentEmailTextField.text, currentEmail != "",
              let newEmail = newEmailTextField.text, newEmail != "",
              let currentPassword = currentPasswordTextField.text, currentPassword != "" else { return }
        
        let currentUser = Auth.auth().currentUser
        
        authManager.changeEmail(with: currentEmail, password: currentPassword) { [weak self] result in
            
            switch result {
                
            case .success:
                
                //self?.emailSentLabel.text = "An email has been sent to reset your password. Please check your inbox and follow the instruction to reset your password"
                
                //self?.emailTextField.text = ""
                
                
                
                currentUser?.updateEmail(to: newEmail, completion: { error in
                    
                    if let error = error {
                        
                        print(error.localizedDescription)
                        
                    }
                })
                
                guard let user = self?.user else {
                    return
                }
                
                guard let email = self?.newEmailTextField.text,
                      let firstName = self?.user?.firstName,
                      let lastName = self?.user?.lastName,
                      let age = self?.user?.age,
                      let university = self?.user?.university else { return }
                
                let data = ["email": email,
                            "firstname": firstName,
                            "lastname": lastName,
                            "age": age,
                            "university": university,
                            "uid": user.uid,
                            "profileImageUrl": user.profileImageUrl] as [String : Any]
                
                COLLECTION_USERS.document(user.uid).setData(data) { error in
                    
                    if let error = error {
                        
                        self?.toast(loafState: .error, message: error.localizedDescription, duration: 3.0)
                        //print("Failed to upload image with error \(error.localizedDescription)")
                        return
                    }
                    
                    
                }
                
                self?.toast(loafState: .info, message: "Your email has been changed")
                
                self?.logoutUser()
                
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func CloseButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChangeEmailViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true

    }

}
