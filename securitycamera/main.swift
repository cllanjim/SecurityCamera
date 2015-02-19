//
//  main.swift
//  test
//
//  Created by marshall.brekka on 2/18/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation

var imagesnapPath = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent("imagesnap")

print(imagesnapPath)


var interval = 2.0

var queue = dispatch_get_global_queue(Int(DISPATCH_QUEUE_PRIORITY_DEFAULT), 0)
var timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);


var count = 0

var dsTime1 = Int64(interval * Double(NSEC_PER_SEC))
if (timer != nil) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW,
        Int64(interval * Double(NSEC_PER_SEC)))
    
    dispatch_source_set_timer(
        timer,
        popTime,
        UInt64(interval * Double(NSEC_PER_SEC)),
        UInt64(interval * Double(NSEC_PER_SEC) / 10));
    
    dispatch_source_set_event_handler(timer) {
        count++;
        println("ran timer")
        if (count > 4) {
            println("stoping")
            dispatch_source_cancel(timer);
        }
    }
    dispatch_resume(timer)
}





class AppDelegate: NSObject {
    var imagesnap:NSTask
    override init() {
        self.imagesnap = NSTask()
        self.imagesnap.launchPath = "/usr/local/bin/imagesnap"
        self.imagesnap.currentDirectoryPath = "/Users/marshallbrekka/tmp/"
        self.imagesnap.arguments = ["-t", "5"];

        super.init()
        var defaultCenter = NSDistributedNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: "_screenLocked:", name: "com.apple.screenIsLocked", object: nil)
        defaultCenter.addObserver(self, selector: "_screenUnlocked:", name: "com.apple.screenIsUnlocked", object: nil)
    }
    
    func _screenLocked(notification: NSNotification) {
        println("screen locked")
        self.imagesnap.launch()
    }
    
    func _screenUnlocked(notification: NSNotification) {
        println("screen unlocked")
        self.imagesnap.terminate()
    }
}



println("Hello, World!")
var x = AppDelegate()




CFRunLoopRun()

