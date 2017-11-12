//
//  ViewController.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // If iPhone X need to shift everything down
        var isX = view.frame.height == 812 && view.frame.width == 375
        view.backgroundColor = .black;
        var frame = isX ? CGRect(x: 0, y: 29, width: view.frame.width, height: view.frame.height-60) : self.view.frame
        var fr = self.view.safeAreaInsets;
        let controllerView = MasterView(frame: frame)
        
        self.view.addSubview(controllerView);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

