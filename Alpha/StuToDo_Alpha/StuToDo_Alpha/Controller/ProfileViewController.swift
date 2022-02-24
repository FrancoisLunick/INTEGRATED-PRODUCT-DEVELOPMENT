//
//  ProfileViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/28/22.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController, Animations {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var universityTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared
    
    private var profileImageUrl = ""
    
    private var user: User? {
        didSet {
            populateUserData()
        }
    }
    
    private var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        
        let fields: [UITextField] = [firstNameTextField,
                                     lastNameTextField,
                                     ageTextField,
                                     universityTextField,
                                     emailTextField]
        
        for field in fields {
            
            field.delegate = self
            
        }
        
        saveChangesButton.isHidden = true
        profileImageButton.isEnabled = false
        
        profileImageButton.imageView?.clipsToBounds = true
        profileImageButton.clipsToBounds = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        fetchUser()
        populateUserData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        
        ageTextField.inputAccessoryView = toolBar
        
    }
    
    @objc private func doneTapped() {
        
        view.endEditing(true)
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
    
    private func populateUserData() {
        
        guard let user = user else { return }
        
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        ageTextField.text = user.age
        universityTextField.text = user.university
        emailTextField.text = user.email
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        
        profileImageButton.layer.cornerRadius = 200 / 2
        profileImageButton.layer.borderWidth = 3.0
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        
        profileImageButton.sd_setImage(with: url, for: .normal)
        
    }
    
    func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Service.fetchUser(withUid: uid) { user in
            
            self.user = user
            
        }
        
    }
    
    private func handleProfileImage() {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toChangeCredentials" {
            
            if let destination = segue.destination as? ChangeEmailAndPasswordViewController {
                
                destination.user = user
                
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func editUserTapped(_ sender: UIButton) {
        
        editButton.isHidden = true
        
        profileImageButton.isEnabled = true
        
        let fields: [UITextField] = [firstNameTextField, lastNameTextField, ageTextField, universityTextField]
        
        for field in fields {
            
            field.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func saveChangesTapped(_ sender: UIButton) {
        
        editButton.isHidden = false
        
        guard let profileImage = profileImage ?? profileImageButton.currentImage else {
            return
        }
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { meta, error in
            
            if let error = error {
                
                self.toast(loafState: .error, message: error.localizedDescription, duration: 3.0)
                //print("Failed to upload image with error \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                
                guard let profileImageUrl = url?.absoluteString else {
                    
                    return
                }
                
                guard let user = self.user else {
                    return
                }
                
               
                
                guard let email = self.emailTextField.text,
                      let firstName = self.firstNameTextField.text,
                      let lastName = self.lastNameTextField.text,
                      let age = self.ageTextField.text,
                      let university = self.universityTextField.text else { return }
                
                let data = ["email": email,
                            "firstname": firstName,
                            "lastname": lastName,
                            "age": age,
                            "university": university,
                            "uid": user.uid,
                            "profileImageUrl": profileImageUrl] as [String : Any]
                
                COLLECTION_USERS.document(user.uid).setData(data) { error in
                    
                    if let error = error {
                        
                        self.toast(loafState: .error, message: error.localizedDescription, duration: 3.0)
                        //print("Failed to upload image with error \(error.localizedDescription)")
                        return
                    }
                    
                }
                
            }
            
        }
        
        let fields: [UITextField] = [firstNameTextField,
                                     lastNameTextField,
                                     ageTextField,
                                     universityTextField]
        
        for field in fields {
            
            field.isUserInteractionEnabled = false
        }
        
        saveChangesButton.isHidden = true
        
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        
        handleProfileImage()
        
        saveChangesButton.isHidden = false
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        
        logoutUser()
        
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: UITextField) {
        
        saveChangesButton.isHidden = false
    }
    
    func handleDeleteUser() async {
        
        
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        
        navigationManager.show(scene: .tasks)
        
    }
    
    @IBAction func deleteProfile(_ sender: UIButton) {
        
        
        
        let alert = UIAlertController(title: "Delete Profile?", message: "This action can't be undone are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Delete profile",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
            
            let currentUser = Auth.auth().currentUser
            
            currentUser?.delete() { error in
                
                if let error = error {
                    
                    //self.toast(loafState: .error, message: error.localizedDescription)
                    
                    print(error.localizedDescription)
                    
                } else {
                    
                    do {
                        COLLECTION_USERS.document(currentUser!.uid).delete()
                        self.navigationManager.show(scene: .onboarding)
                    }
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    
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

extension ProfileViewController: UIImagePickerControllerDelegate {
    
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

extension ProfileViewController: UINavigationControllerDelegate {
    
    
    
}
