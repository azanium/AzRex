//
//  ViewController.swift
//  AzRex
//
//  Created by Suhendra Ahmad on 4/4/16.
//  Copyright © 2016 Suhendra Ahmad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wrapper = FFmpegWrapper()
        
        print("\(wrapper)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

