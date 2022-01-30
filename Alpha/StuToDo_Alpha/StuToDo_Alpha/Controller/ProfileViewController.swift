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
    //@IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared
    
    private var user: User? {
        didSet {
            populateUserData()
        }
    }
    
    private var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageButton.imageView?.clipsToBounds = true
        profileImageButton.clipsToBounds = true

        self.tabBarController?.tabBar.isHidden = true
        
        fetchUser()
        populateUserData()
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func editUserTapped(_ sender: UIButton) {
        
        let fields: [UITextField] = [firstNameTextField, lastNameTextField, ageTextField, universityTextField, emailTextField]
        
        for field in fields {
            
            field.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func saveChangesTapped(_ sender: UIButton) {
        
        guard let profileImage = profileImage else {
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
        
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        
        handleProfileImage()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        
        logoutUser()
        
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
