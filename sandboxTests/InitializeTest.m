//
//  InitializeTest.m
//  sandbox
//
//  Created by Timothy Reddy on 6/7/16.
//  Copyright © 2016 Timothy Reddy. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MyClass : NSObject
-(void)string;
@end

@implementation MyClass
+(void)initialize {
    if(self == [MyClass class]) {
        sleep(5);
        NSLog(@"Initialize Done!");
    }
}

-(void)string {
    NSLog(@"here is a cool string");
}
@end

@interface InitializeTest : XCTestCase
@end

@implementation InitializeTest

-(void)testInitialize {
    //Testing +initialize behavior...expectation is +initialize completes before any instances will get created
    XCTestExpectation* expectation = [self expectationWithDescription:@"dude"];
    dispatch_queue_t queue = dispatch_queue_create("ding", NULL);
    dispatch_async(queue, ^{
        NSLog(@"Initializing myClass");
        [MyClass initialize];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Creating myClass");
        MyClass* myClass = [[MyClass alloc] init];
        [myClass string];
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end
