//
//  ImageCapture.swift
//  securitycamera
//
//  Created by Marshall Brekka on 2/18/15.
//  Copyright (c) 2015 marshall.brekka. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation



class ImageCapture: NSObject {
    var sampleBuffer: CMSampleBuffer!
    var session: AVCaptureSession!
    var connection: AVCaptureConnection!
    var output: AVCaptureStillImageOutput!
    
    override init () {
        super.init()
        self.session = nil
        self.connection = nil
    }
    
    func startSession(device:AVCaptureDevice) {
        var session = AVCaptureSession()
        var error:NSError?
        var input = AVCaptureDeviceInput(device: device, error: &error)
        var output = AVCaptureStillImageOutput()
        self.output = output
        
        session.addInput(input)
        session.addOutput(output)

        var connect:AVCaptureConnection! = nil
        for connection in output.connections as [AVCaptureConnection] {
            for port in connection.inputPorts as [AVCaptureInputPort] {
                if (port.mediaType == AVMediaTypeVideo) {
                    connect = connection;
                    break;
                }
            }
            if (connect == nil) {
                break;
            }
            
        }
        self.connection = connect;
        session.startRunning()
        self.session = session;
        
    }
    
    func captureImage(cb: (NSData) -> Void) {
        self.output.captureStillImageAsynchronouslyFromConnection(self.connection, {(buffer:CMSampleBuffer!, error:NSError!) in
            var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer);
            cb(imageData)
        })
    }
    
    func stopSession() {
        self.session.stopRunning()
        self.session = nil
        self.connection = nil
    }

    
    class func defaultVideoDevice() -> AVCaptureDevice {
        var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device == nil) {
            device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeMuxed)
        }
        return device;
    }
    

    
}
