//
//  ShopCollectionView.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-11-20.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

class ShopCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var tapToAddButton: UILabel;
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Even with 1000 cells per minute would still take 21 days to hit either end if starting in middle
        
        if (_cs.count == 0) {
            self.addSubview(tapToAddButton);
            superview?.addSubview(shapesStore);
            superview?.addSubview(fixturesStore);
            fixturesStore.isEnabled = false;
        }
        else if (tapToAddButton.superview != nil) {
            tapToAddButton.removeFromSuperview()
        }
        if (_cs.count == 0) {
            return _cs.count;
        }
        fixturesStore.isEnabled = true;
        return 60970891;
    }
    var direction = 1;
    func reloadDataShift() {
        print("SHIFTING");
        var mult = 1;
        while visibleCells.count > mult*_cs.count {
            mult += 1;
        }
        mult *= 2;
        curInd += (mult*_cs.count*direction);
        // curInd will change on scrollToItem, but scrollViewDidScroll is never called (not animated)
        var curIndHold = curInd;
        direction *= -1; // So that it moves in opposite directions each time
        
        scrollToItem(at: IndexPath(row: curIndHold, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true);
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            // TODO: if we change animated to false, change this back
            //self.fixViews(leftInd: IndexPath(row: curIndHold-1, section: 0), centerInd: IndexPath(row: curIndHold, section: 0), rightInd: IndexPath(row: curIndHold+1, section: 0), xO: nil);
        })
    }

    private var _cs: [GameObject] = [];
    var currentShapes: [GameObject] {
        set(val) {
            // For some reason, it would not group these properly one line
            let condA = _cs.count < 1 && val.count >= 1
            let condB = (val.count == 0)
            _cs = val;
            if condA || condB  { // Reload data if 'state' of collection view changes
                reloadData();
                if (condA) {
                    // Need to set here since animation hasnt necessarily finished
                    curInd = 30485445
                }
            }
            else {
                reloadDataShift();
            }
        }
        get {
            return _cs;
        }
    }
    func purchaseShape() {
        if (centerIndex != nil) {
            scrollToItem(at: centerIndex!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false);
            if let controller = superview as? MasterView {
                controller.openShapeShop()
            }
        }
    }
    func purchaseFixture() {
        if (centerIndex != nil) {
            scrollToItem(at: centerIndex!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false);
            if let controller = superview as? MasterView {
                controller.openFixtureShop()
            }
        }
    }
    var _curA: Int = 0;
    var curA: Int {
        set(val) {
            _curA = val
            for i in visibleCells {
                if let shape = i as? UpgradeShapeCell {
                    shape.curA = val;
                }
                else if let fixture = i as? UpgradeFixtureCell {
                    fixture.curA = val;
                }
                
            }
        }
        get {
            return _curA;
        }
    }
    var shouldUpgrade: (Shape, Int) -> Void = {
        _, _ in
    }
    var upgradeFixture: (Fixture) -> Void = {
        _ in
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // +One fixture, +one shape
        
        let row = indexPath.row%(currentShapes.count)
        /*if (row == 0) { // Purchase Shape
            let cell = dequeueReusableCell(withReuseIdentifier: "purchaseShape", for: indexPath) as! PurchaseShapeCell;
            cell.toggleShop = purchaseShape;
            return cell;
        }
        if (row == 1) { // Purchase Fixture
            let cell = dequeueReusableCell(withReuseIdentifier: "purchaseFixture", for: indexPath) as! PurchaseFixtureCell;
            cell.toggleShop = purchaseFixture;
            return cell;
        }*/
        //else { // Get shape
            if let shape = currentShapes[row] as? Shape {
                print("ALLOCATING"+Date().description);
                let cell = dequeueReusableCell(withReuseIdentifier: "upgradeShape", for: indexPath) as! UpgradeShapeCell;
                cell.shape = shape;
                cell.curA = _curA;
                cell.shouldUpgrade = shouldUpgrade;
                return cell;
            }
            else if let fixture = currentShapes[row] as? Fixture {
                let cell = dequeueReusableCell(withReuseIdentifier: "upgradeFixture", for: indexPath) as! UpgradeFixtureCell;
                cell.fixture = fixture;
                cell.curA = _curA;
                cell.upgradeFixture = upgradeFixture;
                return cell;
            }
        //}
        return UICollectionViewCell();
    }
    override func reloadData() {
        
        
        super.reloadData()
        if (_cs.count >= 1) {
            scrollToItem(at: IndexPath(row: 30485444, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false);
            // Have to scroll at least one to get to propper size (plus shows dragability)
            scrollToItem(at: IndexPath(row: 30485445, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true);
        }
        
    }
    var oldCenterCell: UICollectionViewCell?;
    var centerIndex: IndexPath?;
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snap(scrollView);
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var vel = scrollView.panGestureRecognizer.velocity(in: self);
        if (!decelerate) {
            snap(scrollView);
        }
    }
    func snap(_ scrollView: UIScrollView) {
        let xOff = scrollView.contentOffset.x
        let ind = indexPathForItem(at: CGPoint(x: xOff+(frame.width/2), y: frame.height/2))
        if (ind != nil) {
            centerIndex = ind;
            scrollToItem(at: ind!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true);
        }
        else {
            // TODO: Get propper index to left or right
            let leftInd = indexPathForItem(at: CGPoint(x: xOff, y: frame.height/2))

            if (leftInd != nil) {
                centerIndex = leftInd;
                scrollToItem(at: leftInd!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true);
            }
            else {
                let rightInd = indexPathForItem(at: CGPoint(x: xOff+frame.width, y: frame.height/2))
                if (rightInd != nil) {
                    centerIndex = rightInd;
                    scrollToItem(at: leftInd!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true);
                }
                // SHOULDNT BE POSSIBLE TO HAVE ELSE UNLESS EMPTY
            }
            
        }
    }
    var curInd = 0;
    
    func fixViews(leftInd: IndexPath?, centerInd: IndexPath?, rightInd: IndexPath?, xO: CGFloat?) {
        var xOff = xO;
        var ind = centerInd;
        if (ind?.row == leftInd?.row) {
            ind = nil;
        }
        if (ind?.row == rightInd?.row) {
            ind = nil;
        }
        if (ind != nil) {
            curInd = ind!.row;
            self.centerIndex = ind;
            let cll = self.cellForItem(at: ind!);
            if let cell = cll as? ShopCollectionViewCell {
                
                if (!cell.isEqual(self.oldCenterCell)) && self.oldCenterCell != nil {
                    self.oldCenterCell!.frame = CGRect(x: self.oldCenterCell!.frame.minX, y: self.frame.height/4, width: self.frame.width/2, height: self.frame.height/2)
                    self.selectionFeedback.selectionChanged();
                    self.selectionFeedback.prepare();
                    
                }
                
                let dif = xOff != nil ? cell.frame.midX-xOff! : (self.frame.width/2);
                let absDif = abs(dif-(self.frame.width/2))
                let heightPerc = 1-(absDif/(self.frame.width/2));
                cell.frame = CGRect(x: cell.frame.minX, y: (self.frame.height/2)-(self.frame.height*(heightPerc/2)), width: self.frame.width/2, height: heightPerc*self.frame.height)
                self.oldCenterCell = cell;
                cell.acceptsTouches = true;
                cell.alpha = 1;
                
                if let shape = cell as? UpgradeShapeCell {
                    shape.shape?.focus();
                }
                else if let fixture = cell as? UpgradeFixtureCell {
                    fixture.fixture?.focus();
                }

            }
        }
        if (leftInd != nil) {
            let cll = self.cellForItem(at: leftInd!);
            if let cell = cll as? ShopCollectionViewCell {
                let dif = xOff != nil ? cell.frame.maxX-xOff! : 0;
                let absDif = abs(dif-(self.frame.width/2))
                let heightPerc = 1-(absDif/(self.frame.width/2));
                let def = CGSize(width: self.frame.width/2, height: self.frame.height/2);
                let height = heightPerc*def.height
                cell.frame = CGRect(x: cell.frame.minX, y: (self.frame.height/2)-(height/2), width: self.frame.width/2, height: height)
                cell.acceptsTouches = false;
                cell.alpha = heightPerc;
                
                if let shape = cell as? UpgradeShapeCell {
                    shape.shape?.unfocus();
                }
                else if let fixture = cell as? UpgradeFixtureCell {
                    fixture.fixture?.unfocus();
                }
            }
        }
        if (rightInd != nil) {
            let cll = self.cellForItem(at: rightInd!);
            if let cell = cll as? ShopCollectionViewCell {
                let dif = xOff != nil ? xOff!+self.frame.width-cell.frame.minX : 0;
                let absDif = abs(dif-(self.frame.width/2))
                let heightPerc = 1-(absDif/(self.frame.width/2));
                let def = CGSize(width: self.frame.width/2, height: self.frame.height/2);
                let height = heightPerc*def.height
                cell.frame = CGRect(x: cell.frame.minX, y: (self.frame.height/2)-(height/2), width: self.frame.width/2, height: height)
                cell.acceptsTouches = false;
                cell.alpha = heightPerc;
                
                if let shape = cell as? UpgradeShapeCell {
                    shape.shape?.unfocus();
                }
                else if let fixture = cell as? UpgradeFixtureCell {
                    fixture.fixture?.unfocus();
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //DispatchQueue.global(qos: .background).async {
        let xOff = scrollView.contentOffset.x
        
        var ind = self.indexPathForItem(at: CGPoint(x: xOff+(self.frame.width/2), y: self.frame.height/2))
        
        let leftInd = self.indexPathForItem(at: CGPoint(x: xOff, y: self.frame.height/2))
        let rightInd = self.indexPathForItem(at: CGPoint(x: xOff+self.frame.width, y: self.frame.height/2))
        fixViews(leftInd: leftInd, centerInd: ind, rightInd: rightInd, xO: xOff);
        
    }
    
    var selectionFeedback: UISelectionFeedbackGenerator;
    var shapesStore: UIButton;
    var fixturesStore: UIButton;
    init(frame: CGRect) {
        selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.prepare();
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal;
        layout.itemSize = CGSize(width: frame.width/2, height: frame.height/2);
        layout.minimumLineSpacing = frame.height/4
        layout.minimumInteritemSpacing = frame.width/8
        
        shapesStore = UIButton(frame: CGRect(x: frame.minX, y: frame.minY, width: frame.height, height: frame.height));
        shapesStore.setImage(UIImage(named: "ShapesStore"), for: .normal)
        fixturesStore = UIButton(frame: CGRect(x: frame.minX+frame.width-frame.height, y: frame.minY, width: frame.height, height: frame.height));
        fixturesStore.setImage(UIImage(named: "FixturesStore"), for: .normal);
        tapToAddButton = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        tapToAddButton.text = "<- Tap to add your first shape";
        tapToAddButton.textColor = .white
        tapToAddButton.textAlignment = .center;
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self;
        dataSource = self;
        register(PurchaseShapeCell.self, forCellWithReuseIdentifier: "purchaseShape");
        register(UpgradeShapeCell.self, forCellWithReuseIdentifier: "upgradeShape");
        register(UpgradeFixtureCell.self, forCellWithReuseIdentifier: "upgradeFixture");
        register(PurchaseFixtureCell.self, forCellWithReuseIdentifier: "purchaseFixture");
        superview?.addSubview(fixturesStore);
        superview?.addSubview(shapesStore);
        shapesStore.addTarget(self, action: #selector(openShapeShop), for: .touchUpInside);
        fixturesStore.addTarget(self, action: #selector(openFixtureShop), for: .touchUpInside);
    }
    @objc func openShapeShop(sender: UIButton) {
        if let controller = superview as? MasterView {
            controller.openShapeShop()
        }
    }
    @objc func openFixtureShop(sender: UIButton) {
        if let controller = superview as? MasterView {
            controller.openFixtureShop()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
