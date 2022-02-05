//
//  ChangePasswordViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 2/4/22.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController, Animations {

    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    public var user: User?
    
    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func CloseButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePasswordTapped(_ sender: UIButton) {
        
        guard let currentPassword = currentPasswordTextField.text, currentPassword != "",
              let newPassword = newPasswordTextField.text, currentPassword != "" else { return }
        
        guard let user = self.user else {
            return
        }
        
        let currentUser = Auth.auth().currentUser
        
        authManager.changePassword(with: user.email, password: currentPassword) { [weak self] result in
            
            switch result {
            case .success:
                currentUser?.updatePassword(to: newPassword, completion: { error in
                    
                    if let error = error {
                        
                        self?.toast(loafState: .error, message: error.localizedDescription)
                    }
                })
                
                self?.logoutUser()
                
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription)
            }
            
        }
        
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
