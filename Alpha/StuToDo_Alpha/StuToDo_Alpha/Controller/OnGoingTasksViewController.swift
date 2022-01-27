//
//  OnGoingTasksViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/25/22.
//

import UIKit
import FirebaseFirestore

class OnGoingTasksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var taskModel: Task?
    var databaseManager: DatabaseManager?
    
    private var tasks: [Task] = [] {
        
        didSet {
            
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        loadTasks()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func loadTasks() {
        
        let db = Firestore.firestore()
        
        db.collection("Tasks").getDocuments { snapshot, error in
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async {
                        
                        self.tasks = snapshot.documents.map { doc in
                            
                            return Task(id: doc.documentID, createdAt: doc["createdAt"] as? String ?? "", title: doc["title"] as? String ?? "", note: doc["note"] as? String ?? "", isDone: doc["isDone"] as? Bool ?? false)
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
        
        databaseManager?.updateTaskToDone(id: id, completion: { result in
            
            switch result {
                
            case .success:
                print("Success")
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
        
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
    
}

extension OnGoingTasksViewController: UITableViewDelegate {
    
}
