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
    
    func setSizeConstraints(#width: CGFloat, height: CGFloat) {
        if let wConstraint = self.widthConstraint {
            wConstraint.constant = width
        }
        else {
            self.widthConstraint = self.setWidth(width)
        }
        if let hConstraint = self.heightConstraint {
            hConstraint.constant = height
        }
        else {
            self.heightConstraint = self.setHeight(height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.beCircle()
    }
}
