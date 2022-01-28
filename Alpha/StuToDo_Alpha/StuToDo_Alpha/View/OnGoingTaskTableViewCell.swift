//
//  OnGoingTaskTableViewCell.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/26/22.
//

import UIKit

class OnGoingTaskTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskNote: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueReminderLabel: UILabel!
    
    var didTapTaskCircle: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    // MARK: - Helpers
    
    func configure(with task: Task) {
        
        taskTitle.text = task.title
        taskNote.text = task.note
        dueDateLabel.text = task.dueDate?.toString()
        dueReminderLabel.text = task.dueDate?.toRelativeString()
        
        if task.dueDate?.isOverDue() == true {
            dueDateLabel.textColor = .red
            dueDateLabel.font = UIFont(name: "AvenirNext-Medium", size: 12)
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func taskCircleTapped(_ sender: UIButton) {
        
        didTapTaskCircle?()
    }
    
}
