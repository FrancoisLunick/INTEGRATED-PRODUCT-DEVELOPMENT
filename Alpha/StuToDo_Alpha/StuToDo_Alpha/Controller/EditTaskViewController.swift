//
//  EditTaskViewController.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/27/22.
//

import UIKit
import Combine
import FSCalendar

class EditTaskViewController: UIViewController, Animations {

    // MARK: - Properties
    
    @IBOutlet weak var addTitleTextField: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var taskNote: UITextView!
    @IBOutlet weak var CalendarUIView: CalendarView!
    @IBOutlet weak var showCalendarButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var subscribers = Set<AnyCancellable>()
    
    private let authManager = AuthManager()
    private let navigationManager = NavigationManager.shared
    
    private var user: User?
    
    var taskToEdit: Task?
    
    private var didBeginEditing = false
    
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
        
        setupViews()
        
        validateNewTaskForm()

        addTitleTextField.delegate = self
        taskNote.delegate = self
        self.tabBarController?.tabBar.isHidden = true
        
        displayCalendar()
        
        setupTextFields()
        
        if taskNote.isFocused {
            print("tasknote")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addTitleTextField.becomeFirstResponder()
    }
    
    // MARK: - Helpers
    
    private func setupTextFields() {
        
        let toolBar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        toolBar.sizeToFit()
        
        taskNote.inputAccessoryView = toolBar
        
    }
    
    private func setupViews() {
        
        if let taskToEdit = self.taskToEdit {
            
            addTitleTextField.text = taskToEdit.title
            taskNote.text = taskToEdit.note
            dateLabel.text = taskToEdit.dueDate?.toString()
            dueDate = taskToEdit.dueDate
            calendarView.selectDate(date: taskToEdit.dueDate)
        }
        
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
    
    private func dismissCalendarView(completion: () -> Void) {
        calendarView.removeFromSuperview()
        completion()
    }
    
    @objc private func doneTapped() {
        
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {

        if didBeginEditing {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {

        if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }

    }
    
    // MARK: - Actions
//    @IBAction func cancelButtonTapped(_ sender: UIButton) {
//
//        self.navigationController?.popToRootViewController(animated: true)
//
//    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        
        addTitleTextField.resignFirstResponder()
        
        displayCalendar()
        
    }
    
    @IBAction func updateTask(_ sender: UIButton) {
        
//        addTitleTextField.text = taskToEdit.title
//        taskNote.text = taskToEdit.note
//        dateLabel.text = taskToEdit.dueDate?.toString()
//        dueDate = taskToEdit.dueDate
        
        guard let taskToEdit = taskToEdit else {
            return
        }

        guard let title = self.addTitleTextField.text,
              let taskNote = self.taskNote.text,
              let date = dueDate,
              let taskId = taskToEdit.id,
              let isDone = taskToEdit.isDone,
              let uid = taskToEdit.uid else { return }
        
//        task.id = UUID().uuidString
//        task.createdAt = Date()
//        task.title = addTitleTextField.text!
//        task.note = taskNote.text
//        task.isDone = false
//        task.dueDate = dueDate
//        task.uid = uid
        
        let data = ["taskID": taskId,
                    "createdAt": Date(),
                    "title": title,
                    "note": taskNote,
                    "isDone": isDone,
                    "dueDate": date,
                    "uid": uid] as [String : Any]
        
//        let data = ["taskID": taskToEdit.id,
//                    "createdAt": Date(),
//                    "title": title,
//                    "note": taskNote,
//                    "isDone": taskToEdit.isDone
//                    "dueDate": date,
//                    "uid": user.uid] as [String : Any]
        
        COLLECTION_TASKS.document(taskToEdit.id).setData(data) { error in
            
            if let error = error {
                
                self.toast(loafState: .error, message: error.localizedDescription, duration: 3.0)
                //print("Failed to upload image with error \(error.localizedDescription)")
                return
            }
            
        }
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let onGoingViewController = storyBoard.instantiateViewController(withIdentifier: "TaskScreen") as! OnGoingTasksViewController
//
        //addTitleTextField.text = ""
        
        //self.navigationController?.dismiss(animated: true)
        //self.navigationController?.popViewController(animated: true)
        
        navigationManager.show(scene: .tasks)
    
        //self.navigationController?.pushViewController(onGoingViewController, animated: true)

    }
    
    @IBAction func closeView(_ sender: UIButton) {
        
        navigationManager.show(scene: .tasks)
        
    }
    
}

// MARK: - UITextFieldDelegate

extension EditTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}

extension EditTaskViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        
        guard let StringRange = Range(range, in: currentText) else {
            return false
        }
        
        let updatedText = currentText.replacingCharacters(in: StringRange, with: text)
        
        
        return updatedText.count <= 60
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        didBeginEditing = true
        
        textView.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        didBeginEditing = false
        
        if textView.text == "" {
            textView.text = "Add notes here..."
        }
    }
    
}

// MARK: - CalendarViewDelegate

extension EditTaskViewController: CalendarViewDelegate {
    
    func didSelectDate(date: Date) {
        
        self.dueDate = date
        
        
        
    }
    
    func didTapRemoveButton() {
        
        dismissCalendarView {
            
            self.dueDate = nil
        }
    }

}
