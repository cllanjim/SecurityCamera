//
//  ImageCaptureQueue.swift
//  securitycamera
//
//  Created by Marshall Brekka on 2/21/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation

private let concurrentImageSnapQueue = dispatch_queue_create(
    "com.marshallbrekka.SecurityCamera.ImageCaptureQueue", DISPATCH_QUEUE_CONCURRENT)

class ImageCaptureQueue {
    var timer: dispatch_source_t! = nil
    var captureFn: (NSData) -> Void
    var interval:Double
    var camera:ImageCapture;
    
    init(interval:Double, capture: (NSData) -> Void) {
        self.captureFn = capture
        self.interval = interval
        self.camera = ImageCapture()
    }
    
    func startCapture() {
        dispatch_barrier_async(concurrentImageSnapQueue) {
            self.camera.startSession(ImageCapture.defaultVideoDevice())
            
            // setup the timer for calling the capture image fn
            var timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, concurrentImageSnapQueue);
            self.timer = timer;
            
            dispatch_source_set_timer(
                timer,
                dispatch_time(DISPATCH_TIME_NOW,
                    Int64(self.interval * Double(NSEC_PER_SEC))),
                UInt64(self.interval * Double(NSEC_PER_SEC)),
                UInt64(self.interval * Double(NSEC_PER_SEC) / 10));
            dispatch_source_set_event_handler(timer) {
                self.camera.captureImage(self.captureFn)
            }
            dispatch_resume(timer)
        }
    }
    
    func stopCapture() {
        dispatch_barrier_async(concurrentImageSnapQueue) {
            dispatch_source_cancel(self.timer);
            self.camera.stopSession()
            self.timer = nil
        }
    }
}