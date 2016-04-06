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

class SADetailViewController: UITableViewController {

    var documentPath: String = ""
    var videoList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.decorateNavigationBar()
        
        self.tableView.backgroundColor = ColorTools.UIColorFromHexString("#101010")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Uncomment the following line to preserve selection between precsentations
        self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "upload"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(uploadAction))
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Data
    
    func reloadData() {
        let path = NSHomeDirectory().stringByAppendingFormat("/Documents/%@", self.documentPath)
        
        do {
            self.videoList = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
        }
        catch _ {
            print("# Cant load contents of directory")
        }
        
        self.navigationItem.title = "Videos"
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProjectCell", forIndexPath: indexPath) as! SAProjectCell

        let video = self.videoList[indexPath.row]
        
        cell.backgroundColor = ColorTools.UIColorFromHexString("#101010")
        cell.projectLabel.text = "\(indexPath.row+1). \(video)"

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        print("Uploading")
    }

}
