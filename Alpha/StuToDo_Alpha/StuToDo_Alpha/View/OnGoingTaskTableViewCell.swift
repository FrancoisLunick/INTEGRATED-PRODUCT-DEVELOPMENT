//
//  OnGoingTaskTableViewCell.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/26/22.
//

import UIKit

class OnGoingTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskNote: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueReminderLabel: UILabel!
    
    var didTapTaskCircle: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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
    
    @IBAction func taskCircleTapped(_ sender: UIButton) {
        
        didTapTaskCircle?()
    }
    
}
