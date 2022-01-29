//
//  ProfileViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/28/22.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, Animations {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var universityTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageButton: UIButton!
    
    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared
    
    private var user: User? {
        didSet {
            populateUserData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        universityTextField.text = user.age
        emailTextField.text = user.email
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        
        let profileImage: UIImageView!
        profileImage = nil
        
        let profileUIImage: UIImage
        profileUIImage
        
        profileImage.load(url: url)
        
        profileImageButton.setImage(profileImage, for: .normal)
        
    }
    
    func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Service.fetchUser(withUid: uid) { user in
            
            self.user = user
            
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
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        
        logoutUser()
        
    }
    
}
