//
//  CGRectExtension.swift
//  Caravaggio
//
//  Created by Mert Buran on 26/07/2015.
//  Copyright © 2015 Mert Buran. All rights reserved.
//

import UIKit

extension CGRect {
    init(center: CGPoint, radius: CGFloat) {
        let origin = CGPoint(x: center.x - radius, y: center.y - radius)
        let size = CGSize(width: radius*2.0, height: radius*2.0)
        self.init(origin: origin, size: size)
    }
}
