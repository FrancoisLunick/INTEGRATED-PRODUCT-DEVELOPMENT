//
//  TasksHistoryTableViewCell.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/26/22.
//

import UIKit

class TasksHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskNotesLabel: UILabel!
    
    var didTapCheck: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with task: Task) {
        
        taskTitleLabel.text = task.title
        taskNotesLabel.text = "01/26/20 Dummy task note"
        
    }
    @IBAction func CheckDidTapped(_ sender: UIButton) {
        
        didTapCheck?()
        
    }
    
}
