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

var movieCount = 0;

var movie:Movie! = nil

func saveImage(image:NSData) {
    if (movie == nil) {
        var img = NSImage(data: image)
        movie = Movie(filePath:NSURL(fileURLWithPath:"/Users/marshallbrekka/testmovie ")!, size: img!.size)
    }
    movie.addImage(image)

    //image.writeToFile(String("/Users/Marshall/pictures_" + String(pic) + ".jpg"), atomically: false)
    println("got image to save")
}

var captureQueue = ImageCaptureQueue(interval:interval, saveImage);

func start() {
    captureQueue.startCapture()
}

func stop() {
    movie.finish()
    captureQueue.stopCapture()
}


//var x = SystemEvents(start, stop)
start()
sleep(20)
stop()



CFRunLoopRun()

