//
//  ViewController.swift
//  Caravaggio
//
//  Created by Mert Buran on 25/07/2015.
//  Copyright © 2015 Mert Buran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CaravaggioDataSource, CaravaggioDelegate {
    
    @IBOutlet weak var caravaggioButton: CaravaggioButton!
    @IBOutlet weak var variableColorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.caravaggioButton.dataSource = self
        self.caravaggioButton.delegate = self
    }
    
    func color(sender: CaravaggioButton, index: Int, section: Int) -> UIColor {
        let red = CGFloat(CGFloat(arc4random_uniform(256)) / 255.0)
        let green = CGFloat(CGFloat(arc4random_uniform(256)) / 255.0)
        let blue = CGFloat(CGFloat(arc4random_uniform(256)) / 255.0)
        let alpha = CGFloat(CGFloat(arc4random_uniform(256)) / 255.0)
        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func numberOfItems(sender: CaravaggioButton, section: Int) -> Int {
        switch section {
        case 0:
            return 10
        case 1:
            return 5
        case 2:
            return 4
        default:
            return 0
        }
    }
    
    func numberOfSections(sender: CaravaggioButton) -> Int {
        return 3
    }
    
    func radiusForSectionItems(sender: CaravaggioButton, section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10.0
        case 1:
            return 15.0
        case 2:
            return 10.0
        default:
            return 5.0
        }
    }
    
    func sizeForButton(sender: CaravaggioButton) -> CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }

    func userDidSelectColor(sender: CaravaggioButton, color: UIColor?) {
        if let selectedColor = color {
            self.variableColorView.backgroundColor = selectedColor
        }
    }
    
}

