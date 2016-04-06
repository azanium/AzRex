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


class SAHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let taskQ = dispatch_queue_create("AVSerialQueue", nil)
    var progressView: MBProgressHUD!
    var counter = 1
    var path = ""
    var projectList: [String] = []
    var selectedProject: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.decorateNavigationBar()
        
        self.footerView.backgroundColor = self.navigationBarTintColor()
        self.recordButton.decorateCircularButton(false)
        self.tableView.backgroundColor = ColorTools.UIColorFromHexString("#101010")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.tableView.setEditing(editing, animated: animated)
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
    
    // MARK: - Data
    
    func reloadData() {
        let path = NSHomeDirectory().stringByAppendingString("/Documents/")
        do {
            self.projectList = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
        }
        catch _ {
            print("# Failed to fetch projects")
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Video Capture and Exporter
    
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
                    self.reloadData()
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
                self.progressView.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
                self.progressView.labelText = "Exporting.."
                self.exportH264(videoUrl)
            })
            
            
        }, onCanceled: nil)
        
        self.presentViewController(captureVC, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is SADetailViewController {
            let detailVC = segue.destinationViewController as! SADetailViewController
            detailVC.documentPath = self.selectedProject
            detailVC.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if projectList.count == 0 {
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            emptyLabel.text = "You have no projects.\nPlease record a new one."
            emptyLabel.textColor = UIColor.whiteColor()
            emptyLabel.numberOfLines = 0
            emptyLabel.textAlignment = NSTextAlignment.Center
            emptyLabel.font = UIFont(name: "HelveticaNeue", size: 16)
            
            self.tableView.backgroundView = emptyLabel
            
            return 0
        }
        else {
            self.tableView.backgroundView = nil
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProjectCell") as! SAProjectCell
        
        let project = self.projectList[self.projectList.count - indexPath.row - 1]
        
        cell.backgroundColor = ColorTools.UIColorFromHexString("#101010")
        cell.projectLabel.text = "\(indexPath.row + 1). \(project)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.selectedProject = self.projectList[indexPath.row]
        
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (row, index) -> Void in
            
            let project = self.projectList[index.row]
            
            let path = NSHomeDirectory().stringByAppendingFormat("/Documents/%@", project)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            }
            catch _ {
                self.showAlert("ERROR", message: "Failed to delete the project", dismissButton: "OK")
            }
            
            self.reloadData()
        }
        
        return [deleteAction]
    }
    
}
