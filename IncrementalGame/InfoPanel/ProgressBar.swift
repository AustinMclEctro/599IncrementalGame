//
//  ProgressBar.swift
//  TestProgressBar
//
//  Created by Ben Grande on 2017-10-25.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit
/*
 TODO:
 - More colors
 - what do do after colors
 - BUG: animation delay after reset
 */
class ProgressBar: UIView {
    var ringColors: [UIColor] = [.red, .orange, .yellow, .green];
    var _currency: Int = 0;
    var needsUpdate = false;
    var curColor = UIColor.red.cgColor;
    var curIndex = 0
    var nextColor: CGColor {
        get {
            curIndex += 1;
            return ringColors[curIndex].cgColor;
        }
    }
    var currency: Int {
        set(val) {
            valLabel.text = val.toCurrency();
            var oldVal = _currency;
            _currency = val;
            var delay:Double = 0.0;
            if (val >= maxCur) { // reset and update
                updateCircleOuter(from: CGFloat(oldVal)/CGFloat(maxCur), to: 1)
                maxCur = maxCur*10;
                oldVal = 0
                delay = Double((CGFloat(val)/CGFloat(maxCur))*1.5)
                needsUpdate = true;
                backCircleLayer.strokeColor = circleLayer.strokeColor;
                let when = DispatchTime.now() + 1.5 // change 2 to desired number of seconds
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self.circleLayer.strokeEnd = 0.0
                CATransaction.commit()
                DispatchQueue.main.asyncAfter(deadline: when) {
                    if (self.needsUpdate) {
                        self.circleLayer.strokeColor = self.nextColor;
                        self.updateCircleOuter(from: 0.0, to: CGFloat(val)/CGFloat(self.maxCur), delay: delay)
                    }
                    self.needsUpdate = false;
                }
            }
            else {
                if (needsUpdate) {
                    CATransaction.begin()
                    CATransaction.setDisableActions(true)
                    circleLayer.strokeEnd = CGFloat(val)/CGFloat(maxCur)
                    CATransaction.commit()
                    circleLayer.strokeColor = nextColor;
                    needsUpdate = false;
                    updateCircleOuter(from: CGFloat(oldVal)/CGFloat(maxCur), to: CGFloat(val)/CGFloat(maxCur), delay: delay)
                }
                else {
                    updateCircleOuter(from: CGFloat(oldVal)/CGFloat(maxCur), to: CGFloat(val)/CGFloat(maxCur), delay: delay)
                }
                
            }
            lastCur = val;
            
        }
        get {
            return _currency;
        }
    }
    var lastCur: Int = 0;
    var maxCur: Int = 10
    
    
    var circleStroke: CGFloat = 10.0;
    var circleLayer: CAShapeLayer;
    var backCircleLayer: CAShapeLayer;
    var valLabel: UILabel;
    
    override init(frame: CGRect) {
        circleStroke = frame.width*0.05
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.width/2), radius: (frame.width/2)-circleStroke, startAngle: 3*CGFloat.pi/2, endAngle:7*CGFloat.pi/2, clockwise: true)
        
        // Setup progress circle
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = circleStroke
        
        // Setup the background circle
        backCircleLayer = CAShapeLayer()
        backCircleLayer.path = circlePath.cgPath
        backCircleLayer.fillColor = UIColor.clear.cgColor
        backCircleLayer.strokeColor = UIColor.clear.cgColor
        backCircleLayer.lineWidth = circleStroke
        
        valLabel = UILabel(frame: CGRect(x: frame.width/2-50, y: frame.height/2-25, width: 100, height: 50))
        valLabel.textAlignment = .center;
        
        super.init(frame: frame);
        layer.addSublayer(backCircleLayer)
        layer.addSublayer(circleLayer);
        self.addSubview(valLabel);
        currency = 0
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    @objc func tap(sender: UITapGestureRecognizer) {
        currency += 1;
    }
    
    
    
    func updateCircleOuter(from: CGFloat, to: CGFloat, delay: Double=0) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = TimeInterval((to-from)*1.5)
        animation.fromValue = from
        animation.toValue = to
        animation.beginTime = CACurrentMediaTime()+delay;
        self.circleLayer.strokeEnd = to
        circleLayer.add(animation, forKey: "animateCircle")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


