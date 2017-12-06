//
//  UpgradeShapeCell.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-11-20.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

class UpgradeShapeCell: ShopCollectionViewCell {
    var stack: UIStackView;
    let up1: UIView;
    let up2: UIView;
    let up3: UIView;
    
    let upPrice1: UILabel;
    let upPrice2: UILabel;
    let upPrice3: UILabel;
    
    let up1Button: UIButton;
    let up2Button: UIButton;
    let up3Button: UIButton;
    
    let foreground1: UIView;
    let foreground2: UIView;
    let foreground3: UIView;
    
    var _shape: Shape?;
    private var _curA: Int = 0;
    var shouldUpgrade: (Shape, Int) -> Void =  {
        _, _ in
    }
    var curA: Int {
        set(val) {
            _curA = val;
            checkUpgraes()
        }
        get {
            return _curA;
        }
    };
    func checkUpgraes() {
        foreground1.removeFromSuperview()
        foreground2.removeFromSuperview()
        foreground3.removeFromSuperview()
        if (!_shape!.canUpgradeA() || _shape!.upgradePriceA() > _curA) {
            
            foreground1.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            up1.addSubview(foreground1)
        }
        if (!_shape!.canUpgradeB() || _shape!.upgradePriceB() > _curA) {
            foreground2.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            up2.addSubview(foreground2)
        }
        if (!_shape!.canUpgradeC() || _shape!.upgradePriceC() > _curA) {
            foreground3.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            up3.addSubview(foreground3)
        }
    }
    var shape: Shape? {
        set(val) {
            
            _shape = val;
            if (val == nil) {
                return;
            }
            var a = val?.nextUpgradeANode()
            var b = val?.nextUpgradeBNode()
            var c = val?.nextUpgradeCNode()
            
            
            up1Button.setImage(a, for: .normal);
            up2Button.setImage(b, for: .normal);
            up3Button.setImage(c, for: .normal);
            upPrice1.text = val?.upgradePriceA().toCurrency();
            upPrice2.text = val?.upgradePriceB().toCurrency();
            upPrice3.text = val?.upgradePriceC().toCurrency();
            checkUpgraes();
            
        }
        get {
            return _shape;
        }
    }
    override init(frame: CGRect) {
        foreground1 = UIView(frame: CGRect(x: 0, y: 0, width: frame.width/3, height: frame.height));
        foreground2 = UIView(frame: CGRect(x: 0, y: 0, width: frame.width/3, height: frame.height));
        foreground3 = UIView(frame: CGRect(x: 0, y: 0, width: frame.width/3, height: frame.height));
        up1 = UIView(frame: CGRect(x: 0, y: 0, width: frame.width/3, height: frame.height));
        up2 = UIView(frame: CGRect(x: 0, y: 0, width: frame.width/3, height: frame.height));
        up3 = UIView(frame: CGRect(x: 0, y: 0, width: frame.width/3, height: frame.height));
        
        let buttonFrame = CGRect(x: (up1.frame.width/2)-frame.height/4, y: 10, width: frame.height/2, height: frame.height/2)
        let labelFrame = CGRect(x: 0, y: up1.frame.height-30, width: up1.frame.width, height: 30)
        upPrice1 = UILabel(frame: labelFrame)
        upPrice2 = UILabel(frame: labelFrame)
        upPrice3 = UILabel(frame: labelFrame)
        upPrice1.textAlignment = .center;
        upPrice2.textAlignment = .center;
        upPrice3.textAlignment = .center;
        upPrice1.textColor = .white;
        upPrice2.textColor = .white;
        upPrice3.textColor = .white;
        
        upPrice1.autoresizingMask = .flexibleHeight;
        upPrice1.adjustsFontSizeToFitWidth = true
        upPrice1.minimumScaleFactor = 0.2
        upPrice1.numberOfLines = 0;
        upPrice2.autoresizingMask = .flexibleHeight;
        upPrice2.adjustsFontSizeToFitWidth = true
        upPrice2.minimumScaleFactor = 0.2
        upPrice2.numberOfLines = 0;
        upPrice3.autoresizingMask = .flexibleHeight;
        upPrice3.adjustsFontSizeToFitWidth = true
        upPrice3.minimumScaleFactor = 0.2
        upPrice3.numberOfLines = 0;
        
        up1Button = UIButton(frame: buttonFrame)
        up2Button = UIButton(frame: buttonFrame)
        up3Button = UIButton(frame: buttonFrame)
        
        up1.addSubview(up1Button);
        up2.addSubview(up2Button);
        up3.addSubview(up3Button);
        up1.addSubview(upPrice1);
        up2.addSubview(upPrice2);
        up3.addSubview(upPrice3);
        
        stack = UIStackView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        stack.distribution = .fillEqually
        stack.axis = .horizontal;
        stack.addArrangedSubview(up1);
        stack.addArrangedSubview(up2);
        stack.addArrangedSubview(up3);
        _bounds = frame;
        super.init(frame: frame)
        self.addSubview(stack)
        stack.alignment = .fill;
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.layer.borderColor = appColor.cgColor;
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 15;
        stack.autoresizesSubviews = true;
        self.autoresizesSubviews = true;
        
        up1Button.addTarget(self, action: #selector(upgrade1), for: .touchUpInside)
        up2Button.addTarget(self, action: #selector(upgrade2), for: .touchUpInside)
        up3Button.addTarget(self, action: #selector(upgrade3), for: .touchUpInside)
        
    }
    private var _bounds: CGRect;
    override var frame: CGRect {
        set(val) {
            super.frame = val;
            stack.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            up1.frame = CGRect(x: up1.frame.minX, y: 0, width: val.width/3, height: val.height);
            up2.frame = CGRect(x: up2.frame.minX, y: 0, width: val.width/3, height: val.height);
            up3.frame = CGRect(x: up3.frame.minX, y: 0, width: val.width/3, height: val.height);
            var buttonFrame = CGRect(x: (up1.frame.width/2)-frame.height/4, y: 10, width: val.height/2, height: val.height/2)
            up1Button.frame = buttonFrame;
            up2Button.frame = buttonFrame
            up3Button.frame = buttonFrame
            let labelFrame = CGRect(x: 0, y: 2*up1.frame.height/3, width: up1.frame.width, height: up1.frame.height/3)
            upPrice1.frame = labelFrame
            upPrice2.frame = labelFrame
            upPrice3.frame = labelFrame
            let foregroundFrame = CGRect(x: 0, y: 0, width: up1.frame.width, height: up1.frame.height)
            foreground1.frame = foregroundFrame
            foreground2.frame = foregroundFrame
            foreground3.frame = foregroundFrame
            
        }
        get {
            return super.frame;
        }
    }
    @objc func upgrade1(sender: UIButton) {
        if (shape == nil || !acceptsTouches) {
            return;
        }
        if (shape!.canUpgradeA() && _shape!.upgradePriceA() <= _curA) {
            //shape?.upgradeA();
            shouldUpgrade(_shape!, 1);
        
            upPrice1.text = shape?.upgradePriceA().toCurrency()
        }
        
    }
    @objc func upgrade2(sender: UIButton) {
        if (shape == nil || !acceptsTouches) {
            return;
        }
        if (shape!.canUpgradeB() && _shape!.upgradePriceB() <= _curA) {
            //shape?.upgradeB();
            shouldUpgrade(_shape!, 2);
            upPrice2.text = shape?.upgradePriceB().toCurrency()
        }
    }
    @objc func upgrade3(sender: UIButton) {
        if (shape == nil || !acceptsTouches) {
            return;
        }
        if (shape!.canUpgradeC() && _shape!.upgradePriceC() <= _curA) {
            //shape?.upgradeC();
            shouldUpgrade(_shape!, 3);
            upPrice3.text = shape?.upgradePriceC().toCurrency()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
