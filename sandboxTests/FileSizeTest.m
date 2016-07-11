//
//  FileSizeTest.m
//  sandbox
//
//  Created by Timothy Reddy on 7/11/16.
//  Copyright © 2016 Timothy Reddy. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FileSizeTest : XCTestCase
@end

@implementation FileSizeTest

-(void)testSize {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [[paths lastObject] stringByAppendingPathComponent:@"testSize"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];

    NSMutableString* mutableString = [[NSMutableString alloc] initWithCapacity:100];
    for(int i = 0; i < 10; i++) {
        [mutableString appendFormat:@"%d", i];
        [mutableString writeToFile:[path stringByAppendingFormat:@"/%d", i] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSURL* url = [NSURL fileURLWithPath:path];
    [self resourceValueForKey:NSURLFileSizeKey url:url];
    [self resourceValueForKey:NSURLFileAllocatedSizeKey url:url];
    [self resourceValueForKey:NSURLTotalFileSizeKey url:url];
    [self resourceValueForKey:NSURLTotalFileAllocatedSizeKey url:url];
}

-(unsigned long long)resourceValueForKey:(NSString*)key url:(NSURL*)url {
    NSDirectoryEnumerator* enumerator = [[NSFileManager defaultManager] enumeratorAtURL:url includingPropertiesForKeys:@[key] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    unsigned long long totalSize = 0;
    NSNumber* size = @(totalSize);
    for(NSURL* url in enumerator) {
        @autoreleasepool {
            [url getResourceValue:&size forKey:key error:nil];
            totalSize += [size unsignedLongLongValue];
        }
    }
    NSLog(@"%@ = %llu", key, totalSize);
    return totalSize;
}

@end
