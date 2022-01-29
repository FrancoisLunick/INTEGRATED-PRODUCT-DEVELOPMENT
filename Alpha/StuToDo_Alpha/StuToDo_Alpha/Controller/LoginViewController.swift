//
//  LoginViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/28/22.
//

import UIKit
import Combine

class LoginViewController: UIViewController, Animations {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var requirementsLabel: UILabel!
    
    
    weak var loginDelegate: LoginDelegate?
    private let authManager = AuthManager()
    private var subscribers = Set<AnyCancellable>()
    
    @Published var errorString: String = ""
    @Published var isLoginSuccessful = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        validateForm()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.becomeFirstResponder()
        
    }
    
    private func validateForm() {
        
        $errorString.sink { [unowned self] (errorMessage) in
            self.requirementsLabel.text = errorMessage
        }.store(in: &subscribers)
        
        $isLoginSuccessful.sink { [unowned self] (isSuccessful) in
            if isSuccessful {
                self.loginDelegate?.didLogin()
            }
        }.store(in: &subscribers)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else {
            errorString = "Login Incomplete"
            return }
        
        errorString = ""
        showLoadingAnimation()
        
        authManager.login(with: email, password: password) { [weak self] (result) in
            self?.hideLoadingAnimation()
            switch result {
            case .success:
                self?.isLoginSuccessful = true
            case .failure(let error):
                self?.errorString = error.localizedDescription
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        showLoadingAnimation()
        
        let email = "JaneDoe@gmail.com"
        let password = "123456"
        
        authManager.login(with: email, password: password) { [weak self] result in
            
            self?.hideLoadingAnimation()
            
            switch result {
            case .success:
                self?.loginDelegate?.didLogin()
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription, duration: 3.0)
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

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}
