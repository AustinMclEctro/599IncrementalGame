//
//  SceneCollectionDrag.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-11-10.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

extension SceneCollectionView: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
        if let up = self.cellForItem(at: IndexPath(row: 0, section: 0)) as? NewSceneCollectionViewCell {
            if (up.frame.contains(session.location(in: up))) {
                if (up.upgradeA.frame.contains(session.location(in: up))) {
                    up.upgradeA.backgroundColor = .green;
                    up.upgradeB.backgroundColor = .clear;
                }
                else if (up.upgradeB.frame.contains(session.location(in: up))) {
                    up.upgradeB.backgroundColor = .green;
                    up.upgradeA.backgroundColor = .clear;
                }
                else {
                    up.upgradeA.backgroundColor = .clear;
                    up.upgradeB.backgroundColor = .clear;
                }
            }
            else {
                up.upgradeA.backgroundColor = .clear;
                up.upgradeB.backgroundColor = .clear;
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        if let up = self.cellForItem(at: IndexPath(row: 0, section: 0)) as? NewSceneCollectionViewCell {
            up.isNew = true;
            
            if (up.frame.contains(session.location(in: self)) && self.dragLoc != nil) {
                // Upgrade
                var loc = session.location(in: up);
                var zone = zones[self.dragLoc!];
                /*if (loc.y < up.frame.midY && zone.canUpgradeA()) {
                    // TODO: Check currency
                    zone.upgradeA();
                }
                else if (loc.y >= up.frame.midY && zone.canUpgradeB()) {
                    // TODO: Check currency
                    zone.upgradeB();
                }*/
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true;
    }
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if (indexPath.row == 0) {
            // Add cell
            return [];
        }
        dragLoc = indexPath.row;
        let cell = collectionView.cellForItem(at: indexPath)
        if let prev = cell as? SceneCollectionViewCell {
            let dragItem = NSItemProvider(object: prev.image ?? UIImage());
            return [UIDragItem(itemProvider: dragItem)];
        }
        return [];
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        feedbackGenerator.impactOccurred()
        feedbackGenerator.prepare()
        if let up = self.cellForItem(at: IndexPath(row: 0, section: 0)) as? NewSceneCollectionViewCell {
            up.isNew = false;
        }
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return true;
    }
}
