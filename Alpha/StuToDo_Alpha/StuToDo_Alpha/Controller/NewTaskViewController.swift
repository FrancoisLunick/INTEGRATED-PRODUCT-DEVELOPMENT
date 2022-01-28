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
    
    // MARK: - Properties

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
    
    // MARK: - View Lifecycles
    
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
    
    // MARK: - Helpers
    
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
    
    private func displayCalendar() {
        
        let margins = view.layoutMarginsGuide
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 2),
            calendarView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 2),
            calendarView.bottomAnchor.constraint(equalTo: taskNote.topAnchor, constant: 2),
            calendarView.topAnchor.constraint(equalTo: showCalendarButton.bottomAnchor),
            //calendarView.heightAnchor.constraint(equalToConstant: 222),
            CalendarUIView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func dismissCalendarView(completion: () -> Void) {
        calendarView.removeFromSuperview()
        completion()
    }
    
    // MARK: - Actions
    
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
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        
        
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let onGoingViewController = storyBoard.instantiateViewController(withIdentifier: "TaskScreen") as! OnGoingTasksViewController
        let onGoingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabScreen")
        
        let task = Task()
        
        task.id = UUID().uuidString
        task.createdAt = Date()
        task.title = addTitleTextField.text!
        task.note = taskNote.text
        task.isDone = false
        task.dueDate = dueDate
        
        saveTaskToFirestore(task)
        
        addTitleTextField.text = ""
        
        self.navigationController?.dismiss(animated: true)
        
        self.navigationController?.pushViewController(onGoingViewController, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension NewTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - CalendarViewDelegate

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
