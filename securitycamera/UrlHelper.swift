//
//  MediaManager.swift
//  securitycamera
//
//  Created by Marshall Brekka on 3/1/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//
import Foundation

let DATE_FORMATTER = "yyyy-MM-dd"
let DATE_FORMATTER_FULL = DATE_FORMATTER + "-HH-mm-ss-SSSS"
let DATE_LENGTH = countElements(DATE_FORMATTER)
let calendar = NSCalendar(calendarIdentifier:NSGregorianCalendar)

class UrlHelper {
    let dateFormatter = NSDateFormatter()
    let outDateFormatter = NSDateFormatter()
    
    init () {
        self.dateFormatter.dateFormat = DATE_FORMATTER
        self.outDateFormatter.dateFormat = DATE_FORMATTER_FULL
    }
    
    func dateToString(date:NSDate) -> String {
        return self.outDateFormatter.stringFromDate(date)
    }
    
    func dateToMovieString(date:NSDate) -> String {
        return dateFormatter.stringFromDate(date);
    }
    
    func urlArrayToDictionary (urls:[NSURL]) -> Dictionary<NSDate, [NSURL]> {
        var dict:Dictionary<NSDate, [NSURL]> = Dictionary()
        var key:NSDate! = nil
        
        for url in urls {
            var urlKey:NSDate! = UrlHelper.dateToStartOfDay(self.urlToDate(url))
            if key == nil || !(urlKey.isEqualToDate(key)) {
                key = urlKey
                dict[key] = [url];
            } else {
                var values = dict[key]
                values?.append(url)
                dict[key] = values;
            }
        }
        return dict;
    }
    
    func urlsBeforeDate (urls:[NSURL], date:NSDate) -> [NSURL] {
        var values:[NSURL]! = []
        for url in urls {
            var urlDate = UrlHelper.dateToStartOfDay(self.urlToDate(url))
            if (urlDate.compare(date) == NSComparisonResult.OrderedAscending) {
                values.append(url);
            }
        }
        return values;
    }
   
    func urlToDate(url:NSURL) -> NSDate {
        var part:String! = url.lastPathComponent
        var endIndex = advance(part.startIndex, DATE_LENGTH)
        return self.dateFormatter.dateFromString(part.substringToIndex(endIndex))!
    }
    
    class func dateToStartOfDay(date:NSDate) -> NSDate {
        var components:NSDateComponents! = calendar?.components(
            NSCalendarUnit.CalendarUnitTimeZone |
            NSCalendarUnit.CalendarUnitYear |
            NSCalendarUnit.CalendarUnitMonth |
            NSCalendarUnit.CalendarUnitDay,
            fromDate: date)
        var newDate:NSDate! = calendar?.dateFromComponents(components)
        return newDate
    }
}