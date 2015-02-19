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

