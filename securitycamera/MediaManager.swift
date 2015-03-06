//
//  MediaManager.swift
//  securitycamera
//
//  Created by Marshall Brekka on 3/3/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation

class MediaManager {
    let url = UrlHelper()
    let fs:FileManager
    let historyLength:UInt
    
    init(baseDirectory:NSURL, historyLength:UInt) {
        self.fs = FileManager(baseDirectory: baseDirectory)
        self.historyLength = historyLength
    }
    
    func saveImage(image:NSData) {
        var date = NSDate()
        var name = self.url.dateToString(date)
        self.fs.addImage(name, image: image)
    }
    
    func convertImagesToMovies() {
        var today = UrlHelper.dateToStartOfDay(NSDate())
        var urlsDict = url.urlArrayToDictionary(fs.getImageUrls())
        for (date, urls) in urlsDict {
            if (!date.isEqualToDate(today)) {
                urlsToMovie(date, urls: urls)
            }
        }
    }
    
    func deleteOldMovies() {
        var cutoff = UrlHelper.dateToStartOfDay(NSDate())
        var days:NSTimeInterval = 60 * 60 * 24 * Double(self.historyLength)
        cutoff = cutoff.dateByAddingTimeInterval(days)
        var oldUrls = url.urlsBeforeDate(fs.getMovieUrls(), date: cutoff)
        fs.deleteMovieUrls(oldUrls)
    }
    
    func urlsToMovie(date:NSDate, urls:[NSURL]) {
        var movieUrl = fs.createMovieUrl(url.dateToMovieString(date))
        var movie:Movie! = nil
        for url in urls {
            var imageData = NSData(contentsOfURL: url)
            if (movie == nil) {
                var image = NSImage(data: imageData!)
                movie = Movie(filePath: movieUrl, size: image!.size)
            }
            movie.addImage(imageData!)
        }
        movie.finish()
        fs.deleteImageUrls(urls)
    }
}