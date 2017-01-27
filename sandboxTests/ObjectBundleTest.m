//
//  ObjectBundleTest.m
//  sandbox
//
//  Created by Timothy Reddy on 1/27/17.
//  Copyright © 2017 Timothy Reddy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ObjectBundle.h"

@interface ObjectBundleTest : XCTestCase
@end

@implementation ObjectBundleTest

-(void)testObjectBundle {
    ObjectBundle<NSString*>* bundle = [[ObjectBundle alloc] init];
    [bundle addObject:@"a" withBundleID:0];
    [bundle addObject:@"f" withBundleID:100];
    [bundle addObject:@"c" withBundleID:1];
    [bundle addObject:@"b" withBundleID:0];
    [bundle addObject:@"d" withBundleID:1];
    [bundle addObject:@"e" withBundleID:5];
    
    NSArray* expectedBundleIDs = @[@(0), @(1), @(5), @(100)];
    XCTAssertEqualObjects(expectedBundleIDs, [bundle bundleIDs]);
    
    NSArray* expectedObjects = @[@"a", @"b", @"c", @"d", @"e", @"f"];
    __block NSMutableArray* actualObjects = [[NSMutableArray alloc] init];
    [bundle enumerateAllObjectsUsingBlock:^(NSString* object, BundleID bundleID, BOOL* stop) {
        [actualObjects addObject:object];
    }];
    XCTAssertEqualObjects(expectedObjects, actualObjects);
    
    expectedObjects = @[@"f"];
    actualObjects = [[NSMutableArray alloc] init];
    [bundle enumerateObjectsWithBundleID:100 usingBlock:^(NSString* object, NSUInteger index, BOOL* stop) {
        [actualObjects addObject:object];
    }];
    XCTAssertEqualObjects(expectedObjects, actualObjects);

    expectedObjects = @[@"a"];
    actualObjects = [[NSMutableArray alloc] init];
    [bundle enumerateObjectsWithBundleID:0 usingBlock:^(NSString* object, NSUInteger index, BOOL* stop) {
        *stop = YES;
        [actualObjects addObject:object];
    }];
    XCTAssertEqualObjects(expectedObjects, actualObjects);
}

@end
