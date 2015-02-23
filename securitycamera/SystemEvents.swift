//
//  SystemEvents.swift
//  securitycamera
//
//  Created by Marshall Brekka on 2/21/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation



class SystemEvents: NSObject {
    var onLock:() -> Void
    var onUnlock:() -> Void
    
    init(onScreenLock:() -> Void, onScreenUnlock:() -> Void) {
        
        self.onLock = onScreenLock
        self.onUnlock = onScreenUnlock
        super.init()
        
        var defaultCenter = NSDistributedNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: "_screenLocked:", name: "com.apple.screenIsLocked", object: nil)
        defaultCenter.addObserver(self, selector: "_screenUnlocked:", name: "com.apple.screenIsUnlocked", object: nil)
    }
    
    func _screenLocked(notification: NSNotification) {
        self.onLock()
    }
    
    func _screenUnlocked(notification: NSNotification) {
        self.onUnlock()
    }
}