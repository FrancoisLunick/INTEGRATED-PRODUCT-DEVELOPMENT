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
        taskNotesLabel.text = "01/26/20 Dummy task note"
    }
    
    // MARK: - Actions
    
    @IBAction func CheckDidTapped(_ sender: UIButton) {
        
        didTapCheck?()
        
    }
    
}
