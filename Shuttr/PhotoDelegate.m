//
//  PhotoDelegate.m
//  Shuttr
//
//  Created by Chris Cowdery-Corvan on 9/4/17.
//

#import "PhotoDelegate.h"

#import "CameraCapture.h"

#import <AppKit/AppKit.h>

@implementation PhotoDelegate

- (NSString*) takePhoto
{
    CameraCapture *cc = [[CameraCapture alloc] init];
    NSImage *capturedImage = [cc captureImageSync];
    
    NSString *imageUUID = [[NSUUID UUID] UUIDString];
    
    NSString *containingDirectory = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory() , @"photobooth-shots"];
    [[NSFileManager defaultManager] createDirectoryAtPath:containingDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@.tiff", containingDirectory, imageUUID];
    
    [[capturedImage TIFFRepresentation] writeToFile:fullFilePath atomically:YES];
    
    return fullFilePath;
}

@end
