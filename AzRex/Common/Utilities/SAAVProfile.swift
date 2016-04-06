//
//  SAAVProfile.swift
//  AzRex
//
//  Created by Suhendra Ahmad on 4/6/16.
//  Copyright © 2016 Suhendra Ahmad. All rights reserved.
//

import UIKit

class SAVideoProfile {
    class func Profile1(width: Int, height: Int) -> [NSObject: AnyObject] {
        let videoSettings: [NSObject: AnyObject] = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 6_000_000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264High40
            ]
        ]
        
        return videoSettings
    }
    
    class func Profile2(width: Int, height: Int) -> [NSObject: AnyObject] {
        let videoSettings: [NSObject: AnyObject] = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 5_000_000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264High40
            ]
        ]
        
        return videoSettings
    }
    
    class func Profile3(width: Int, height: Int) -> [NSObject: AnyObject] {
        let videoSettings: [NSObject: AnyObject] = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 3_000_000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264Main41
            ]
        ]
        
        return videoSettings
    }
    
    class func Profile4(width: Int, height: Int) -> [NSObject: AnyObject] {
        let videoSettings: [NSObject: AnyObject] = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 1_000_000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264Main41
            ]
        ]
        
        return videoSettings
    }
    
    class func Profile5(width: Int, height: Int) -> [NSObject: AnyObject] {
        let videoSettings: [NSObject: AnyObject] = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 600_000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264Baseline41
            ]
        ]
        
        return videoSettings
    }
}

class SAAudioProfile {
    static var Profile1: [NSObject: AnyObject] {
        let audioSettings: [NSObject: AnyObject] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 48_000,
            AVEncoderBitRateKey: 256_000
        ]
        return audioSettings
    }
    
    static var Profile2: [NSObject: AnyObject] {
        let audioSettings: [NSObject: AnyObject] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44_000,
            AVEncoderBitRateKey: 196_000
        ]
        return audioSettings
    }
    
    static var Profile3: [NSObject: AnyObject] {
        let audioSettings: [NSObject: AnyObject] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44_100,
            AVEncoderBitRateKey: 128_000
        ]
        return audioSettings
    }
    
    static var Profile4: [NSObject: AnyObject] {
        let audioSettings: [NSObject: AnyObject] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 32_000,
            AVEncoderBitRateKey: 96_000
        ]
        return audioSettings
    }
    
    static var Profile5: [NSObject: AnyObject] {
        let audioSettings: [NSObject: AnyObject] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 32_000,
            AVEncoderBitRateKey: 64_000
        ]
        return audioSettings
    }
    
}
