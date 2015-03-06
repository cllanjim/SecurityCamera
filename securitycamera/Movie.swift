//
//  Movie.swift
//  securitycamera
//
//  Created by Marshall Brekka on 2/21/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation

// source http://stackoverflow.com/questions/5640657/avfoundation-assetwriter-generate-movie-with-images-and-audio

class Movie {
    var movie:AVAssetWriter
    var writer:AVAssetWriterInput
    var adapter:AVAssetWriterInputPixelBufferAdaptor
    var time:CMTime
    
    init(filePath:NSURL, size:NSSize) {
        var error = NSErrorPointer()
        self.movie = AVAssetWriter(
            URL: filePath,
            fileType: AVFileTypeQuickTimeMovie,
            error: error)
        
        var videoSettings = [
            AVVideoCodecKey as String: AVVideoCodecH264,
            AVVideoWidthKey as String: NSNumber(integer: Int(size.width)),
            AVVideoHeightKey as String: NSNumber(integer: Int(size.height))
        ]
        
        self.writer = AVAssetWriterInput(
            mediaType: AVMediaTypeVideo,
            outputSettings: videoSettings)
        self.adapter = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: self.writer,
            sourcePixelBufferAttributes: nil)
        self.writer.expectsMediaDataInRealTime = true;
        
        self.movie.addInput(self.writer)
        self.movie.startWriting()
        self.movie.startSessionAtSourceTime(kCMTimeZero)
        self.time = CMTimeMake(0, 30)
    }
    
    func addImage(data:NSData) {
        var image = NSImage(data:data)
        var buffer = ImageUtil.pixelBufferFromNSImage(image)
        self.adapter.appendPixelBuffer(buffer.takeUnretainedValue(), withPresentationTime:self.time)
        self.time = CMTimeAdd(self.time, CMTimeMake(1, 30));
        buffer.release();
    }
    
    func finish() {
        self.movie.finishWritingWithCompletionHandler() {
            print("Movie finished")
        }
    }
}