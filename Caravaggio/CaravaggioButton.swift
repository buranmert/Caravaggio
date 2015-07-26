//
//  CaravaggioButton.swift
//  Caravaggio
//
//  Created by Mert Buran on 25/07/2015.
//  Copyright © 2015 Mert Buran. All rights reserved.
//

import UIKit

@objc protocol CaravaggioDataSource {
    func color(sender: CaravaggioButton, index: Int, section: Int) -> UIColor
    func numberOfItems(sender: CaravaggioButton, section: Int) -> Int
    
    optional func numberOfSections(sender: CaravaggioButton) -> Int
    optional func radiusForSectionItems(sender: CaravaggioButton, section: Int) -> CGFloat
    optional func sizeForButton(sender: CaravaggioButton) -> CGSize
}

extension CaravaggioDataSource {
    func numberOfSections(sender: CaravaggioButton) -> Int {return 1}
    func radiusForSectionItems(sender: CaravaggioButton, section: Int) -> CGFloat {return 40.0}
    func sizeForButton(sender: CaravaggioButton) -> CGSize {return CGSize(width: 44.0, height: 44.0)}
}

enum CaravaggioPosition {
    case TopLeft, TopRight, BottomLeft, BottomRight
    private var startingAngle: CGFloat {
        switch self {
        case .TopLeft:
            return CGFloat(M_PI)
        case .TopRight:
            return CGFloat(M_PI_2 * 3.0)
        case .BottomLeft:
            return CGFloat(M_PI_2)
        case .BottomRight:
            return 0.0
        }
    }
    private var edgesToPin: [NSLayoutAttribute] {
        switch self {
        case .TopLeft:
            return [NSLayoutAttribute.Top, NSLayoutAttribute.Left]
        case .TopRight:
            return [NSLayoutAttribute.Top, NSLayoutAttribute.Right]
        case .BottomLeft:
            return [NSLayoutAttribute.Bottom, NSLayoutAttribute.Left]
        case .BottomRight:
            return [NSLayoutAttribute.Bottom, NSLayoutAttribute.Right]
        }
    }
}

private enum CaravaggioState {
    case Default, Expanded
    var toggledState: CaravaggioState {
        switch self {
        case .Default:
            return CaravaggioState.Expanded
        case .Expanded:
            return CaravaggioState.Default
        }
    }
}

@IBDesignable class CaravaggioButton: UIView {
    
    private let angleRange = CGFloat(M_PI_2)
    private let marginBetweenItems: CGFloat = 3.0
    private let marginBetweenBelts: CGFloat = 4.0
    
    var viewPosition: CaravaggioPosition = CaravaggioPosition.TopRight
    private var viewState: CaravaggioState = CaravaggioState.Default {
        didSet {
            self.updateSize()
        }
    }
    
    private var itemViews: [UIView] = []
    @IBOutlet weak var dataSource: CaravaggioDataSource? {
        didSet {
            let buttonSize: CGSize = self.dataSource!.sizeForButton(self)
            self.button.setSizeConstraints(width: buttonSize.width, height: buttonSize.height)
            self.drawItems()
        }
    }
    
    private let itemsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.greenColor()
        return view
        }()
    
    private let button: MBButton = {
        let button = MBButton(type: UIButtonType.Custom)
        button.backgroundColor = UIColor.redColor()
        return button
        }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = false
        self.addButtonAndContainerView()
    }
    
    func addButtonAndContainerView() {
        self.addSubview(self.button)
        self.pinEdgesOfSubview(self.button, edges: self.viewPosition.edgesToPin)
        self.button.addTarget(self, action: Selector("toggleViewState"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.itemsContainerView)
        self.itemsContainerView.setSize(width: 200.0, height: 200.0)
        self.pinEdgesOfViews(view1: self.itemsContainerView, view2: self.button, edges: self.viewPosition.edgesToPin)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateSize()
    }
    
    func drawItems() {
        assert(self.dataSource != nil, "data source must be non-nil!")
//        var beltIndex = 0
        for sectionIndex in 0...self.dataSource!.numberOfSections(self)-1 {
            let itemRadius = self.dataSource!.radiusForSectionItems(self, section: sectionIndex)
            let beltRadius: CGFloat = 200.0
            let numberOfItemsInCurrentBelt = self.numberOfItemsFitsToBelt(radius: beltRadius, itemRadius: itemRadius, marginBetweenItems: marginBetweenItems)
            assert(numberOfItemsInCurrentBelt > 1, "only 1 item in belt is not handled yet!")
            var currentAngle: CGFloat = self.viewPosition.startingAngle
            let incrementAngle: CGFloat = angleRange / CGFloat(numberOfItemsInCurrentBelt - 1)
            for _ in 0...numberOfItemsInCurrentBelt-1 {
                let itemCenterPoint: CGPoint = self.point(beltRadius: beltRadius, angle: currentAngle)
                currentAngle += incrementAngle
                let itemView: UIView = UIView(center: itemCenterPoint, radius: itemRadius)
                itemView.backgroundColor = UIColor.purpleColor()
                self.itemsContainerView.addSubview(itemView)
                self.itemViews.append(itemView)
            }
        }
        
    }
    
    func updateSize() {
        self.invalidateIntrinsicContentSize()
    }
    
    func toggleViewState() {
        self.viewState = self.viewState.toggledState
    }
    
    override func intrinsicContentSize() -> CGSize {
        switch self.viewState {
        case .Default:
            return self.button.bounds.size
        case .Expanded:
            return self.itemsContainerView.bounds.size
        }
    }
    
    
    //MARK: Math helper functions
    private func numberOfItemsFitsToBelt(radius radius: CGFloat, itemRadius: CGFloat, marginBetweenItems: CGFloat) -> Int {
        let angle: CGFloat = asin((itemRadius + marginBetweenItems/2.0) / radius) * 2.0
        return Int(angleRange / angle)
    }
    
    private func point(beltRadius radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = abs(cos(angle) * radius)
        let y = abs(sin(angle) * radius)
        let point = CGPoint(x: x, y: y)
        return point
    }
}
