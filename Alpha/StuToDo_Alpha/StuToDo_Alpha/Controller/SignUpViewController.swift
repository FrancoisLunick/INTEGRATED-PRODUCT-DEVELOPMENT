//
//  SignUpViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/28/22.
//

import UIKit
import Combine
import Firebase

class SignUpViewController: UIViewController, Animations {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var universityTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var requirementsLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    
    private var profileImage: UIImage?
    
    weak var loginDelegate: LoginDelegate?
    weak var signupDelegate: SignupDelegate?
    private let authManager = AuthManager()
    private var subscribers = Set<AnyCancellable>()
    
    @Published var errorString: String = ""
    @Published var isLoginSuccessful = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageButton.imageView?.clipsToBounds = true
        profileImageButton.clipsToBounds = true

        setupTextFields()
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
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        
    }
    
    private func setupTextFields() {
        
        let toolBar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        toolBar.sizeToFit()
        
        //ageTextField.inputAccessoryView = toolBar
        //passwordTextField.inputAccessoryView = toolBar
        //emailTextField.inputAccessoryView = toolBar
        
    }
    
    @objc private func doneTapped() {
        
        view.endEditing(true)
    }
    
//    @objc private func textDidChange(_ sender: UITextField) {
//
//        if sender == firstNameTextField {
//
//        } else if sender == lastNameTextField {
//
//        } else if sender == ageTextField {
//
//        } else if sender == universityTextField {
//
//        } else if sender == emailTextField {
//
//        } else if sender == passwordTextField {
//
//        }
//    }
    
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
        
        guard let profileImage = profileImage ?? profileImageButton.currentImage else {
            
            self.toast(loafState: .error, message: "Profile picture is required", duration: 4.0)
            return
        }
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }

        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { meta, error in
            
            if let error = error {
                
                self.toast(loafState: .error, message: error.localizedDescription, duration: 3.0)
                
                return
            }
            
            ref.downloadURL { url, error in
                
                guard let profileImageUrl = url?.absoluteString else {
                    return
                }

                self.errorString = ""
                self.showLoadingAnimation()
                
                self.authManager.signUp(with: email, password: password) { [weak self] (result) in
                    self?.hideLoadingAnimation()
                    switch result {
                    case .success:
                        
                        guard let uid = self?.authManager.getUserId() else { return }
                        
                        let data = ["email": email,
                                    "firstname": firstName,
                                    "lastname": lastName,
                                    "age": age,
                                    "university": university,
                                    "uid": uid,
                                    "profileImageUrl": profileImageUrl] as [String : Any]
                        
                        Firestore.firestore().collection("users").document(uid).setData(data) { error in
                            
                            if let error = error {
                                
                                self?.toast(loafState: .error, message: error.localizedDescription, duration: 3.0)
                                //print("Failed to upload image with error \(error.localizedDescription)")
                                return
                            }
                            
                        }
                        
                        self?.isLoginSuccessful = true
                    case .failure(let error):
                        self?.errorString = error.localizedDescription
                    }
                }
            }
            
        }
        
        
    }
    
    @IBAction func pickImageButton(_ sender: UIButton) {
        
        handleProfileImage()
        
    }
    
    @IBAction func backToLogin(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
//    private func configureNotificationObservers() {
//
//        firstNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
//        lastNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
//        ageTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
//        universityTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
//        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
//        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
//    }
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        
        guard let StringRange = Range(range, in: currentText) else {
            return false
        }
        
        let updatedText = currentText.replacingCharacters(in: StringRange, with: string)
        
        if textField == ageTextField {
            
            return updatedText.count <= 2
            
        } else {
            
            return updatedText.count <= 40
        }
        
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        profileImage = image
        
        profileImageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        profileImageButton.layer.cornerRadius = 200 / 2
        profileImageButton.layer.borderWidth = 3.0
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension SignUpViewController: UINavigationControllerDelegate {
    
    
    
}
