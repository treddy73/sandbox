//
//  KVCTest.m
//  Sandbox
//
//  Created by Timothy Reddy on 4/19/16.
//  Copyright © 2016 Timothy Reddy. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Record : NSObject
@property (nonatomic, strong) NSArray* string;
@property (nonatomic, assign) NSUInteger uniqueStringCount;
-(instancetype)initWithString:(NSString*)string;
@end

@implementation Record
-(instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _string = @[string];
        _uniqueStringCount = 1;
    }
    return self;
}
-(NSUInteger)uniqueStringCount {
    return [_string count];
}
@end

@interface KVCTest : XCTestCase

@end

@implementation KVCTest

-(void)testString {
    NSMutableArray* array = [NSMutableArray array];
    [array addObject:[[Record alloc] initWithString:@"a"]];
    [array addObject:[[Record alloc] initWithString:@"a"]];
    [array addObject:[[Record alloc] initWithString:@"b"]];
    [array addObject:[[Record alloc] initWithString:@"c"]];
    [array addObject:[[Record alloc] initWithString:@"c"]];
    Record* newRecord = [[Record alloc] init];
    [newRecord setValue:[array valueForKeyPath:@"@distinctUnionOfArrays.string"] forKey:@"string"];
    NSMutableArray* newArray = [NSMutableArray array];
    [newArray addObject:newRecord];
    [newArray addObject:[[Record alloc] initWithString:@"oiweur"]];
    [newArray addObject:[[Record alloc] initWithString:@"b"]];
    [newArray addObject:[[Record alloc] initWithString:@"b"]];
    Record* finalRecord = [[Record alloc] init];
    [finalRecord setValue:[newArray valueForKeyPath:@"@distinctUnionOfArrays.string"] forKey:@"string"];
    NSLog(@"******RESULT*****\n%d", (int)[finalRecord uniqueStringCount]);
//    NSLog(@"****RESULT****\n%@", [array valueForKeyPath:@"@distinctUnionOfObjects.string"]);
//    NSLog(@"****RESULT****\n%@", [[array valueForKeyPath:@"@distinctUnionOfObjects.string"] valueForKeyPath:@"@count"]);
}

@end