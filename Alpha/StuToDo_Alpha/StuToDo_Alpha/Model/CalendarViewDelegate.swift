//
//  CalendarViewDelegate.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/27/22.
//

import Foundation

protocol CalendarViewDelegate: class {
    func didSelectDate(date: Date)
    func didTapRemoveButton()
}
