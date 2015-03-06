//
//  MovieConversionQueue.swift
//  securitycamera
//
//  Created by Marshall Brekka on 3/5/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation



private let minInSec = 60
private let dayInSec:NSTimeInterval = Double((24 * 60 * minInSec) + minInSec)

class MovieConversionQueue {
    let conversionFn:() -> Void!
    let movieQueue = dispatch_queue_create(
        "com.marshallbrekka.SecurityCamera.MovieConversionQueue",
        DISPATCH_QUEUE_SERIAL)
    
    init(conversionFn:() -> Void) {
        self.conversionFn = conversionFn
        self.runAndSchedule()
    }
    
    func runAndSchedule() {
        var now:NSDate = UrlHelper.dateToStartOfDay(NSDate())
        var newTime = now.dateByAddingTimeInterval(dayInSec)
        
        dispatch_after(
            MovieConversionQueue.wallTimeFromDate(newTime),
            movieQueue,
            self.runAndSchedule)
        self.conversionFn()
    }
    
    class func wallTimeFromDate(date: NSDate) -> dispatch_time_t {
        var seconds = 0.0
        let frac = modf(date.timeIntervalSince1970, &seconds)
    
        let nsec: Double = frac * Double(NSEC_PER_SEC)
        var walltime = timespec(tv_sec: CLong(seconds), tv_nsec: CLong(nsec))
    
        return dispatch_walltime(&walltime, 0)
    }
}
