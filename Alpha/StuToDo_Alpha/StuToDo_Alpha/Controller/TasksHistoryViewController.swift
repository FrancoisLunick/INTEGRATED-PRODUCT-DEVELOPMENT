//
//  TasksHistoryViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/25/22.
//

import UIKit

class TasksHistoryViewController: UIViewController, Animations {
    
    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    
    private var databaseManager = DatabaseManager()
    
    private var tasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTasksListener()
    }
    
    // MARK: - Helpers
    
    private func addTasksListener() {
        
        databaseManager.addTaskListener(isDone: true) { [weak self] result in
            
            switch result {
                
            case .success(let tasks):
                self?.tasks = tasks
                
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription)
            }
        }
    }
    
    private func handleTaskCheck(for task: Task) {
        
        guard let id = task.id else { return }
        
        databaseManager.updateStatus(id: id, isDone: false) { [weak self] result in
            
            switch result {
            case .success:
                self?.toast(loafState: .info, message: "Task Moved To Ongoing", duration: 1.5)
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension TasksHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? TasksHistoryTableViewCell else {
            
            return tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        }
        
        let task = tasks[indexPath.row]
        
        cell.didTapCheck = { [weak self] in
            
            self?.handleTaskCheck(for: task)
            print("\(task.id), \(task.title), \(task.createdAt), \(task.note)")
            
        }
        
        cell.configure(with: task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let taskDetailViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskDetail") as! TaskDetailViewController
        
        taskDetailViewController.task = tasks[indexPath.row]
        
        self.navigationController?.pushViewController(taskDetailViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension TasksHistoryViewController: UITableViewDelegate {
    
}
