//
//  CalendarView.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/27/22.
//

import UIKit
import FSCalendar

class CalendarView: UIView {
    
    weak var calendarViewDelegate: CalendarViewDelegate?
    
    private lazy var fsCalendar: FSCalendar = {
        
        let fsCalendar = FSCalendar()
        fsCalendar.delegate = self
        fsCalendar.translatesAutoresizingMaskIntoConstraints = false
        return fsCalendar
        
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select deadline"
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(removeCalendar(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, fsCalendar, removeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setup()
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func selectDate(date: Date?) {
        fsCalendar.select(date, scrollToDate: true)
    }
    
    private func setup() {
        
        backgroundColor = .white
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            fsCalendar.heightAnchor.constraint(equalToConstant: 230),
            titleLabel.heightAnchor.constraint(equalToConstant: 12),
            removeButton.heightAnchor.constraint(equalToConstant: 12)
        ])
        
    }
    

    
    @objc func removeCalendar(_ sender: UIButton) {
        
        
        if let selectedDate = fsCalendar.selectedDate {
            
            fsCalendar.deselect(selectedDate)
            calendarViewDelegate?.didTapRemoveButton()
            
        }
        
    }

}

extension CalendarView: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendarViewDelegate?.didSelectDate(date: date)
        
        print("Date selected \(date)")
        
    }
    
}
