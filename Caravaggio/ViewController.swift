//
//  ViewController.swift
//  Caravaggio
//
//  Created by Mert Buran on 25/07/2015.
//  Copyright © 2015 Mert Buran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CaravaggioDataSource {

    @IBOutlet weak var caravaggioButton: CaravaggioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caravaggioButton.dataSource = self
    }
    
    func color(sender: CaravaggioButton, index: Int, section: Int) -> UIColor {
        return UIColor.purpleColor()
    }
    
    func numberOfItems(sender: CaravaggioButton, section: Int) -> Int {
        return 3
    }

}

