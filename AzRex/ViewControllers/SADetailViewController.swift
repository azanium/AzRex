//
//  SADetailViewController.swift
//  AzRex
//
//  Created by Suhendra Ahmad on 4/6/16.
//  Copyright © 2016 Suhendra Ahmad. All rights reserved.
//

import UIKit
import AVKit
import MobilePlayer
import AWSS3
import AWSCore

class SADetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var uploadBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressBarView: UIProgressView!
    @IBOutlet weak var uploadTitle: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var uploadRequests: [AWSS3TransferManagerUploadRequest] = []
    
    var documentPath: String = ""
    var videoList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.decorateNavigationBar()
        
        self.tableView.backgroundColor = ColorTools.UIColorFromHexString("#101010")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.cancelButton.layer.cornerRadius = 5.0
        self.cancelButton.layer.masksToBounds = true
        self.cancelButton.addTarget(self, action: #selector(cancelUploadAction), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.uploadView.backgroundColor = ColorTools.UIColorFromHexString("#303030")
        
        self.hideUploadView(false)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "upload"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(uploadAction))
    }

    override func viewWillAppear(animated: Bool) {
        self.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideUploadView(animated: Bool) {
        if (animated) {
            self.uploadBottomConstraint.constant = 0.0
            UIView.animateWithDuration(0.3, animations: { 
                    self.uploadBottomConstraint.constant = -self.uploadView.frame.size.height
                    self.view.layoutIfNeeded()
                })
        }
        else {
            self.uploadBottomConstraint.constant = -self.uploadView.frame.size.height
        }
    }
    
    func showUploadView(animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.3, animations: { 
                self.uploadBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        else {
            self.uploadBottomConstraint.constant = 0
        }
    }

    // MARK: - Data
    
    func reloadData() {
        self.videoList.removeAll()
        self.uploadRequests.removeAll()
        
        let path = NSHomeDirectory().stringByAppendingFormat("/Documents/%@", self.documentPath)
        
        do {
            self.videoList = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
        }
        catch _ {
            print("# Cant load contents of directory")
        }
        
        for video in self.videoList {
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest.body = NSURL(fileURLWithPath: NSHomeDirectory().stringByAppendingFormat("/Documents/%@/%@", self.documentPath, video))
            uploadRequest.key = "videos/\(self.documentPath)-\(video)"
            uploadRequest.bucket = AWSS3Constants.S3BucketName
            
            self.uploadRequests += [uploadRequest]
        }
        
        self.navigationItem.title = "Videos"
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProjectCell", forIndexPath: indexPath) as! SAProjectCell

        let video = self.videoList[indexPath.row]
        
        cell.backgroundColor = ColorTools.UIColorFromHexString("#101010")
        cell.projectLabel.text = "\(indexPath.row+1). \(video)"

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let video = self.videoList[indexPath.row]
        
        let filePath = NSHomeDirectory().stringByAppendingFormat("/Documents/%@/%@", self.documentPath, video)
        let videoUrl = NSURL(fileURLWithPath: filePath)
        
        let playerVC = MobilePlayerViewController(contentURL: videoUrl)
        playerVC.title = "AzRex - \(video)"
        playerVC.activityItems = [videoUrl]
        presentMoviePlayerViewControllerAnimated(playerVC)    
    }
    
    
    // MARK: - Upload
    
    func uploadAction() {
        if (self.uploadRequests.count > 0) {
            print("# Start uploading")
            
            self.progressBarView.progress = 0.0
            self.uploadTitle.text = "Preparing..."
            self.navigationItem.rightBarButtonItem?.enabled = false
            self.showUploadView(true)
            
            self.upload(self.uploadRequests[0])
        }
        else {
            self.showAlert("", message: "No videos to upload", dismissButton: "OK")
        }
    }
    
    func cancelUploadAction() {
        
        for request in self.uploadRequests {
            request.cancel().continueWithBlock({ (task) -> AnyObject? in
                if let error = task.error {
                    print("cancel() failed: [\(error)]")
                }
                if let exception = task.exception {
                    print("cancel() failed: [\(exception)]")
                }
                return nil
            })
        }
        
        self.navigationItem.rightBarButtonItem?.enabled = true
        self.hideUploadView(true)
        
        self.reloadData()
    }
 
    func displayError(error: NSError!) {
        dispatch_async(dispatch_get_main_queue()) { 
            
            self.cancelUploadAction()
            self.showAlert("ERROR", message: error.localizedDescription, dismissButton: "OK")
            
        }
    }
    
    func upload(request: AWSS3TransferManagerUploadRequest) {
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()

        let remaining = self.videoList.count-self.uploadRequests.count+1
        let total = self.videoList.count
        self.uploadTitle.text = "Uploading \(remaining) of \(total)..."

        request.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if totalBytesExpectedToSend > 0 {
                    self.progressBarView.progress = Float(Double(totalBytesSent) / Double(totalBytesExpectedToSend))
                }
            })
        }
        
        transferManager.upload(request).continueWithBlock { (task) -> AnyObject? in
            if let error = task.error {
                if error.domain == AWSS3TransferManagerErrorDomain as String {
                    if let errorCode = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch errorCode {
                        case .Cancelled, .Paused:
                            dispatch_async(dispatch_get_main_queue()) {
                                self.hideUploadView(true)
                                self.showAlert("Canceled", message: "Your upload has been cancelled", dismissButton: "OK")
                            }
                            
                        default:
                            
                            self.displayError(error)
                        }
                    }
                    else {
                        self.displayError(error)
                    }
                }
                else {
                    self.displayError(error)
                }
            }
            
            if let exception = task.exception {
                 print("upload() failed: [\(exception)]")
            }
            
            if task.result != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    if let index = self.uploadRequests.indexOf(request) {
                        self.uploadRequests.removeAtIndex(index)
                        
                        if self.uploadRequests.count > 0 {
                            self.upload(self.uploadRequests[0])
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.hideUploadView(true)
                                self.showAlert("Success", message: "Upload finished", dismissButton: "OK")
                            }
                        }
                    }
                    else {
                        self.showAlert("ERROR", message: "Invalid upload index", dismissButton: "OK")
                    }
                }
            }
            
            return nil
        }
        
    }
}
