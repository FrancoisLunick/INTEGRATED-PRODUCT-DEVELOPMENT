//
//  TaskDetailViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/27/22.
//

import UIKit

class TaskDetailViewController: UIViewController, Animations {

    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    var task: Task!
    private var databaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tabBarController?.tabBar.isHidden = true
        
        setupUI()

    }
    
    private func setupUI() {
        
        if task != nil {
            
            taskTitleLabel.text = task.title
            dateLabel.text = "01/22/2022"
            timeLabel.text = "10:32 PM"
            notesLabel.text = "Notes"
            
        }
        
    }
    
    private func deleteTaskHelper(_ id: String) {
        
        databaseManager.deleteTask(id: id) { [weak self] result in
            
            switch result {
                
            case .success:
                self?.toast(loafState: .error, message: "Task successfully deleted")
                
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription)
                
            }
            
        }
        
    }
    
    @IBAction func deleteTask(_ sender: UIButton) {
        
        guard let id = task.id else { return }
        
        deleteTaskHelper(id)
    }
    
    @IBAction func editTask(_ sender: UIButton) {
    }
    
    
}
