//
//  OnboardingViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/28/22.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let navigationManager = NavigationManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "showLoginScreen", sender: nil)
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showLoginScreen", let destination = segue.destination as? LoginViewController {
            destination.loginDelegate = self
        }
        
    }
}

extension OnboardingViewController: LoginDelegate {
    
    func didLogin() {
        
        presentedViewController?.dismiss(animated: true, completion: { [unowned self] in
            self.navigationManager.show(scene: .tasks)
        })
    }
    
}
