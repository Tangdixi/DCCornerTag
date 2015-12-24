//
//  DCCornerTag.swift
//  Example-DCDate
//
//  Created by Tangdixi on 19/12/2015.
//  Copyright © 2015 Tangdixi. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import Darwin

@IBDesignable

class DCCornerTag: UIView {
    
    private lazy var tagShapePath:UIBezierPath =  {
       
        let type:CornerType = CornerType(rawValue: self.cornerType)!
        
        return type.shapePathInRect(self.bounds)
        
    }()
    private lazy var tagShape:CAShapeLayer = {
        
        var shape = CAShapeLayer()
        
        shape.frame = self.bounds
        shape.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shape.path = self.tagShapePath.CGPath
        
        return shape
        
    }()
    private lazy var tagLabel:UILabel = {
        
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 30))
        
        let type:TagDirection = TagDirection(rawValue: self.tagDirection)!
        
        label.center = type.labelCenterPoint(self.bounds)
        label.transform = CGAffineTransformMakeRotation(type.labelRotationAngel())

        label.textAlignment = NSTextAlignment.Center
        
        return label
        
    }()
    
    @IBInspectable var tagTextColor:UIColor = UIColor.redColor() {
        
        willSet (newColor) {
            
            self.tagLabel.textColor = newColor
            
        }
        
    }
    
    @IBInspectable var tagLabelText:String = "tag" {
        
        willSet (newText) {
            
            self.tagLabel.text = newText
            
        }
        
    }
    
    @IBInspectable var borderWidth:CGFloat = 1.0 {
        
        willSet (newValue) {
            
            self.tagShape.lineWidth = newValue
            
        }
        
    }
    
    @IBInspectable var tagBackgroundColor:UIColor = UIColor.redColor() {
        
        willSet (newColor) {
            
            self.tagShape.fillColor = newColor.CGColor
            
        }
        
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.redColor() {
        
        willSet (newColor) {
            
            self.tagShape.strokeColor = newColor.CGColor
            
        }
        
    }
    
    @IBInspectable var tagDirection:Int = 0 {
        
        willSet {
            
            let type = TagDirection(rawValue: newValue)!
        
            let transform = CATransform3DMakeRotation(type.shapeRotationAngel(), 0, 0, 1.0)
            self.tagShape.transform = transform
            
        }
        
    }
    
    @IBInspectable var cornerType:Int = 0 {
        
        willSet {
            
            let type:CornerType = CornerType(rawValue: newValue)!
            
            self.tagShapePath = type.shapePathInRect(self.bounds)
            
        }
        
    }
    
    override func drawRect(rect: CGRect) {
        
        self.backgroundColor = UIColor.clearColor()
        
        self.layer.addSublayer(self.tagShape)
        self .addSubview(self.tagLabel)
        
    }
    
    #if !TARGET_INTERFACE_BUILDER
    
    init(frame:CGRect, tagDirection:TagDirection, cornerType:CornerType) {
        
        self.tagDirection = tagDirection.rawValue
        self.cornerType = cornerType.rawValue
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    #endif
    
}

enum CornerType:Int {
    
    case Triangle = 0
    case Trapezium = 1
    
    func shapePathInRect(bounds:CGRect) -> UIBezierPath {
        
        let shapePath = UIBezierPath()
        
        switch self {
            
        case .Triangle:
            
            shapePath.moveToPoint(CGPoint(x: 0, y: 0))
            shapePath.addLineToPoint(CGPoint(x:0, y:bounds.size.height))
            shapePath.addLineToPoint(CGPoint(x: bounds.size.width, y: 0))
            shapePath.addLineToPoint(CGPoint(x: 0, y: 0))
            
            return shapePath
            
        case .Trapezium:
            
            shapePath.moveToPoint(CGPoint(x: 0, y: bounds.size.height * (1 - goldRatio)))
            shapePath.addLineToPoint(CGPoint(x: 0, y: bounds.size.height))
            shapePath.addLineToPoint(CGPoint(x: bounds.size.width, y: 0))
            shapePath.addLineToPoint(CGPoint(x: bounds.size.width * (1 - goldRatio), y: 0))
            shapePath.addLineToPoint(CGPoint(x: 0, y: bounds.size.height * (1 - goldRatio)))
            
            return shapePath
            
        }
        
    }
}

enum TagDirection:Int {
    
    case TopLeft = 0
    case TopRight = 1
    case BottomLeft = 2
    case BottomRight = 3
    
    func shapeRotationAngel() -> CGFloat {
        
        switch self {
            
        case .TopLeft:
            return 0.0
        case .TopRight:
            return CGFloat(M_PI_2)
        case .BottomLeft:
            return -CGFloat(M_PI_2)
        case .BottomRight:
            return CGFloat(M_PI)
            
        }
        
    }
    
    func labelCenterPoint(bounds:CGRect) -> CGPoint {
        
        switch self {
            
        case .TopLeft:
            
            let x = (bounds.size.width * (1 - goldRatio/2))/2
            let y = x
            
            return CGPoint(x: x, y: y)
            
        case .TopRight:
            let x = bounds.size.width - (bounds.size.width * (1 - goldRatio/2))/2
            let y = (bounds.size.width * (1 - goldRatio/2))/2
            
            return CGPoint(x: x, y: y)
            
        case .BottomLeft:
            
            let x = (bounds.size.width * (1 - goldRatio/2))/2
            let y = bounds.size.height - (bounds.size.height * (1 - goldRatio/2))/2
            
            return CGPoint(x: x, y: y)

            
        case .BottomRight:
            
            let x = bounds.size.width - (bounds.size.width * (1 - goldRatio/2))/2
            let y = x
            
            return CGPoint(x: x, y: y)

        }
        
    }
    
    func labelRotationAngel() -> CGFloat {
        
        switch self {
            
        case .TopLeft:
            return -CGFloat(M_PI_4)
        case .TopRight:
            return CGFloat(M_PI_4)
        case .BottomLeft:
            return CGFloat(M_PI_4)
        case .BottomRight:
            return -CGFloat(M_PI_4)
            
        }
        
    }
}

private var goldRatio:CGFloat = 0.618


