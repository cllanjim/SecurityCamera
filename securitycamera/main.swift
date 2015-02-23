//
//  main.swift
//  test
//
//  Created by marshall.brekka on 2/18/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation


var interval = 1.0
//image.writeToFile(String("/Users/marshallbrekka/testimage" + String(x) + ".jpg"), atomically: false)

var pic = 0

func saveImage(image:NSData) {
    pic++;
    image.writeToFile(String("/Users/Marshall/pictures_" + String(pic) + ".jpg"), atomically: false)
    println("got image to save")
}

var captureQueue = ImageCaptureQueue(interval:interval, saveImage);

func start() {
    captureQueue.startCapture()
}

func stop() {
    captureQueue.stopCapture()
}


var x = SystemEvents(start, stop)



CFRunLoopRun()

