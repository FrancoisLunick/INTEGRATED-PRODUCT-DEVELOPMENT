//
//  OnGoingTasksViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/25/22.
//

import UIKit
import FirebaseFirestore
import Loaf
import EventKit
import EventKitUI
import Reachability
import ViewAnimator

protocol OnGoingDelegate {
    
}

class OnGoingTasksViewController: UIViewController, Animations {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskModel: Task!
    private var databaseManager = DatabaseManager()
    weak var editTaskDelegate: EditTaskDelegate?
    private let authManager = AuthManager()
    
    let store = EKEventStore()
    
    let reachability = try! Reachability()
    
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
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addTasksListener()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        
        do {
            
            try reachability.startNotifier()
            
        } catch {
            
            print("Unable to start notifier")
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        reachability.stopNotifier()
        
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
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
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            print("show share sheets")
            
            let location = sender.location(in: tableView)
            
            if let indexPath = tableView.indexPathForRow(at: location) {
                
                let taskTitle = tasks[indexPath.row].title
                //let taskNote = tasks[indexPath.row].note
                let taskDueDate = tasks[indexPath.row].dueDate?.toString()
                let shareMessage = taskTitle! + " is due on " + taskDueDate!
                
                let taskTitleToShare = [ shareMessage ]
                let activityViewController = UIActivityViewController(activityItems: taskTitleToShare, applicationActivities: nil)
                
                activityViewController.excludedActivityTypes = [.message]
                
                self.present(activityViewController, animated: true, completion: nil)
                
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
    
//    private func handleShareTask() {
//
//        let indexPath = IndexPath()
//
//        let taskTitle = tasks[indexPath.row].title
//
//        print(taskTitle)
//    }
    
    private func handleDeleteTask(indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Delete Task?", message: "This action can't be undone are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Delete Task",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
            
            guard let id = self.tasks[indexPath.row].id else { return }
            
            self.databaseManager.deleteTask(id: id) { [weak self] result in
                
                switch result {
                    
                case .success:
                    self?.toast(loafState: .error, message: "Task successfully deleted")
                    
                case .failure(let error):
                    self?.toast(loafState: .error, message: error.localizedDescription)
                    
                }
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    private func handleAddToCalendar(indexPath: IndexPath) {
        
        store.requestAccess(to: .event) { [weak self] success, error in
            
            if success, error == nil {
                
                DispatchQueue.main.async {
                    
                    guard let store = self?.store else {
                        return
                    }
                    
                    let newEvent = EKEvent(eventStore: store)
                    
                    newEvent.title = self?.tasks[indexPath.row].title
                    newEvent.startDate = self?.tasks[indexPath.row].dueDate
                    newEvent.endDate = self?.tasks[indexPath.row].dueDate
                    newEvent.notes = self?.tasks[indexPath.row].note
                    newEvent.isAllDay = true
                    
                    let eventEditVC = EKEventEditViewController()
                    eventEditVC.editViewDelegate = self
                    eventEditVC.eventStore = store
                    eventEditVC.event = newEvent
                    
                    self?.present(eventEditVC, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    @objc private func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
            
        case .wifi:
            print("Wifi connection")
        case .cellular:
            print("Cellular connection")
        case .unavailable:
            toast(loafState: .error, message: "No connection. Please connect to the internet to continue", duration: 5.0)
        default:
            print("No connection")
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
        
        //let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
        let animation = AnimationType.from(direction: .top, offset: 30.0)
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        
        let cells = [cell]
        //var duration = 0
        
        UIView.animate(views: cells, animations: [animation, zoomAnimation])
          
        
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

// MARK: - EKEventViewDelegate

extension OnGoingTasksViewController: EKEventViewDelegate {
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
}

// MARK: - EKEventEditViewDelegate

extension OnGoingTasksViewController: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}

