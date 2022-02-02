//
//  ForgotPasswordViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 2/1/22.
//

import UIKit

class ForgotPasswordViewController: UIViewController, Animations {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailSentLabel: UILabel!
    
    private let authManager = AuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        
        guard let email = emailTextField.text, email != "" else {
            return
        }
        
        authManager.resetPassword(with: email) { [weak self] result in
            
            switch result {
                
            case .success:
                
                self?.emailSentLabel.text = "An email has been sent to reset your password. Please check your inbox and follow the instruction to reset your password"
                
                self?.emailTextField.text = ""
                
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
