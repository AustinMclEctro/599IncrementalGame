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
    var selectionFeedback = UISelectionFeedbackGenerator()
    var feedbackGenerator = UIImpactFeedbackGenerator();
    var nextColor: CGColor {
        get {
            curIndex += 1;
            return ringColors[curIndex%ringColors.count].cgColor;
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
    
    let upgradeOne: UILabel;
    let upgradeTwo: UILabel;
    let upgradeThree: UILabel;
    let upgradesStack: UIStackView;
    override init(frame: CGRect) {
        var thirdHeight = (frame.height-(circleStroke*2))/3;
        upgradeOne = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width-(circleStroke*3), height: 10))
        upgradeTwo = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width-(circleStroke*3), height: 10))
        upgradeThree = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width-(circleStroke*3), height: 10))
        upgradeOne.textAlignment = .center;
        upgradeTwo.textAlignment = .center;
        upgradeThree.textAlignment = .center;
        upgradeOne.textColor = .white;
        upgradeTwo.textColor = .white;
        upgradeThree.textColor = .white;
        upgradeOne.backgroundColor = .black;
        upgradeTwo.backgroundColor = .black
        upgradeThree.backgroundColor = .black
        upgradesStack = UIStackView(frame: CGRect(x: circleStroke*1.5, y: circleStroke*1.5, width: frame.width-(circleStroke*3), height: thirdHeight*3))
        upgradesStack.axis = .vertical;
        upgradesStack.addArrangedSubview(upgradeOne);
        upgradesStack.addArrangedSubview(upgradeTwo);
        upgradesStack.addArrangedSubview(upgradeThree);
        upgradesStack.alignment = .fill;
        upgradesStack.distribution = .fillEqually;
        
        
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
    var availUpgrades: [Int] = [];
    func updatesFor(gameObject: GameObject?) {
        if (gameObject != nil) {
            // TODO: if fixture
            availUpgrades = [];
            upgradeOne.textColor = .gray;
            upgradeTwo.textColor = .gray;
            upgradeThree.textColor = .gray;
            if let shape = gameObject as? Shape {
                if (shape.canUpgradeA()) {
                    availUpgrades.append(1);
                    upgradeOne.textColor = .white;
                }
                if (shape.canUpgradeB()) {
                    availUpgrades.append(2);
                    upgradeTwo.textColor = .white;
                }
                if (shape.canUpgradeC()) {
                    availUpgrades.append(3);
                    upgradeThree.textColor = .white;
                }
            }
            else if let fixt = gameObject as? Fixture {
                
            }
            self.addSubview(upgradesStack);
            
            upgradeOne.text = "Upgrade 1";
            upgradeTwo.text = "Upgrade 2";
            upgradeThree.text = "Upgrade 3";
        }
        else {
            lastUpgrade = nil;
            upgradesStack.removeFromSuperview()
            
        }
    }
    var lastUpgrade: Int? = nil;
    
    func updatesPos(pos: CGPoint) {
        upgradeThree.backgroundColor = .black;
        upgradeTwo.backgroundColor = .black;
        upgradeOne.backgroundColor = .black;
        var fr = upgradeThree.frame;
        var newLastUpgrade: Int? = nil;
        if upgradeThree.frame.contains(pos) && availUpgrades.index(of: 3) != nil {
            // Upgrade 3
            newLastUpgrade = 3;
            upgradeThree.backgroundColor = UIColor.green;
        }
        else if upgradeTwo.frame.contains(pos) && availUpgrades.index(of: 2) != nil {
            // Upgrade 2
            newLastUpgrade = 2;
            upgradeTwo.backgroundColor = UIColor.green;
        }
        else if upgradeOne.frame.contains(pos) && availUpgrades.index(of: 1) != nil {
            // Upgrade 1
            newLastUpgrade = 1;
            upgradeOne.backgroundColor = UIColor.green;
        }
        if newLastUpgrade != lastUpgrade {
            selectionFeedback.prepare();
            selectionFeedback.selectionChanged()
        }
        lastUpgrade = newLastUpgrade;
    }
    func pathFor(pos: CGPoint) -> Int {
        if upgradeThree.frame.contains(pos) && availUpgrades.index(of: 3) != nil {
            // Upgrade 3
            return 3
        }
        else if upgradeTwo.frame.contains(pos) && availUpgrades.index(of: 2) != nil {
            // Upgrade 2
            return 2
        }
        else if upgradeOne.frame.contains(pos) && availUpgrades.index(of: 1) != nil {
            // Upgrade 1
            return 1
        }
        return -1;
    }
    
}


