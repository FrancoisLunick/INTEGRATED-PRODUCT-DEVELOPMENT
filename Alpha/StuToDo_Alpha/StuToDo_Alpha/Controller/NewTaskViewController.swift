//
//  NewTaskViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/25/22.
//

import UIKit
import Combine

class NewTaskViewController: UIViewController {

    @IBOutlet weak var addTitleTextField: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!
    
    private var subscribers = Set<AnyCancellable>()
    @Published private var titleString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validateNewTaskForm()

        addTitleTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addTitleTextField.becomeFirstResponder()
    }
    
    private func validateNewTaskForm() {
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification).map({
            
            ($0.object as? UITextField)?.text
            
        }).sink { [unowned self] text in
            
            self.titleString = text
            
        }.store(in: &subscribers)
        
        $titleString.sink { [unowned self] text in
            
            self.addTaskButton.isEnabled = text?.isEmpty == false
            
        }.store(in: &subscribers)
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
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        
        guard let titleString = self.titleString else {
            return
        }
        
        let task = Task(title: titleString)

    }
}

extension NewTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}
