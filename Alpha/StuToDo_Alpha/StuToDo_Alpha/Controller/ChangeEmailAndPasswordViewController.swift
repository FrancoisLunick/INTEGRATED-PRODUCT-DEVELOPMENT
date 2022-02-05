//
//  ChangeEmailAndPasswordViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 2/4/22.
//

import UIKit

class ChangeEmailAndPasswordViewController: UIViewController {

    public var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func CloseButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toChangeEmail" {
            
            if let destination = segue.destination as? ChangeEmailViewController {
                
                destination.user = user
                
            }
            
        } else if segue.identifier == "toChangePassword" {
            
            if let destination = segue.destination as? ChangePasswordViewController {
                
                destination.user = user
                
            }
            
        }
        
    }
    

}
