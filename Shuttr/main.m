//
//  main.m
//  Shuttr
//
//  Created by Chris Cowdery-Corvan on 9/4/17.
//

#import <Foundation/Foundation.h>

#import "PhotoDelegate.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        PhotoDelegate *photoDelegate = [[PhotoDelegate alloc] init];
        NSString *capturedImagePath = [photoDelegate takePhoto];
        
        printf("%s", [capturedImagePath UTF8String]);
    }
    
    return 0;
}
