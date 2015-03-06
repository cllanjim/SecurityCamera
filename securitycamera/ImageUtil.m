//
//  ImageUtil.m
//  securitycamera
//
//  Created by marshall.brekka on 2/27/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//
#include "ImageUtil.h"


@implementation ImageUtil

+ (CGImageRef) CGImageCreateWithNSImage:(NSImage *)image {
    NSRect pRect = NSMakeRect( 0, 0, [image size].width, [image size].height);
    return [image CGImageForProposedRect: &pRect context: NULL hints:NULL];
}

+ (CVPixelBufferRef) pixelBufferFromNSImage: (NSImage *) nsimage {
    CGImageRef image = [ImageUtil CGImageCreateWithNSImage:nsimage];
    NSSize size = nsimage.size;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
                                          size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

@end

