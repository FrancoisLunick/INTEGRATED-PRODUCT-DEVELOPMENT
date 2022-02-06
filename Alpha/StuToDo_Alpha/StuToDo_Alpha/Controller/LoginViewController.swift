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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    private let navigationManager = NavigationManager.shared
    
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
        
        emailTextField.layer.masksToBounds = false
        emailTextField.layer.shadowRadius = 3.0
        emailTextField.layer.shadowColor = UIColor.black.cgColor
        emailTextField.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        emailTextField.layer.shadowOpacity = 1.0
        
        passwordTextField.layer.masksToBounds = false
        passwordTextField.layer.shadowRadius = 3.0
        passwordTextField.layer.shadowColor = UIColor.black.cgColor
        passwordTextField.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        passwordTextField.layer.shadowOpacity = 1.0
        
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowOpacity = 1.0
        
        signUpButton.layer.shadowColor = UIColor.black.cgColor
        signUpButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        signUpButton.layer.shadowRadius = 5
        signUpButton.layer.shadowOpacity = 1.0
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
        
        performSegue(withIdentifier: "showSignupScreen", sender: nil)
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showSignupScreen", let destination = segue.destination as? SignUpViewController {
            destination.signupDelegate = self
        }
        
    }
    

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}

extension LoginViewController: SignupDelegate {
    
    func didSignup() {
        
        presentedViewController?.dismiss(animated: true, completion: { [unowned self] in
            self.navigationManager.show(scene: .tasks)
        })
    }
    
}
