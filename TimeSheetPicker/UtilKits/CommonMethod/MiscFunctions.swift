//
//  MiscFunctions.swift
//  TimeSheetPicker
//
//  Created by Mohamed Maail Rasheed on 7/26/16.
//  Copyright © 2016 DeliveLee. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    // Recursive remove subviews and constraints
    func removeSubviews() {
        self.subviews.forEach({
            if !($0 is UILayoutSupport) {
                $0.removeSubviews()
                $0.removeFromSuperview()
            }
        })
        
    }
    
    // Recursive remove subviews and constraints
    func removeSubviewsAndConstraints() {
        self.subviews.forEach({
            $0.removeSubviewsAndConstraints()
            $0.removeConstraints($0.constraints)
            $0.removeFromSuperview()
        })
    }
    
}

