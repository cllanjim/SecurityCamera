//
//  ImageCapture.swift
//  securitycamera
//
//  Created by Marshall Brekka on 2/18/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation
import AVFoundation



class ImageCapture {
    func startSession(device:AVCaptureDevice) {
        var session = AVCaptureSession()
        var error:NSError?
        var input = AVCaptureDeviceInput(device: device, error: &error)
        session.addInput(input)
        
        var output = AVCaptureVideoDataOutput()
        
    }
    
    
/*
    
    
    // Decompressed video output
    verbose( "\tCreating QTCaptureDecompressedVideoOutput...");
    mCaptureDecompressedVideoOutput = [[QTCaptureDecompressedVideoOutput alloc] init];
    [mCaptureDecompressedVideoOutput setDelegate:self];
    verbose( "Done.\n" );
    if (![mCaptureSession addOutput:mCaptureDecompressedVideoOutput error:&error]) {
    error( "\tCould not create decompressed output.\n");
    [mCaptureSession release];
    [mCaptureDeviceInput release];
    [mCaptureDecompressedVideoOutput release];
    mCaptureSession = nil;
    mCaptureDeviceInput = nil;
    mCaptureDecompressedVideoOutput = nil;
    return NO;
    }
    
    // Clear old image?
    verbose("\tEntering synchronized block to clear memory...");
    @synchronized(self){
    if( mCurrentImageBuffer != nil ){
    CVBufferRelease(mCurrentImageBuffer);
    mCurrentImageBuffer = nil;
    }   // end if: clear old image
    }   // end sync: self
    verbose( "Done.\n");
    
    [mCaptureSession startRunning];
    verbose("Session started.\n");
    
    return YES;
    }   // end startSession

  */
    
    
    
    
    
    
    class func defaultVideoDevice() -> AVCaptureDevice {
        var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device == nil) {
            device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeMuxed)
        }
        return device;
    }
    
}
