//
//  TasksHistoryTableViewCell.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/26/22.
//

import UIKit

class TasksHistoryTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskNotesLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var didTapCheck: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Helpers
    
    func configure(with task: Task) {
        
        taskTitleLabel.text = task.title
        taskNotesLabel.text = task.note
        dueDateLabel.text = task.dueDate?.toString()
        completedLabel.text = task.dueDate?.toRelativeString()
        
        if task.dueDate?.isOverDue() == true {
            dueDateLabel.textColor = .red
            dueDateLabel.font = UIFont(name: "AvenirNext-Medium", size: 12)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func CheckDidTapped(_ sender: UIButton) {
        
        didTapCheck?()
        
    }
    
}
