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
    
    func showLoadingAnimation() {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3)
        }
    }
    
    func hideLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
}
