//
//  ImageUtil.h
//  securitycamera
//
//  Created by marshall.brekka on 2/27/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>



@interface ImageUtil : NSObject  {
    CVImageBufferRef                    imageToPixelBuffer;
    CGImageRef                          CGImageCreateWithNSImage;
    CVPixelBufferRef                    pixelBufferFromNSImage;
}

+ (CVPixelBufferRef) imageToPixelBuffer:(NSImage *)image;
+ (CGImageRef) CGImageCreateWithNSImage:(NSImage *)image;
+ (CVPixelBufferRef) pixelBufferFromNSImage: (NSImage *) nsimage;
@end