//
//  SceneTableView.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-16.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit
class SceneTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var zones: [Zone] = []
    init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        dataSource = self
        delegate = self
    }
    func setZones(zones: [Zone]) {
        self.zones = zones
        self.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zones.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let zone = zones[indexPath.row]
        
        let cell = UITableViewCell();
        let shapes = SceneShapePreview(frame: cell.frame, children: zone.children);
        cell.addSubview(shapes)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let playArea = superview as? PlayArea {
            playArea.selectZone(index: indexPath.row)
            playArea.tableOpen = false
            self.removeFromSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

