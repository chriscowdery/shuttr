//
//  CameraCapture.m
//  Shuttr
//
//  Created by Chris Cowdery-Corvan on 9/4/17.
//

#import "CameraCapture.h"

#import <AppKit/AppKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraCapture (Private)

@property (nonatomic, readonly) BOOL p_isCaptureSessionSetup;

- (void) p_setupCaptureSessionIfNecessary;

@end

@implementation CameraCapture
{
    AVCaptureStillImageOutput *_stillImageOutput;
}

- (void) p_setupCaptureSession
{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    [captureSession beginConfiguration];
    captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    [captureSession addInput:captureDeviceInput];

    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    
    [captureSession addOutput:_stillImageOutput];
    
    [captureSession commitConfiguration];
    [captureSession startRunning];
}

- (BOOL) p_isCaptureSessionSetup
{
    return _stillImageOutput != nil;
}

- (void) p_setupCaptureSessionIfNecessary
{
    if (! self.p_isCaptureSessionSetup) {
        [self p_setupCaptureSession];
    }
}

- (NSImage*) captureImageSync
{
    [self p_setupCaptureSessionIfNecessary];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    NSLog(@"about to request a capture from: %@", _stillImageOutput);
    
    dispatch_semaphore_t captureSempahore = dispatch_semaphore_create(0);
    __block NSImage *image = nil;
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        image = [[NSImage alloc] initWithData:imageData];
        
        dispatch_semaphore_signal(captureSempahore);
    }];
    
    dispatch_semaphore_wait(captureSempahore, DISPATCH_TIME_FOREVER);
    return image;
}

@end
