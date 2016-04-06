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
}
