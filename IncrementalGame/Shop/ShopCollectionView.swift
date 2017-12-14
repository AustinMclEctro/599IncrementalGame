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
    
    // MARK: Properties
    
    var curInd = 0;
    var selectionFeedback: UISelectionFeedbackGenerator;
    var shapesStore: UIButton;
    var fixturesStore: UIButton;
    var tapToAddButton: UILabel;
    var direction = 1;
    var _curA: Int = 0;
    var curA: Int {
        // Setter for _curA, updates the look of cells within viewable range
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
    private var _cs: [GameObject] = [];
    // Setter for currentShapes that reloads the collectionView
    var currentShapes: [GameObject] {
        set(val) {
            // For some reason, it would not group these properly one line with brackets
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
    var oldCenterCell: UICollectionViewCell?;
    var centerIndex: IndexPath?;

    
    // MARK: Initializers
    
    
    init(frame: CGRect) {
        // Sets up all values
        selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.prepare();
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal;
        layout.itemSize = CGSize(width: frame.width/2, height: frame.height/2);
        layout.minimumLineSpacing = frame.height/4
        layout.minimumInteritemSpacing = frame.width/8
        
        shapesStore = UIButton(frame: CGRect(x: frame.minX, y: frame.minY, width: frame.height, height: frame.height));
        shapesStore.setImage(UIImage(named: "ShapesStore"), for: .normal)
        fixturesStore = UIButton(frame: CGRect(x: frame.minX+frame.width-frame.height, y: frame.minY, width: frame.height, height: frame.height));
        fixturesStore.setImage(UIImage(named: "FixturesStore"), for: .normal);
        tapToAddButton = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        // Will be visible when no shapes
        tapToAddButton.text = "<- Tap to add your first shape";
        tapToAddButton.textColor = .white
        tapToAddButton.textAlignment = .center;
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self;
        dataSource = self;
        register(UpgradeShapeCell.self, forCellWithReuseIdentifier: "upgradeShape");
        register(UpgradeFixtureCell.self, forCellWithReuseIdentifier: "upgradeFixture");
        superview?.addSubview(fixturesStore);
        superview?.addSubview(shapesStore);
        shapesStore.addTarget(self, action: #selector(openShapeShop), for: .touchUpInside);
        fixturesStore.addTarget(self, action: #selector(openFixtureShop), for: .touchUpInside);
    }
    
    
    // MARK: Functions
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Even with 1000 cells per minute would still take 21 days to hit either end if starting in middle
        
        if (_cs.count == 0) {
            // Setup label and return 0, no need for collection view yet
            self.addSubview(tapToAddButton);
            fixturesStore.isEnabled = false;
            superview?.addSubview(shapesStore);
            superview?.addSubview(fixturesStore);
        }
        else if (tapToAddButton.superview != nil) {
            tapToAddButton.removeFromSuperview()
        }
        if (_cs.count == 0) {
            return _cs.count;
        }
        // Makes sure buttons are on top and always visible
        fixturesStore.isEnabled = true;
        superview?.addSubview(shapesStore);
        superview?.addSubview(fixturesStore);
        
        return 60970891;
    }
    
    
    func reloadDataShift() {
        // Called to quick-reload the collection view (replaces visible cells by shifting the center)
        var mult = 1;
        while visibleCells.count > mult*_cs.count {
            mult += 1;
        }
        mult *= 2;
        curInd += (mult*_cs.count*direction);
        // curInd will change on scrollToItem, but scrollViewDidScroll is never called (not animated)
        let curIndHold = curInd;
        direction *= -1; // So that it moves in opposite directions each time
        
        scrollToItem(at: IndexPath(row: curIndHold, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true);
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            // TODO: if we change animated to false, change this back
            //self.fixViews(leftInd: IndexPath(row: curIndHold-1, section: 0), centerInd: IndexPath(row: curIndHold, section: 0), rightInd: IndexPath(row: curIndHold+1, section: 0), xO: nil);
        })*/
    }

    
    func purchaseShape() {
        // Makes sure the view has stopped scrolling first and then opens shape shop
        if (centerIndex != nil) {
            scrollToItem(at: centerIndex!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false);
            if let controller = superview as? MasterView {
                controller.openShapeShop()
            }
        }
    }
    
    
    func purchaseFixture() {
        // Makes sure the view has stopped scrolling first and then opens fixture shop
        if (centerIndex != nil) {
            scrollToItem(at: centerIndex!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false);
            if let controller = superview as? MasterView {
                controller.openFixtureShop()
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row%(currentShapes.count)
        // Gets the cell for the current index, uses modulus and many cells to simulate circular list
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
        return UICollectionViewCell();
    }
    
    
    override func reloadData() {
        super.reloadData()
        // Makes sure that we are scrolled to the center
        if (_cs.count >= 1) {
            tapToAddButton.removeFromSuperview()
            // first scroll to centerish-1 without animation
            scrollToItem(at: IndexPath(row: 30485444, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false);
            // Have to scroll at least one to get to propper size (plus shows dragability)
            scrollToItem(at: IndexPath(row: 30485445, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true);
        }
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // If scrolled, should snap - This is why quick snapping is an issue
        // THere is no watcher for scrollViewIsScrolling with velocity so we could snap quicker
        snap(scrollView);
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // if it shouldnt decelerate (user let go slow enough) snap right away
        if (!decelerate) {
            snap(scrollView);
        }
    }
    
    
    func snap(_ scrollView: UIScrollView) {
        // Gets the closest to center (if no center favours left) and scrolls to it
        let xOff = scrollView.contentOffset.x
        let ind = indexPathForItem(at: CGPoint(x: xOff+(frame.width/2), y: frame.height/2))
        if (ind != nil) {
            centerIndex = ind;
            scrollToItem(at: ind!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true);
        }
        else {
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
    
    func fixViews(leftInd: IndexPath?, centerInd: IndexPath?, rightInd: IndexPath?, xO: CGFloat?) {
        // Fix views resizes the views according to whether they are center, left, or right and applies the propper alphas
        let xOff = xO;
        var ind = centerInd;
        if (ind?.row == leftInd?.row) {
            ind = nil;
        }
        if (ind?.row == rightInd?.row) {
            ind = nil;
        }
        // Makes center cell big and opaque
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
        // Makes left and right small and transparent
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
        // Resizes views accordingly (left, right and center)
        let xOff = scrollView.contentOffset.x
        
        let ind = self.indexPathForItem(at: CGPoint(x: xOff+(self.frame.width/2), y: self.frame.height/2))
        
        let leftInd = self.indexPathForItem(at: CGPoint(x: xOff, y: self.frame.height/2))
        let rightInd = self.indexPathForItem(at: CGPoint(x: xOff+self.frame.width, y: self.frame.height/2))
        fixViews(leftInd: leftInd, centerInd: ind, rightInd: rightInd, xO: xOff);
        
    }
    
    
    @objc func openShapeShop(sender: UIButton) {
        // Opens the shape shop
        if let controller = superview as? MasterView {
            controller.openShapeShop()
        }
    }
    
    
    @objc func openFixtureShop(sender: UIButton) {
        // Closes the shape shop
        if let controller = superview as? MasterView {
            controller.openFixtureShop()
        }
    }
    
    // MARK: NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
