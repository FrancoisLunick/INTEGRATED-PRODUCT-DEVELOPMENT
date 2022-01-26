//
//  NewTaskViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/25/22.
//

import UIKit

class NewTaskViewController: UIViewController {

    @IBOutlet weak var addTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTitleTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addTitleTextField.becomeFirstResponder()
    }
    
//    private func setupGestures() {
//
//        let tapGestures = UITapGestureRecognizer(target: self, action: <#T##Selector?#>)
//    }
//
//    @objc private func
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}
