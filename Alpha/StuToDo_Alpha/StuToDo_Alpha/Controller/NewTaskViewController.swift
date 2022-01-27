//
//  NewTaskViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/25/22.
//

import UIKit
import Combine
import FSCalendar

class NewTaskViewController: UIViewController {

    @IBOutlet weak var addTitleTextField: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var taskNote: UITextView!
    @IBOutlet weak var CalendarUIView: CalendarView!
    @IBOutlet weak var showCalendarButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    private var subscribers = Set<AnyCancellable>()
    
    @Published private var titleString: String?
    @Published private var dueDate: Date?
    
    private lazy var calendarView: CalendarView = {
        
        let view = CalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.calendarViewDelegate = self
        
        return view
        
    }()
    
    private let databaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validateNewTaskForm()

        addTitleTextField.delegate = self
        self.tabBarController?.tabBar.isHidden = true
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
        
        $dueDate.sink { date in
            
            self.dateLabel.text = date?.toString() ?? ""
        }.store(in: &subscribers)
    }
    
//    private func setupGestures() {
//
//        let tapGestures = UITapGestureRecognizer(target: self, action: <#T##Selector?#>)
//    }
//
//    @objc private func
    
    private func displayCalendar() {
        
        let margins = view.layoutMarginsGuide
        
        view.addSubview(calendarView)
        //calendarUIView.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 2),
            calendarView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 2),
            calendarView.bottomAnchor.constraint(equalTo: taskNote.topAnchor, constant: 2),
            calendarView.topAnchor.constraint(equalTo: showCalendarButton.bottomAnchor),
            //calendarView.heightAnchor.constraint(equalToConstant: 222),
            CalendarUIView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let onGoingViewController = storyBoard.instantiateViewController(withIdentifier: "TaskScreen") as! OnGoingTasksViewController
        
        self.navigationController?.dismiss(animated: true)
        
        self.navigationController?.pushViewController(onGoingViewController, animated: true)
        
    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        
        addTitleTextField.resignFirstResponder()
        
        displayCalendar()
        
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        
//        guard let titleString = self.titleString else {
//            return
//        }
//
//        let task = Task(title: titleString)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let onGoingViewController = storyBoard.instantiateViewController(withIdentifier: "TaskScreen") as! OnGoingTasksViewController
        
        //let noteString = taskNote.text
        
        let task = Task()
        
        task.id = UUID().uuidString
        task.createdAt = Date()
        task.title = addTitleTextField.text!
        task.note = taskNote.text
        task.isDone = false
        
        saveTaskToFirestore(task)
        
        addTitleTextField.text = ""
        
        self.navigationController?.dismiss(animated: true)
        
//        if noteString!.isEmpty {
//
//            task.note = "No additional text"
//            saveTaskToFirestore(task)
//
//            //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//
//
//            //self.present(onGoingViewController, animated: true, completion: nil)
//            self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.pushViewController(onGoingViewController, animated: true)
     
//
//        } else {
//
//            saveTaskToFirestore(task)
//
//            //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//
//            //self.present(onGoingViewController, animated: true, completion: nil)
//            self.navigationController?.popToRootViewController(animated: true)
//
//        }
        
        //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
        

    }
    
    private func dismissCalendarView(completion: () -> Void) {
        calendarView.removeFromSuperview()
        completion()
    }
}

extension NewTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}

extension NewTaskViewController: CalendarViewDelegate {
    
    func didSelectDate(date: Date) {
        
        self.dueDate = date
        
    }
    
    func didTapRemoveButton() {
        
        dismissCalendarView {
            
            self.dueDate = nil
        }
    }
    
    
}
