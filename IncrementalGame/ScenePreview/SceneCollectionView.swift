//
//  SceneTableView.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-16.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

/// The table view used for displaying and interacting with the user's zones.
class SceneCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        zoneCells = [];
        return zones.count;
    }
    func zoomingTo(index: Int) -> CGRect {
        //let index = zones.index(of: zone);
        let indexPath = IndexPath.init(row: index+1 ?? 0, section: 0)
        let cell = self.collectionView(self, cellForItemAt: indexPath)
        return CGRect(x: cell.frame.minX, y: cell.frame.minY-self.contentOffset.y, width: cell.frame.width, height: cell.frame.height)//cell.frame;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == 0) {
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newZone", for: indexPath);
            if let new = cell as? NewSceneCollectionViewCell {
                // TODO: add game state price
                new.newScenePrice.text = "GAME STATE PRICE"
            }
            return cell;
        }
        else {
            
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "previewZone", for: indexPath);
            //var cell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: frame.width/3, height: frame.width/3*1.2))
            var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height));
            if let controller = superview as? MasterView {
                var im = controller.playArea.texture(from: zones[indexPath.row]);
                imageView.image = UIImage(cgImage: (im?.cgImage())!)
                
            }
            
            cell.addSubview(imageView);
            zoneCells.append(cell as! SceneCollectionViewCell);
            return cell;
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var row = indexPath.row;
        if let controller = superview as? MasterView {
            if (row == 0) {
                // TODO: Add new zone
                controller.createZone();
            }
            else {
                // need to subtract 1 to offset new button
                controller.selectZone(index: row-1);
            }
        }
        
    }
    var zoneCells: [SceneCollectionViewCell] = [];
    var zones: [Zone] {
        get {
            // Just a trash zone for the new button? Not sure of a better way to do this
            var new = Zone(size: CGSize(), children: [], pIG: nil)
            return [new]+gameState.zones
        }
    }
    var gameState: GameState;
    init(frame: CGRect, gameState: GameState) {
        self.gameState = gameState;
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical;
        let startWidth = frame.width/3 > 300 ? 300 : frame.width/3;
        flowLayout.itemSize = CGSize(width: startWidth,height: startWidth*1.25)
        flowLayout.minimumInteritemSpacing = startWidth/3;
        flowLayout.minimumLineSpacing = startWidth/3
        flowLayout.sectionInset = .init(top: 0, left: startWidth/3, bottom: 0, right: startWidth/3)
        super.init(frame: frame, collectionViewLayout: flowLayout)
        dataSource = self
        delegate = self
        self.register(SceneCollectionViewCell.self, forCellWithReuseIdentifier: "previewZone");
        self.register(NewSceneCollectionViewCell.self, forCellWithReuseIdentifier: "newZone");
        self.backgroundColor = .black;
    }
    
    override func didMoveToSuperview() {
        //self.backgroundView = superview;
        super.didMoveToSuperview()
    }
    func setCurrent(playArea: PlayArea) {
        var zone = playArea.zoneNumber;
        let cell = zoneCells[playArea.zoneNumber];//self.collectionView(self, cellForItemAt: indexPath)
        
        cell.addSubview(playArea);
        playArea.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

