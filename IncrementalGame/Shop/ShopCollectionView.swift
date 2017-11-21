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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Even with 1000 cells per minute would still take 21 days to hit either end if starting in middle
        return 60970891;
    }
    private var _cs: [GameObject] = [];
    var currentShapes: [GameObject] {
        set(val) {
            _cs = val;
            reloadData();
        }
        get {
            return _cs;
        }
    }
    func purchaseShape() {
        if let controller = superview as? MasterView {
            controller.openShapeShop()
        }
    }
    func purchaseFixture() {
        if let controller = superview as? MasterView {
            controller.openFixtureShop()
        }
    }
    var _curA: Int = 0;
    var curA: Int {
        set(val) {
            _curA = val
            for i in visibleCells {
                if let shape = i as? UpgradeShapeCell {
                    shape.curA = val;
                    shape.checkUpgraes();
                }
                else if let fixture = i as? UpgradeFixtureCell {
                    fixture.curA = val;
                    fixture.checkUpgraes();
                }
                
            }
        }
        get {
            return _curA;
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // +One fixture, +one shape
        let row = indexPath.row%(currentShapes.count+2)
        if (row == 0) { // Purchase Shape
            let cell = dequeueReusableCell(withReuseIdentifier: "purchaseShape", for: indexPath) as! PurchaseShapeCell;
            cell.toggleShop = purchaseShape;
            return cell;
        }
        if (row == 1) { // Purchase Fixture
            let cell = dequeueReusableCell(withReuseIdentifier: "purchaseFixture", for: indexPath) as! PurchaseFixtureCell;
            cell.toggleShop = purchaseFixture;
            return cell;
        }
        else { // Get shape
            if let shape = currentShapes[row-2] as? Shape {
                let cell = dequeueReusableCell(withReuseIdentifier: "upgradeShape", for: indexPath) as! UpgradeShapeCell;
                cell.shape = shape;
                return cell;
            }
            else if let fixture = currentShapes[row-2] as? Fixture {
                let cell = dequeueReusableCell(withReuseIdentifier: "upgradeFixture", for: indexPath) as! UpgradeFixtureCell;
                cell.fixture = fixture;
                return cell;
            }
        }
        return UICollectionViewCell();
    }
    override func reloadData() {
        
        
        super.reloadData()
        scrollToItem(at: IndexPath(row: 30485444, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false);
        // Have to scroll at least one to get to propper size (plus shows dragability)
        scrollToItem(at: IndexPath(row: 30485445, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true);
        
    }
    var oldCenterCell: UICollectionViewCell?;
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let xOff = scrollView.contentOffset.x
        
        let ind = indexPathForItem(at: CGPoint(x: xOff+(frame.width/2), y: frame.height/2))
        let leftInd = indexPathForItem(at: CGPoint(x: xOff, y: frame.height/2))
        let rightInd = indexPathForItem(at: CGPoint(x: xOff+frame.width, y: frame.height/2))
        if (ind != nil) {
            let cll = cellForItem(at: ind!);
            if let cell = cll as? ShopCollectionViewCell {
                
                if (!cell.isEqual(oldCenterCell)) && oldCenterCell != nil {
                    oldCenterCell!.frame = CGRect(x: oldCenterCell!.frame.minX, y: frame.height/4, width: frame.width/2, height: frame.height/2)
                    selectionFeedback.selectionChanged();
                    selectionFeedback.prepare();
                    
                }
                let dif = cell.frame.midX-xOff;
                let absDif = abs(dif-(frame.width/2))
                let heightPerc = 1-(absDif/(frame.width/2));
                cell.frame = CGRect(x: cell.frame.minX, y: (frame.height/2)-(frame.height*(heightPerc/2)), width: frame.width/2, height: heightPerc*frame.height)
                oldCenterCell = cell;
            }
        }
        if (leftInd != nil) {
            let cell = cellForItem(at: leftInd!);
            if (cell != nil) {
                let dif = cell!.frame.maxX-xOff;
                let absDif = abs(dif-(frame.width/2))
                let heightPerc = 1-(absDif/(frame.width/2));
                let def = CGSize(width: frame.width/2, height: frame.height/2);
                let height = heightPerc*def.height
                cell?.frame = CGRect(x: cell!.frame.minX, y: (frame.height/2)-(height/2), width: frame.width/2, height: height)
            }
        }
        if (rightInd != nil) {
            let cell = cellForItem(at: rightInd!);
            if (cell != nil) {
                let dif = xOff+frame.width-cell!.frame.minX;
                let absDif = abs(dif-(frame.width/2))
                let heightPerc = 1-(absDif/(frame.width/2));
                let def = CGSize(width: frame.width/2, height: frame.height/2);
                let height = heightPerc*def.height
                cell?.frame = CGRect(x: cell!.frame.minX, y: (frame.height/2)-(height/2), width: frame.width/2, height: height)
            }
        }
        
    }
    
    var selectionFeedback: UISelectionFeedbackGenerator;
    init(frame: CGRect) {
        selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.prepare();
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal;
        layout.itemSize = CGSize(width: frame.width/2, height: frame.height/2);
        layout.minimumLineSpacing = frame.height/4
        layout.minimumInteritemSpacing = frame.width/8
        
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self;
        dataSource = self;
        register(PurchaseShapeCell.self, forCellWithReuseIdentifier: "purchaseShape");
        register(UpgradeShapeCell.self, forCellWithReuseIdentifier: "upgradeShape");
        register(UpgradeFixtureCell.self, forCellWithReuseIdentifier: "upgradeFixture");
        register(PurchaseFixtureCell.self, forCellWithReuseIdentifier: "purchaseFixture");
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
