//
//  SAEncoder.swift
//  AzRex
//
//  Created by Suhendra Ahmad on 4/6/16.
//  Copyright © 2016 Suhendra Ahmad. All rights reserved.
//

import UIKit
import MobileCoreServices

class SAVideoCapture: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var onCaptureCallback: ((videoUrl: NSURL) -> Void)?
    private var onCaptureCanceledCallback: (()->())?
    
    static var sharedInstance: SAVideoCapture {
        struct Static {
            static var token: dispatch_once_t = 0
            static var instance: SAVideoCapture?
        }
        
        dispatch_once(&Static.token) { 
            Static.instance = SAVideoCapture()
        }
        
        return Static.instance!
    }
    
    // MARK: - Video Capture 
    
    func showVideoCapture(onCaptured: ((videoUrl: NSURL) -> Void)?, onCanceled: (()->())?) -> UIViewController {
    
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = UIImagePickerControllerSourceType.Camera
            
            cameraPicker.mediaTypes = [kUTTypeMovie as String]
            cameraPicker.videoMaximumDuration = 30
            cameraPicker.delegate = self
            self.onCaptureCallback = onCaptured
            self.onCaptureCanceledCallback = onCanceled
            
            return cameraPicker
        }
        else {
            
            let alert = UIAlertController(title: "ERROR", message: "Camera not found", preferredStyle: UIAlertControllerStyle.Alert)
            
            let action = UIAlertAction(title: "OK", style: .Default) { (alert) in
                self.onCaptureCanceledCallback?()
            }
            
            alert.addAction(action)
            
            return alert
        }
    }
    
    func exportToMP4(source: NSURL, targetFileName: String, onCompleted: ((success: Bool, error: NSError!)->Void)?) {
        
        let asset = AVAsset(URL: source)
        var width = 640
        var height = 480
        if let track = asset.tracksWithMediaType(AVMediaTypeVideo).first {
            let size = CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform)
            
            print(size)
            width = Int(fabs(size.width))
            height = Int(fabs(size.height))
        }
        
        let videoSettings: [NSObject: AnyObject] = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 6_000_000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264High40
            ]
        ]
        
        let audioSettings: [NSObject: AnyObject] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100,
            AVEncoderBitRateKey: 128_000
        ]
        
        self.exportToMP4(source, targetFileName: targetFileName, videoSettings: videoSettings, audioSettings: audioSettings, onCompleted: onCompleted)
        
    }
    
    func exportToMP4(source: NSURL, targetFileName: String, videoSettings: [NSObject:AnyObject]!, audioSettings: [NSObject:AnyObject]!, onCompleted: ((success: Bool, error: NSError!)->Void)?) {
        
        let outputPath = NSHomeDirectory().stringByAppendingFormat("/Documents/%@.mp4", targetFileName)
        
        let fileMan = NSFileManager.defaultManager()
        
        if fileMan.fileExistsAtPath(outputPath) {
            print("# outputPath is exist: \(outputPath)")
            
            do {
                try fileMan.removeItemAtPath(outputPath)
            }
            catch _ {
                print("# Failed to erase \(outputPath)")
            }
        }
        
        
        let avAsset = AVURLAsset(URL: source)
        let encoder = SDAVAssetExportSession(asset: avAsset)
        encoder.outputURL = NSURL(fileURLWithPath: outputPath)
        encoder.outputFileType = AVFileTypeMPEG4
        encoder.videoSettings = videoSettings
        encoder.audioSettings = audioSettings
        
        encoder.exportAsynchronouslyWithCompletionHandler {
            
            dispatch_async(dispatch_get_main_queue()) {
                if encoder.status == AVAssetExportSessionStatus.Completed {
                    onCompleted?(success: true, error: encoder.error)
                }
                else if encoder.status == AVAssetExportSessionStatus.Cancelled {
                    onCompleted?(success: false, error: encoder.error)
                }
                else {
                    onCompleted?(success: false, error: encoder.error)
                }
                
                do {
                    try NSFileManager().removeItemAtURL(source)
                }
                catch _ {}
            }
            
        }
        
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        self.onCaptureCanceledCallback?()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        dispatch_async(dispatch_get_main_queue()) {
            picker.dismissViewControllerAnimated(true) {
                if let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL {

                    self.onCaptureCallback?(videoUrl: videoURL)
                }
                else {
                    
                    self.onCaptureCanceledCallback?()
                    
                }
            }
        }
    }
    
}
