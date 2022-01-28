//
//  LoginViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/28/22.
//

import UIKit
import Combine

class LoginViewController: UIViewController, Animations {
    
    weak var loginDelegate: LoginDelegate?
    private let authManager = AuthManager()
    private var subscribers = Set<AnyCancellable>()
    
    @Published var errorString: String = ""
    @Published var isLoginSuccessful = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        showLoadingAnimation()
        
        let email = "JohnDoe@gmail.com"
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
