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

+ (CVPixelBufferRef) imageToPixelBuffer:(NSImage *)image {
        CVPixelBufferRef buffer = NULL;
        CGImageRef img = [ImageUtil CGImageCreateWithNSImage:image];
    
        // config
        size_t width = [image size].width;
        size_t height = [image size].height;
        size_t bitsPerComponent = CGImageGetBitsPerComponent(img);
        CGColorSpaceRef cs = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
        CGBitmapInfo bi = CGImageGetBitmapInfo(img);
        NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey, [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
        
        // create pixel buffer
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, k32ARGBPixelFormat, (__bridge CFDictionaryRef)d, &buffer);
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
        [image drawAtPoint:NSMakePoint(0.0, 0.0) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
        [NSGraphicsContext restoreGraphicsState];
        
        CVPixelBufferUnlockBaseAddress(buffer, 0);
        CFRelease(ctxt);
        
        return buffer;
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

