//
//  UIViewController+Dialog.swift
//  AzRex
//
//  Created by Suhendra Ahmad on 4/6/16.
//  Copyright © 2016 Suhendra Ahmad. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, dismissButton: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: dismissButton, style: UIAlertActionStyle.Default) { (alert) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(dismissAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func navigationBarTintColor() -> UIColor {
        return ColorTools.UIColorFromHexString("#303030")
    }
    
    func decorateNavigationBar(decorateTitle: Bool = true) {
        
        let titleDict: NSDictionary = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 18)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = self.navigationBarTintColor()
    }
}


extension UIButton {
    
    func decorateCircularButton(useBorder: Bool) {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 2.0
    }
}