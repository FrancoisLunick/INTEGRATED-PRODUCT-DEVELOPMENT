//
//  Animations.swift
//  StuToDo_Alpha
//
//  Created by Lunick Francois on 1/27/22.
//

import Foundation
import Loaf
import MBProgressHUD

protocol Animations {
    
    
}

extension Animations where Self: UIViewController {
    
    func toast(loafState: Loaf.State, message: String, loafLocation: Loaf.Location = .top, duration: TimeInterval = 1.0) {
        
        DispatchQueue.main.async {
            
            Loaf(message, state: loafState, location: loafLocation, sender: self).show(.custom(duration))
            
        }
        
    }
    
}
