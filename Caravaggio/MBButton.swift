//
//  MBButton.swift
//  Caravaggio
//
//  Created by Mert Buran on 26/07/2015.
//  Copyright © 2015 Mert Buran. All rights reserved.
//

import UIKit

class MBButton: UIButton {
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    func setSizeConstraints(width width: CGFloat, height: CGFloat) {
        self.setConstraintConstant(self.widthConstraint, constant: width)
        self.setConstraintConstant(self.heightConstraint, constant: height)
    }
    
    private func setConstraintConstant(var constraint: NSLayoutConstraint?, constant: CGFloat) {
        if let aConstrains = constraint {
            aConstrains.constant = constant
        }
        else {
            constraint = self.setWidth(constant)
        }
    }
}
