//
//  EditTaskDelegate.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/27/22.
//

import Foundation

protocol EditTaskDelegate: AnyObject {
    
    func sendTask(task: Task)
    
}
