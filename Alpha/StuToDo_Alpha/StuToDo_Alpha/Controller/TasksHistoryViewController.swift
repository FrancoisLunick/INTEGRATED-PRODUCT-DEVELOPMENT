//
//  TasksHistoryViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/25/22.
//

import UIKit
import EventKit
import EventKitUI
import ViewAnimator

class TasksHistoryViewController: UIViewController, Animations {
    
    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    
    private var databaseManager = DatabaseManager()
    private let authManager = AuthManager()
    
    private var tasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let store = EKEventStore()
    
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTasksListener()
    }
    
    // MARK: - Helpers
    
    private func addTasksListener() {
        
        guard let uid = authManager.getUserId() else { return }
        
        databaseManager.addTaskListener(isDone: true, uid: uid) { [weak self] result in
            
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
    
    private func handleEditTask(indexPath: IndexPath) {
        
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
    
    private func handleAddToCalendar(indexPath: IndexPath) {
        
//        let calendarVC = EKCalendarChooser()
//
//        calendarVC.showsDoneButton = true
//        calendarVC.showsCancelButton = true
//
//        present(UINavigationController(rootViewController: calendarVC), animated: true, completion: nil)
        
        store.requestAccess(to: .event) { [weak self] success, error in
            
            if success, error == nil {
                
                DispatchQueue.main.async {
                    
                    guard let store = self?.store else {
                        return
                    }
                    
                    let newEvent = EKEvent(eventStore: store)
                    
                    newEvent.title = self?.tasks[indexPath.row].title
                    newEvent.startDate = Date()
                    newEvent.endDate = self?.tasks[indexPath.row].dueDate
                    newEvent.notes = self?.tasks[indexPath.row].note
                    
                    let eventEditVC = EKEventEditViewController()
                    eventEditVC.editViewDelegate = self
                    eventEditVC.eventStore = store
                    eventEditVC.event = newEvent
                    
                    self?.present(eventEditVC, animated: true, completion: nil)
                    
//                    let vc = EKEventViewController()
//                    vc.delegate = self
//                    vc.event = newEvent
//
//                    let rootVC = UINavigationController(rootViewController: vc)
//
//                    self?.present(rootVC, animated: true, completion: nil)
                }
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
        
        let animation = AnimationType.from(direction: .top, offset: 30.0)
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        
        let cells = [cell]
        //var duration = 0
        
        UIView.animate(views: cells, animations: [animation, zoomAnimation])
        
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive,
                                        title: "Delete") { [weak self] action, view, handler in
            
            self?.handleDeleteTask(indexPath: indexPath)
            handler(true)
        }
        
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] action, view, handler in
            
            self?.handleEditTask(indexPath: indexPath)
            handler(true)
            
        }
        
        edit.backgroundColor = .blue
        
        let addToCalendar = UIContextualAction(style: .normal,
                                        title: "Add to Calendar") { [weak self] action, view, handler in
            
            self?.handleAddToCalendar(indexPath: indexPath)
            handler(true)
        }
        
        addToCalendar.backgroundColor = .systemGreen
        
        let configuration = UISwipeActionsConfiguration(actions: [edit, addToCalendar])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .none
    }
    
}

extension TasksHistoryViewController: EKEventViewDelegate {
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
}

extension TasksHistoryViewController: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        
        controller.dismiss(animated: true, completion: nil)
        
        
    }
    
    
}
