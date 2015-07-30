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
    
    func numberOfSections(sender: CaravaggioButton) -> Int
    func radiusForSectionItems(sender: CaravaggioButton, section: Int) -> CGFloat
    func sizeForButton(sender: CaravaggioButton) -> CGSize
}

@objc protocol CaravaggioDelegate {
    func userDidSelectColor(sender: CaravaggioButton, color: UIColor?)
}

enum CaravaggioPosition {
    case TopLeft, TopRight, BottomLeft, BottomRight
    private var rotationAngle: CGFloat {
        switch self {
        case .TopLeft:
            return 0.0
        case .TopRight:
            return CGFloat(M_PI_2)
        case .BottomLeft:
            return CGFloat(M_PI_2 * 3.0)
        case .BottomRight:
            return CGFloat(M_PI)
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
    
    class ColorItemView: UIView {
        private let outerCircleThickness: CGFloat = 1.0
        private var colorView: UIView?
        override init(frame: CGRect) {
            super.init(frame: frame)
            var innerFrame = frame
            innerFrame.origin.x = outerCircleThickness
            innerFrame.origin.y = outerCircleThickness
            innerFrame.size.width -= outerCircleThickness * 2.0
            innerFrame.size.height -= outerCircleThickness * 2.0
            self.colorView = UIView(frame: innerFrame)
            self.addSubview(self.colorView!)
            self.backgroundColor = UIColor.whiteColor()
        }

        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var color: UIColor? {
            didSet {
                if let colorView = self.colorView {
                    colorView.backgroundColor = color
                }
            }
        }
        
        override func beCircle() {
            super.beCircle()
            if let colorView = self.colorView {
                colorView.beCircle()
            }
        }
    }
    
    private let angleRange = CGFloat(M_PI_2)
    private let marginBetweenItems: CGFloat = 8.0
    private let marginBetweenBelts: CGFloat = 20.0
    
    @IBInspectable var TopPosition: Bool = true
    @IBInspectable var LeftPosition: Bool = true
    var viewPosition: CaravaggioPosition {
        get {
            if self.LeftPosition && self.TopPosition {return CaravaggioPosition.TopLeft}
            else if self.LeftPosition && !self.TopPosition {return CaravaggioPosition.BottomLeft}
            else if !self.LeftPosition && self.TopPosition {return CaravaggioPosition.TopRight}
            else if !self.LeftPosition && !self.TopPosition {return CaravaggioPosition.BottomRight}
            else {return CaravaggioPosition.BottomRight}
        }
    }
    private var viewState: CaravaggioState = CaravaggioState.Default {
        didSet {
            self.updateSize()
            switch self.viewState {
            case .Default:
                self.itemsContainerView.hidden = true
            case .Expanded:
                self.itemsContainerView.hidden = false
            }
        }
    }
    
    @IBOutlet weak var delegate: CaravaggioDelegate?
    @IBOutlet weak var dataSource: CaravaggioDataSource? {
        didSet {
            let buttonSize: CGSize = self.dataSource!.sizeForButton(self)
            self.button.setSizeConstraints(width: buttonSize.width, height: buttonSize.height)
            self.drawItems()
        }
    }
    
    private let itemsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        view.hidden = true
        return view
        }()
    
    private let button: MBButton = {
        let button: MBButton = MBButton.buttonWithType(UIButtonType.Custom) as! MBButton
        let inset: CGFloat = 3.0
        button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        button.setImage(UIImage(named: "caravaggio_icon"), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.redColor()
        button.layer.masksToBounds = true
        return button
        }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        self.addSubview(self.itemsContainerView)
        self.addSubview(self.button)
        self.pinEdgesOfSubview(self.button, edges: self.viewPosition.edgesToPin)
        self.pinEdgesOfViews(view1: self.itemsContainerView, view2: self.button, edges: self.viewPosition.edgesToPin)
        
        self.button.addTarget(self, action: Selector("toggleViewState"), forControlEvents: UIControlEvents.TouchUpInside)
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("containerViewTapped:"))
        self.itemsContainerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateSize()
    }
    
    func containerViewTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            let tappedPoint: CGPoint = sender.locationInView(view)
            if var tappedView: UIView = view.hitTest(tappedPoint, withEvent: nil) {
                var tappedColorItemView: ColorItemView?
                while tappedView.superview != nil {
                    if tappedView.isKindOfClass(ColorItemView) {
                        tappedColorItemView = tappedView as? ColorItemView
                        break
                    }
                    else {
                        tappedView = tappedView.superview!
                    }
                }
                if tappedColorItemView != nil && self.delegate != nil {
                    self.delegate!.userDidSelectColor(self, color: tappedColorItemView!.color)
                    self.toggleViewState()
                }
            }
        }
    }
    
    private func drawItems() {
        assert(self.dataSource != nil, "data source must be non-nil!")
        var itemFramesMatrix: [[CGRect]] = []
        var maxItemRadius: CGFloat = 0.0
        let buttonRadius: CGFloat = max(self.dataSource!.sizeForButton(self).width, self.dataSource!.sizeForButton(self).height) / 2.0
        var beltRadius: CGFloat = buttonRadius
        let numberOfSections = self.dataSource!.numberOfSections(self)-1
        //loop for sections
        for sectionIndex in 0...numberOfSections {
            var sectionItemFramesArray: [CGRect] = []
            let previousSectionItemRadius = self.safeItemRadius(sectionIndex-1)
            let currentSectionItemRadius = self.safeItemRadius(sectionIndex)
            maxItemRadius = max(maxItemRadius, currentSectionItemRadius)
            var numberOfItemsAddedInCurrentSection = 0
            let numberOfItemsInCurrentSection = self.dataSource!.numberOfItems(self, section: sectionIndex)
            //loop for items in one section
            while numberOfItemsAddedInCurrentSection < numberOfItemsInCurrentSection {
                beltRadius += previousSectionItemRadius + marginBetweenBelts + currentSectionItemRadius
                let numberOfItemsInCurrentBelt = self.numberOfItemsFitsToBelt(radius: beltRadius, itemRadius: currentSectionItemRadius, marginBetweenItems: marginBetweenItems)
                var currentAngle: CGFloat = 0.0
                let incrementAngle: CGFloat = angleRange / CGFloat(numberOfItemsInCurrentBelt - 1)
                //loop for items in one belt
                for _ in 0...numberOfItemsInCurrentBelt-1 {
                    let itemCenterPoint: CGPoint = self.createPoint(beltRadius: beltRadius, angle: currentAngle)
                    let itemFrame: CGRect = CGRect(center: itemCenterPoint, radius: currentSectionItemRadius)
                    sectionItemFramesArray.append(itemFrame)
                    currentAngle += incrementAngle
                }
                //loop for items in one belt ends
                numberOfItemsAddedInCurrentSection += numberOfItemsInCurrentBelt
            }
            //loop for items in one section ends
            itemFramesMatrix.append(sectionItemFramesArray)
        }
        //loop for sections ends
        let transposedItemFramesArray: [[CGRect]] = transposeFramesWithOffset(itemFramesMatrix, offset: maxItemRadius)
        self.drawColorItemViews(transposedItemFramesArray)
        self.resizeContainerView(beltRadius: beltRadius + maxItemRadius * 2.0)
    }
    
    private func colorItemView(#frame: CGRect, index: Int, section: Int) -> ColorItemView {
        let itemView: ColorItemView = ColorItemView(frame: frame)
        itemView.color = self.dataSource!.color(self, index: index, section: section)
        itemView.beCircle()
        return itemView
    }
    
    private func resizeContainerView(#beltRadius: CGFloat) {
        self.itemsContainerView.setSize(width: beltRadius, height: beltRadius)
        let transform = CGAffineTransformMakeRotation(self.viewPosition.rotationAngle)
        self.itemsContainerView.transform = transform
    }
    
    private func updateSize() {
        self.invalidateIntrinsicContentSize()
    }
    
    func toggleViewState() {
        if dataSource != nil {
            self.viewState = self.viewState.toggledState
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        switch self.viewState {
        case .Default:
            return self.button.bounds.size
        case .Expanded:
            return self.itemsContainerView.bounds.size
        }
    }

    private func safeItemRadius(sectionIndex: Int) -> CGFloat {
        if sectionIndex < 0 || sectionIndex >= self.dataSource!.numberOfSections(self) {return 0.0}
        else {return self.dataSource!.radiusForSectionItems(self, section: sectionIndex)}
    }
    
    private func transposeFramesWithOffset(framesMatrix:[[CGRect]] , offset: CGFloat) -> [[CGRect]] {
        //warning: this is a workaround that allows container view to cover all the items in it
        //this functions slides all the items to a point at which they can be covered by container view
        let transposedItemFramesArray: [[CGRect]] = framesMatrix.map { (framesArray: [CGRect]) -> [CGRect] in
            return framesArray.map({ (frame: CGRect) -> CGRect in
                var newOrigin = frame.origin
                newOrigin.x += offset
                newOrigin.y += offset
                return CGRect(origin: newOrigin, size: frame.size)
            })
        }
        return transposedItemFramesArray
    }
    
    private func drawColorItemViews(framesMatrix: [[CGRect]]) {
        for (sectionIndex, framesArray) in enumerate(framesMatrix) {
            for (itemIndex, frame) in enumerate(framesArray) {
                let itemView: ColorItemView = self.colorItemView(frame: frame, index: itemIndex, section: sectionIndex)
                self.itemsContainerView.addSubview(itemView)
            }
        }
    }

    //MARK: Math helper functions
    private func numberOfItemsFitsToBelt(#radius: CGFloat, itemRadius: CGFloat, marginBetweenItems: CGFloat) -> Int {
        let angle: CGFloat = asin((itemRadius + marginBetweenItems/2.0) / radius) * 2.0
        return Int(angleRange / angle)
    }
    
    private func createPoint(beltRadius radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = cos(angle) * radius
        let y = sin(angle) * radius
        let point = CGPoint(x: x, y: y)
        return point
    }
    
}
