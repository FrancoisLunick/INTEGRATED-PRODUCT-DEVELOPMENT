//
//  TaskDetailViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/27/22.
//

import UIKit

class TaskDetailViewController: UIViewController, Animations {

    // MARK: - Properties
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesLabel: UITextView!
    
    var task: Task!
    private var databaseManager = DatabaseManager()
    private let navigationManager = NavigationManager.shared
    
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        if task != nil {
            
            taskTitleLabel.text = task.title
            dateLabel.text = task.dueDate?.toString()
            notesLabel.text = task.note
        }
    }
    
    private func deleteTaskHelper(_ id: String) {
        
        databaseManager.deleteTask(id: id) { [weak self] result in
            
            switch result {
                
            case .success:
                self?.toast(loafState: .error, message: "Task successfully deleted")
                
                self?.navigationManager.show(scene: .tasks)
                
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription)
                
            }
            
        }
        
    }
    
    private func editTaskHelper(task: Task) {
        
        performSegue(withIdentifier: "showEditTask", sender: task)
        
    }
    
    // MARK: - Actions
    
    @IBAction func deleteTask(_ sender: UIButton) {
        
        guard let id = task.id else { return }
        
        deleteTaskHelper(id)
    }
    
    @IBAction func editTask(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showEditTask" {
            
            if let destination = segue.destination as? EditTaskViewController {
                
                destination.taskToEdit = task
            }
            
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        navigationManager.show(scene: .tasks)
    }
    
    
}
