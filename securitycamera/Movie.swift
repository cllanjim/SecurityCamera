//
//  Movie.swift
//  securitycamera
//
//  Created by Marshall Brekka on 2/21/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation

class Movie {
    var movie:AVAssetWriter
    var writer:AVAssetWriterInput
    var adapter:AVAssetWriterInputPixelBufferAdaptor
    var time:CMTime
    
    init(filePath:NSURL) {
        var error = NSErrorPointer()
        self.movie = AVAssetWriter(
            URL: filePath,
            fileType: AVFileTypeMPEG4,
            error: error)
        self.writer = AVAssetWriterInput(
            mediaType: AVMediaTypeVideo,
            outputSettings: nil)
        self.adapter = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: self.writer,
            sourcePixelBufferAttributes: nil)
        self.writer.expectsMediaDataInRealTime = false;
        
        self.movie.addInput(self.writer)
        self.movie.startWriting()
        self.movie.startSessionAtSourceTime(kCMTimeZero)
        self.time = CMTimeMake(0, 30)
    }
    
    func addImage(data:NSData) {
        var image = NSImage(data:data)
        var buffr = CVPixelBufferRef
        var buffer = CVPixelBufferRef ([self pixelBufferFromImage:image withImageSize:self.videoSize];
        for (int i = 1; i <= 30; i++) {
            [ImageToVideoManager appendToAdapter:adaptor pixelBuffer:buffer atTime:time];
            time = CMTimeAdd(time, CMTimeMake(1, 30)); // Add another "frame"
        }
        CVPixelBufferRelease(buffer);
        
    }
    
    func finish() {
        self.movie.finishWritingWithCompletionHandler() {
            print("Movie finished")
        }
    }
    
    
    
    
    
    
    
    
    class func imageDataToCVPixelBuffer(data:NSData) {
        var image = NSImage(data: data);
        var buffer:CVPixelBufferRef;
        var width = image!.size.width
        var height = image!.size.height
        var bitsPerComponent = 8 // *not* CGImageGetBitsPerComponent(image)
        var cs = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB)
        var bi:CGBitmapInfo = CGBitmapInfo.AlphaInfoMask // *not* CGImageGetBitmapInfo(image);
        
        var d = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            UInt(width),
            UInt(height),
            k32ARGBPixelFormat,
            d,
            buffer);

        
    }
    
    
    - (CVPixelBufferRef)fastImageFromNSImage:(NSImage *)image
    {
    CVPixelBufferRef buffer = NULL;
    
    
    // config
    size_t width = [image size].width;
    size_t height = [image size].height;
    size_t bitsPerComponent = 8; // *not* CGImageGetBitsPerComponent(image);
    CGColorSpaceRef cs = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGBitmapInfo bi = kCGImageAlphaNoneSkipFirst; // *not* CGImageGetBitmapInfo(image);
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey, [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    
    // create pixel buffer
    CVPixelBufferCreate(kCFAllocatorDefault, width, height, k32ARGBPixelFormat, (CFDictionaryRef)d, &buffer);
    CVPixelBufferLockBaseAddress(buffer, 0);
    void *rasterData = CVPixelBufferGetBaseAddress(buffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    // context to draw in, set to pixel buffer's address
    CGContextRef ctxt = CGBitmapContextCreate(rasterData, width, height, bitsPerComponent, bytesPerRow, cs, bi);
    if(ctxt == NULL){
    NSLog(@"could not create context");
    return NULL;
    }
    
    // draw
    NSGraphicsContext *nsctxt = [NSGraphicsContext graphicsContextWithGraphicsPort:ctxt flipped:NO];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:nsctxt];
    [image compositeToPoint:NSMakePoint(0.0, 0.0) operation:NSCompositeCopy];
    [NSGraphicsContext restoreGraphicsState];
    
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    CFRelease(ctxt);
    
    return buffer;
    }
    
    class func imageDataToCVPixelBuffer(data:NSData) {
        var image = NSImage(data: data)
        var colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB)
        var pixelBufferProperties = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        var pixelBuffer:CVPixelBufferRef;
        
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(image!.size.width),
            Int(image!.size.height),
            kCVPixelFormatType_32RGBA,
            pixelBufferProperties,
            pixelBuffer);
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        var baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer);
        var bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
        var context = CGBitmapContextCreate(
            baseAddress,
            Int(image!.size.width),
            Int(image!.size.height),
            8,
            bytesPerRow,
            colorSpace,
            CGImageAlphaInfo.NoneSkipFirst);

        
    }
    
    
    - (CVPixelBufferRef)newPixelBufferFromNSImage:(NSImage*)image
    {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    NSDictionary* pixelBufferProperties = @{(id)kCVPixelBufferCGImageCompatibilityKey:@YES, (id)kCVPixelBufferCGBitmapContextCompatibilityKey:@YES};
    CVPixelBufferRef pixelBuffer = NULL;
    CVPixelBufferCreate(kCFAllocatorDefault, [image size].width, [image size].height, k32ARGBPixelFormat, (__bridge CFDictionaryRef)pixelBufferProperties, &pixelBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void* baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
    CGContextRef context = CGBitmapContextCreate(baseAddress, [image size].width, [image size].height, 8, bytesPerRow, colorSpace, kCGImageAlphaNoneSkipFirst);
    NSGraphicsContext* imageContext = [NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:NO];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:imageContext];
    [image compositeToPoint:NSMakePoint(0.0, 0.0) operation:NSCompositeCopy];
    [NSGraphicsContext restoreGraphicsState];
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    CFRelease(context);
    CGColorSpaceRelease(colorSpace);
    return pixelBuffer;
    }
    
    
    
    
}