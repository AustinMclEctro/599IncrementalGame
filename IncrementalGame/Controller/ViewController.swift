//
//  ViewController.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // If iPhone X need to shift everything down
        // Since we only support portrait, and everything scales to a square for fairness, we chose not to use auto-layout
        let isX = view.frame.height == 812 && view.frame.width == 375
        view.backgroundColor = .black;
        let frame = isX ? CGRect(x: 0, y: 29, width: view.frame.width, height: view.frame.height-60) : self.view.frame
        let controllerView = MasterView(frame: frame)
        
        self.view.addSubview(controllerView);
        // A slightly hacky way of doing this, but we need to wait some time after adding the controllerview to reload the shop
        //  data. Cannot shift the cells until after the view has rendered completely (including collectionView calls)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            controllerView.shop.reloadDataShift();
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

