//
//  HomeViewController.swift
//  AzRex
//
//  Created by Suhendra Ahmad on 4/5/16.
//  Copyright © 2016 Suhendra Ahmad. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class SAHomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func capture() {
        let captureVC = SAVideoCapture.sharedInstance.showVideoCapture({ (videoUrl) in
            
            SAVideoCapture.sharedInstance.exportToMP4(videoUrl, targetFileName: "demo", onCompleted: { (success, error) in
                if (success) {
                    self.showAlert("Success", message: "The video successfully exported to MP4", dismissButton: "OK")
                }
                else {
                    var message = "Failed to export video"
                    if let _ = error {
                        message = message + "\n" + error.localizedDescription
                    }
                    self.showAlert("ERROR", message: message, dismissButton: "OK")
                }
            })
            
        }, onCanceled: nil)
        
        self.presentViewController(captureVC, animated: true, completion: nil)
        
    }
    
}
