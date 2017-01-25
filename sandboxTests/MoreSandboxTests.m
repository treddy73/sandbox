//
//  MoreSandboxTests.m
//  sandbox
//
//  Created by Timothy Reddy on 1/25/17.
//  Copyright © 2017 Timothy Reddy. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MoreThingy : NSObject
@property (strong, nonatomic, readwrite) NSDate* date;
@end

@implementation MoreThingy
@end

@interface ThingyRecord : NSObject
@property (strong, nonatomic, readwrite) NSSet<MoreThingy*>* moreRecords;
@end

@implementation ThingyRecord
@end

@interface ThingyModel : NSObject
@property (strong, nonatomic, readwrite) NSSet<ThingyRecord*>* records;
@end

@implementation ThingyModel
@end

@interface MoreSandboxTests : XCTestCase
@end

@implementation MoreSandboxTests

-(void)testNestedSetPredicate {
    NSMutableSet<MoreThingy*>* mutableSet = [[NSMutableSet alloc] init];
    for (int i = 0; i < 3; i++) {
        MoreThingy* moreThingy = [[MoreThingy alloc] init];
        [moreThingy setDate:[NSDate dateWithTimeIntervalSince1970:i]];
        [mutableSet addObject:moreThingy];
    }
    ThingyRecord* thingyRecord = [[ThingyRecord alloc] init];
    [thingyRecord setMoreRecords:mutableSet];
    ThingyModel* thingyModel = [[ThingyModel alloc] init];
    [thingyModel setRecords:[NSSet setWithObject:thingyRecord]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ANY moreRecords.date >= %@ and ANY moreRecords.date <= %@", [NSDate dateWithTimeIntervalSince1970:1], [NSDate dateWithTimeIntervalSince1970:1]];
    NSSet* set = [[thingyModel records] filteredSetUsingPredicate:predicate];
    XCTAssertTrue([set count] > 0);
}

@end
