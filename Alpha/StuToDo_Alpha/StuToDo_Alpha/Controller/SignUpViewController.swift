//
//  SignUpViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/28/22.
//

import UIKit
import Combine

class SignUpViewController: UIViewController, Animations {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var universityTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var requirementsLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    
    weak var loginDelegate: LoginDelegate?
    weak var signupDelegate: SignupDelegate?
    private let authManager = AuthManager()
    private var subscribers = Set<AnyCancellable>()
    
    @Published var errorString: String = ""
    @Published var isLoginSuccessful = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validateForm()
        
        let signUpTextFields: [UITextField] = [firstNameTextField,
                                               lastNameTextField,
                                               ageTextField,
                                               universityTextField,
                                               emailTextField,
                                               passwordTextField]
        
        for signUpTextField in signUpTextFields {
            
            signUpTextField.delegate = self
        }
        
    }
    
    private func validateForm() {
        
        $errorString.sink { [unowned self] (errorMessage) in
            self.requirementsLabel.text = errorMessage
        }.store(in: &subscribers)
        
        $isLoginSuccessful.sink { [unowned self] (isSuccessful) in
            if isSuccessful {
                self.signupDelegate?.didSignup()
            }
        }.store(in: &subscribers)
    }
    
    private func handleProfileImage() {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        guard let firstName = firstNameTextField.text,
              !firstName.isEmpty,
              let lastName = lastNameTextField.text,
              !lastName.isEmpty,
              let age = ageTextField.text,
              !age.isEmpty,
              let university = universityTextField.text,
              !university.isEmpty,
              let email = emailTextField.text,
              !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else {
                  errorString = "Sign Up Form Incomplete"
                  return }
        
        errorString = ""
        showLoadingAnimation()
        
        authManager.signUp(with: email, password: password) { [weak self] (result) in
            self?.hideLoadingAnimation()
            switch result {
            case .success:
                self?.isLoginSuccessful = true
            case .failure(let error):
                self?.errorString = error.localizedDescription
            }
        }
    }
    
    @IBAction func pickImageButton(_ sender: UIButton) {
        
        handleProfileImage()
        
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

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        profileImageButton.setImage(image, for: .normal)
        profileImageButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        //profileImageButton.layer.cornerRadius = 200 / 2
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension SignUpViewController: UINavigationControllerDelegate {
    
    
    
}
