//
//  OnGoingTasksViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/25/22.
//

import UIKit
import FirebaseFirestore
import Loaf

protocol OnGoingDelegate {
    
}

class OnGoingTasksViewController: UIViewController, Animations {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskModel: Task!
    private var databaseManager = DatabaseManager()
    weak var editTaskDelegate: EditTaskDelegate?
    private let authManager = AuthManager()
    
    private var tasks: [Task] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            
        }
    }
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //addTasksListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadTasks()
    }
    
    // MARK: - Helpers
    
    private func addTasksListener() {
        
        guard let uid = authManager.getUserId() else { return }
        
        databaseManager.addTaskListener(isDone: false, uid: uid) { [weak self] result in
            
            switch result {
                
            case .success(let tasks):
                self?.tasks = tasks
                
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription, duration: 3.0)
            }
        }
    }
    
    private func loadTasks() {
        
        guard let uid = authManager.getUserId() else { return }
        
        let db = Firestore.firestore()
        
        db.collection("Tasks")
            .whereField("uid", isEqualTo: uid)
            .whereField("isDone", isEqualTo: false)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                
                if error == nil {
                    
                    if let snapshot = snapshot {
                        
                        DispatchQueue.main.async { [self] in
                            
                            self.tasks = snapshot.documents.map { doc in
                                var dueDate = Date()
                                
                                let firStamp = doc["dueDate"] as? Timestamp
                                
                                print(firStamp?.seconds ?? 1)
                                if let dDate = firStamp?.seconds {
                                    dueDate = Date(timeIntervalSince1970: TimeInterval(dDate))
                                    
                                    print(dueDate)
                                    
                                }
                                
                                return Task(id: doc.documentID, createdAt: doc["createdAt"] as? Date ?? nil, title: doc["title"] as? String ?? "", note: doc["note"] as? String ?? "", isDone: doc["isDone"] as? Bool ?? false, dueDate: dueDate, uid: doc["uid"] as? String ?? "")
                            }
                        }
                    }
                    
                } else {
                    
                }
            }
    }
    
    private func handleTaskCircle(for task: Task) {
        
        guard let id = task.id else { return }
        
        databaseManager.updateStatus(id: id, isDone: true) { [weak self] result in
            
            switch result {
                
            case .success:
                self?.toast(loafState: .info, message: "Task Completed", duration: 1.5)
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription)
            }
        }
        
    }
    
    private func handleEditTask(indexPath: IndexPath) {
        
        editTaskDelegate?.sendTask(task: tasks[indexPath.row])
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editTaskViewController = storyBoard.instantiateViewController(withIdentifier: "EditTask") as! EditTaskViewController
        
        editTaskViewController.taskToEdit = tasks[indexPath.row]
        
        self.navigationController?.pushViewController(editTaskViewController, animated: true)
    }
    
    private func handleDeleteTask(indexPath: IndexPath) {
        
        guard let id = tasks[indexPath.row].id else { return }
        
        databaseManager.deleteTask(id: id) { [weak self] result in
            
            switch result {
                
            case .success:
                self?.toast(loafState: .error, message: "Task successfully deleted")
                
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription)
                
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension OnGoingTasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? OnGoingTaskTableViewCell else {
            
            return tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        }
        
        let task = tasks[indexPath.row]
        
        cell.didTapTaskCircle = { [weak self] in
            
            self?.handleTaskCircle(for: task)
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

extension OnGoingTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Edit") { [weak self] action, view, handler in
            
            self?.handleEditTask(indexPath: indexPath)
            handler(true)
            
        }
        
        action.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive,
                                        title: "Delete") { [weak self] action, view, handler in
            
            self?.handleDeleteTask(indexPath: indexPath)
            handler(true)
        }
        
        delete.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .none
    }
}

