//
//  DispatchTests.m
//  Sandbox
//
//  Created by Timothy Reddy on 4/14/16.
//  Copyright © 2016 Timothy Reddy. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TRBlock : NSObject
-(void)doSomethingWithCompletionBlock:(void (^)(int value))block;
@end

@implementation TRBlock
-(void)doSomethingWithCompletionBlock:(void (^)(int value))block {
    block(arc4random() % 15000);
}

@end

@interface DispatchTests : XCTestCase {
    dispatch_queue_t _workQueue;
    dispatch_queue_t _readWriteQueue;
    dispatch_semaphore_t _semaphore;
    int _value;
}
-(void)read:(int)i;
-(void)write:(int)i;
@end

@implementation DispatchTests

-(void)testBlock {
    TRBlock* trBlock = [[TRBlock alloc] init];
    [trBlock doSomethingWithCompletionBlock:^(int value){
        XCTAssertNotEqual(0, value);
    }];
}

-(void)testDispatch {
    _workQueue = dispatch_queue_create("com.work", DISPATCH_QUEUE_CONCURRENT);
    _readWriteQueue = dispatch_queue_create("com.readwrite", DISPATCH_QUEUE_CONCURRENT);
    _semaphore = dispatch_semaphore_create(50);
    _value = 0;
    for(int i = 0; i < 1000; i++) {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(_workQueue, ^{
            if(arc4random() % 4 == 0) {
                [self write:i];
            } else {
                [self read:i];
            }
        });
    }
    XCTestExpectation* expectation = [self expectationWithDescription:@"dude"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:6.0 handler:nil];
}

-(void)read:(int)i {
    dispatch_sync(_readWriteQueue, ^{
        NSLog(@"[%d] read:%d", i, _value);
        dispatch_semaphore_signal(_semaphore);
    });
}

-(void)write:(int)i {
    dispatch_barrier_sync(_readWriteQueue, ^{
        _value++;
        NSLog(@"[%d] write:%d", i, _value);
        dispatch_semaphore_signal(_semaphore);
    });
}

@end
