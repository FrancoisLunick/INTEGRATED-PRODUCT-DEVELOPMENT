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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func taskCircleTapped(_ sender: UIButton) {
        
    }
    
}