//
//  PThreadTest.m
//  sandbox
//
//  Created by Timothy Reddy on 4/26/16.
//  Copyright © 2016 Timothy Reddy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <pthread.h>

@interface PThreadTest : XCTestCase {
    pthread_rwlock_t _rwlock;
    int _value;
}
-(void)read:(int)i;
-(void)write:(int)i;
@end

@implementation PThreadTest

-(void)setUp {
    pthread_rwlockattr_t attributes;
    pthread_rwlockattr_init(&attributes);
    pthread_rwlock_init(&_rwlock, &attributes);
    pthread_rwlockattr_destroy(&attributes);
}

-(void)tearDown {
    pthread_rwlock_destroy(&_rwlock);
}

-(void)testRWLock {
    dispatch_queue_t workQueue = dispatch_queue_create("com.work", DISPATCH_QUEUE_CONCURRENT);
    _value = 0;
    for(int i = 0; i < 1000; i++) {
        dispatch_async(workQueue, ^{
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
    pthread_rwlock_rdlock(&_rwlock);
    NSLog(@"[%d] read:%d", i, _value);
    pthread_rwlock_unlock(&_rwlock);
}

-(void)write:(int)i {
    pthread_rwlock_wrlock(&_rwlock);
    _value++;
    NSLog(@"[%d] write:%d", i, _value);
    pthread_rwlock_unlock(&_rwlock);
}

@end
