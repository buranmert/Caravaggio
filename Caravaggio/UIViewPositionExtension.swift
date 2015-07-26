//
//  UIView+Autolayout.swift
//  Caravaggio
//
//  Created by Mert Buran on 26/07/2015.
//  Copyright © 2015 Mert Buran. All rights reserved.
//

import UIKit

extension UIView {
    
    func beCircle() {
        let radius = min(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.0
        self.layer.cornerRadius = radius
    }
    
    func pinEdgesOfViews(view1 view1: UIView, view2: UIView, edges:[NSLayoutAttribute]) {
        assert(view1.superview != nil && view2.superview != nil && view1.superview!.isEqual(view2.superview), "both views must have the same superview!")
        view1.translatesAutoresizingMaskIntoConstraints = false
        view2.translatesAutoresizingMaskIntoConstraints = false
        let constraintsArray = edges.map { (edge: NSLayoutAttribute) -> NSLayoutConstraint in
            let constraint: NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: edge, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: edge, multiplier: 1.0, constant: 0.0)
            return constraint
        }
        self.addConstraints(constraintsArray)
    }
    
    func pinEdgesOfSubview(subview: UIView, edges:[NSLayoutAttribute]) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let constraintsArray = edges.map { (edge: NSLayoutAttribute) -> NSLayoutConstraint in
            let constraint: NSLayoutConstraint = NSLayoutConstraint(item: subview, attribute: edge, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: edge, multiplier: 1.0, constant: 0.0)
            return constraint
        }
        self.addConstraints(constraintsArray)
    }
    
    func setWidth(width: CGFloat) -> NSLayoutConstraint {
        let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(widthConstraint)
        return widthConstraint
    }
    
    func setHeight(height: CGFloat) -> NSLayoutConstraint {
        let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: height)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(heightConstraint)
        return heightConstraint
    }
    
    func setSize(width width: CGFloat, height: CGFloat) {
        self.setWidth(width)
        self.setHeight(height)
    }
}
