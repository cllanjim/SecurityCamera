//
//  FileManager.swift
//  securitycamera
//
//  Created by Marshall Brekka on 2/27/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation

class FileManager {
    var baseDirectory:NSURL;
    var fileManager:NSFileManager;
    var moviesDir:NSURL;
    var imagesDir:NSURL;
    let MOVIE_DIR = "movies"
    let IMAGE_DIR = "rawCaptures"
    
    init(baseDirectory:NSURL) {
        self.baseDirectory = baseDirectory;
        self.moviesDir = self.baseDirectory.URLByAppendingPathComponent(
            self.MOVIE_DIR, isDirectory: true)
        self.imagesDir = self.baseDirectory.URLByAppendingPathComponent(
            self.IMAGE_DIR, isDirectory: true)
        
        self.fileManager = NSFileManager()
        self.createDirectory(baseDirectory)
        self.createDirectory(self.moviesDir)
        self.createDirectory(self.imagesDir)
    }
    
    func addImage(name: String, image:NSData) {
        image.writeToURL(FileManager.makeImageUrl(self.imagesDir, name: name), atomically: true)
    }
    
    func createMovieUrl(name: String) -> NSURL {
        return self.moviesDir.URLByAppendingPathComponent(name + ".mov")
    }
    
    func getImageUrls() -> [NSURL] {
        return getDirectoryUrls(self.imagesDir)
    }
    
    func getMovieUrls() -> [NSURL] {
        return getDirectoryUrls(self.moviesDir)
    }
    
    func getDirectoryUrls(directory:NSURL) -> [NSURL] {
        var error:NSError? = nil
        var options:NSArray! = NSArray(array: [NSURLNameKey])
        var files = self.fileManager.contentsOfDirectoryAtURL(
            directory,
            includingPropertiesForKeys: options,
            options: NSDirectoryEnumerationOptions.SkipsHiddenFiles,
            error: &error)
        return files as [NSURL]
    }
    
    func deleteImageUrls(urls: [NSURL]) {
        self.deleteUrls(urls, parentDirectory: self.imagesDir)
    }

    func deleteMovieUrls(urls: [NSURL]) {
        self.deleteUrls(urls, parentDirectory: self.moviesDir)
    }
    
    func deleteUrls(urls: [NSURL], parentDirectory: NSURL) {
        for url in urls {
            self.deleteUrl(url, parentDirectory: parentDirectory)
        }
    }
    
    func deleteUrl(url: NSURL, parentDirectory: NSURL) {
        var error:NSError? = nil
        var path = parentDirectory.URLByAppendingPathComponent(url.lastPathComponent!)
        self.fileManager.removeItemAtURL(path, error: &error)
    }
    
    func createDirectory(path:NSURL) {
        var error:NSError? = nil
        self.fileManager.createDirectoryAtURL(
            path,
            withIntermediateDirectories: true,
            attributes: nil,
            error: &error)
    }
    
    class func makeImageUrl(directory: NSURL, name: String) -> NSURL {
        var path:String = name + ".jpg"
        return directory.URLByAppendingPathComponent(path)
    }
}