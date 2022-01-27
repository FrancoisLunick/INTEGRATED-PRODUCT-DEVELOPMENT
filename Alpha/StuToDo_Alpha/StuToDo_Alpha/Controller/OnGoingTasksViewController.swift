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

    @IBOutlet weak var tableView: UITableView!
    
    var taskModel: Task?
    private var databaseManager = DatabaseManager()
    
    private var tasks: [Task] = [] {
        
        didSet {
            
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        addTasksListener()


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadTasks()
    }
    
    private func addTasksListener() {
        
        databaseManager.addTaskListener(isDone: false) { [weak self] result in
            
            switch result {
                
            case .success(let tasks):
                self?.tasks = tasks
                
            case .failure(let error):
                self?.toast(loafState: .error, message: error.localizedDescription)
                
            }
        }
    }
    
    private func loadTasks() {
        
        let db = Firestore.firestore()
        
        db.collection("Tasks").getDocuments { snapshot, error in
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async {
                        
                        self.tasks = snapshot.documents.map { doc in
                            
                            return Task(id: doc.documentID, createdAt: doc["createdAt"] as? Date ?? nil, title: doc["title"] as? String ?? "", note: doc["note"] as? String ?? "", isDone: doc["isDone"] as? Bool ?? false)
                        }
                        
                    }
                    
                }
                
            } else {
                
            }
        }
        
//        let db = Firestore.firestore()
//        let docRef = db.collection("Tasks").document("")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
        
//        let db = Firestore.firestore()
//
//        db.collection("Tasks").getDocuments { snapshot, error in
//
//            if error == nil {
//
//                if let snapshot = snapshot {
//
//                    DispatchQueue.main.async {
//
//                        self.tasks = snapshot.documents.map { doc in
//
//                            return Task(id: doc.documentID, createdAt: doc["createdAt"] as? String ?? "", title: doc["title"] as? String ?? "", note: doc["note"] as? String ?? "")
//                        }
//
//                    }
//
//                }
//
//            } else {
//
//            }
//        }
        
        

//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
        
//        downloadTasksFromFirebase((taskModel?.id)!) { tasks in
//
//            self.tasks = tasks
//        }
        
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

}

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
            print("\(task.id), \(task.title), \(task.createdAt), \(task.note)")
            
        }
        
        cell.configure(with: task)
        
        //cell.taskTitle.text = task.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let taskDetailViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskDetail") as! TaskDetailViewController
        
        taskDetailViewController.task = tasks[indexPath.row]
        
        self.navigationController?.pushViewController(taskDetailViewController, animated: true)
    }
    
}

extension OnGoingTasksViewController: UITableViewDelegate {
    
}
