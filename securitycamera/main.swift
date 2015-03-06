//
//  main.swift
//  test
//
//  Created by marshall.brekka on 2/18/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation

var interval = 3.0
var daysToSave = UInt(18)
var dir:NSURL! = NSURL(
    fileURLWithPath: "/Users/Marshall/Documents/securitycamera/", isDirectory: true)

var media = MediaManager(baseDirectory: dir, historyLength: daysToSave)
var captureQueue = ImageCaptureQueue(interval:interval, media.saveImage);
var screenEvents = SystemEvents(
    captureQueue.startCapture,
    captureQueue.stopCapture)

var movieQueue = MovieConversionQueue(){
    media.convertImagesToMovies()
    media.deleteOldMovies()
}


CFRunLoopRun()