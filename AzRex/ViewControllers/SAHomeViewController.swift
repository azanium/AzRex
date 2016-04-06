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
    
    let taskQ = dispatch_queue_create("AVSerialQueue", nil)
    var progressView: MBProgressHUD!
    var counter = 1
    var path = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView = MBProgressHUD(window: UIApplication.sharedApplication().keyWindow)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayError(error: NSError!) {
        
        progressView.hide(true)
        if let _ = error {
            self.showAlert("\(error.code)", message: "\(error.localizedDescription)", dismissButton: "OK")
        }
        else {
            self.showAlert("ERROR", message: "Failed without error on level \(self.counter)", dismissButton: "OK")
        }
    }
    
    
    func exportH264(videoUrl: NSURL) {
        
        self.progressView.progress = Float(self.counter) / 5.0
        
        var profile: [NSObject:AnyObject]!
        switch counter {
        case 1:
            profile = SAVideoProfile.Profile1(600, height: 600)
        case 2:
            profile = SAVideoProfile.Profile2(600, height: 600)
        case 3:
            profile = SAVideoProfile.Profile3(600, height: 600)
        case 4:
            profile = SAVideoProfile.Profile4(600, height: 600)
        case 5:
            profile = SAVideoProfile.Profile5(600, height: 600)
        default:
            profile = SAVideoProfile.Profile1(600, height: 600)
        }
        
        let target = "\(self.path)video\(self.counter)"
        
        SAVideoCapture.sharedInstance.exportToMP4(videoUrl, targetFileName: target, videoSettings: profile, audioSettings: SAAudioProfile.Profile1) { (success, error) in
        
            if success {
                if self.counter < 5 {
                    self.counter += 1
                    self.exportH264(videoUrl)
                }
                else {
                    
                    self.progressView.hide(true)
                    self.showAlert("Success", message: "The video successfully exported to MP4", dismissButton: "OK")
                    
                }
            }
            else {
                self.displayError(error)
            }
        }
    }
    

    @IBAction func capture() {
        let captureVC = SAVideoCapture.sharedInstance.showVideoCapture({ (videoUrl) in
            
            let format = NSDateFormatter()
            format.dateFormat = "dd-MM-yyyy-HH-mm-ss"
            
            self.counter = 1
            self.path = "\(format.stringFromDate(NSDate()))/"
            let targetPath = NSHomeDirectory().stringByAppendingFormat("/Documents/%@", self.path)
            
            var isDir: ObjCBool = true
            if !NSFileManager.defaultManager().fileExistsAtPath(targetPath, isDirectory: &isDir) {
                print("# Creating new folder: \(targetPath)")
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(targetPath, withIntermediateDirectories: false, attributes: nil)
                }
                catch _ {
                    print("# Failed to create new folder: \(targetPath)")
                    self.showAlert("ERROR", message: "Failed to create project", dismissButton: "OK")
                    return
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.progressView = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.progressView.mode = MBProgressHUDMode.AnnularDeterminate
                self.progressView.labelText = "Exporting.."
                self.exportH264(videoUrl)
            })
            
            
        }, onCanceled: nil)
        
        self.presentViewController(captureVC, animated: true, completion: nil)
        
    }
    
}
