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

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func capture() {
        print("Captured")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = UIImagePickerControllerSourceType.Camera
            
            cameraPicker.mediaTypes = [kUTTypeMovie as String]
            cameraPicker.videoMaximumDuration = 30
            cameraPicker.delegate = self
            
            self.presentViewController(cameraPicker, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "ERROR", message: "Camera not found", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func encodeMP4(source: NSURL) {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let outputPath = NSHomeDirectory().stringByAppendingFormat("/Documents/output-%@.mp4", formater.stringFromDate(NSDate()))
        
        //let output = NSHomeDirectory().stringByAppendingString("/Documents/output.mp4")
        
        /*let ffmpeg = FFmpegWrapper()
        ffmpeg.convertInputPath(source, outputPath: output, options: ["-strict":"", "-2":""], progressBlock: nil) { (success, error) in
            print(success)
            print(error)
        }*/
        
        let avAsset = AVURLAsset(URL: source)
        let encoder = SDAVAssetExportSession(asset: avAsset)
        encoder.outputURL = NSURL(fileURLWithPath: outputPath)
        encoder.outputFileType = AVFileTypeMPEG4
        encoder.videoSettings = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: 600,
            AVVideoHeightKey: 600,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 6_000_000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264High40
            ]
        ]
        
        let formatId: Int = Int(kAudioFormatMPEG4AAC)
        encoder.audioSettings = [
            AVFormatIDKey: formatId,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100,
            AVEncoderBitRateKey: 128_000
        ]
        
        encoder.exportAsynchronouslyWithCompletionHandler { 
            if encoder.status == AVAssetExportSessionStatus.Completed {
                print("Video export succeed")
            }
            else if encoder.status == AVAssetExportSessionStatus.Cancelled {
                print("Video export cancelled")
            }
            else {
                print("Video export failed wth error: \(encoder.error.localizedDescription)")
            }
        }
        
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL {
            encodeMP4(videoUrl)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
