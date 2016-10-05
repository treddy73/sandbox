//
//  SandboxTests.m
//  SandboxTests
//
//  Created by Timothy Reddy on 2/16/16.
//  Copyright © 2016 Timothy Reddy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MapKit/MapKit.h>

@interface Blah : NSObject
@property (weak, readwrite, nonatomic) id weakObject;
@end

@implementation Blah
-(NSString *)description {
    return [[super description] stringByAppendingFormat:@" %@", _weakObject];
}
@end

@interface SandboxTests : XCTestCase
-(int)normalize:(float)value;
-(NSArray*)arrayLiteral;
@end

@implementation SandboxTests

-(void)testMKMapRectNull {
    MKMapRect rect = MKMapRectNull;
    NSLog(@"%f, %f   %f, %f", rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
}

-(void)testWeakWrapper {
    XCTestExpectation* expectation = [self expectationWithDescription:@"dictionary results"];
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    @autoreleasepool {
        for(int i = 0; i < 5; ++i) {
            Blah* blah = [[Blah alloc] init];
            [dictionary setObject:blah forKey:@(i)];
        }
        XCTAssertEqual(5, [dictionary count]);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", dictionary);
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

-(void)testPointerArray {
    NSPointerArray* pointerArray = [NSPointerArray weakObjectsPointerArray];
    NSMutableArray* values = [NSMutableArray array];
    for(int i = 0; i < 10; ++i) {
        Blah* blah = [[Blah alloc] init];
        [values addObject:blah];
        [pointerArray addPointer:(__bridge void* _Nullable)(values[i])];
    }
    XCTAssertEqual(10, [pointerArray count]);
    values[3] = @"dude";
    values[4] = @"dude";
    values[5] = @"dude";
    XCTAssertNil([pointerArray pointerAtIndex:3]);
    XCTAssertNil([pointerArray pointerAtIndex:4]);
    XCTAssertNil([pointerArray pointerAtIndex:5]);
}

-(void)testMapTable {
    NSMapTable* mapTable = [NSMapTable strongToWeakObjectsMapTable];
    NSMutableArray* keys = [NSMutableArray array];
    NSMutableArray* values = [NSMutableArray array];
    for(int i = 0; i < 10; ++i) {
        [keys addObject:@(i)];
        [values addObject:[[Blah alloc] init]];
        [mapTable setObject:values[i] forKey:keys[i]];
    }
    XCTAssertEqual(10, [mapTable count]);
    values[1] = @"new value b";
    XCTAssertNil([mapTable objectForKey:keys[1]]);
}

-(void)testMod {
    for(int i=0; i<5; i++) {
        XCTAssertEqual(0, [self normalize:0.0 + (360.0 * i)]);
        XCTAssertEqual(100, [self normalize:10.0 + (360.0 * i)]);
        XCTAssertEqual(3500, [self normalize:-10.0 + (360.0 * i)]);
        XCTAssertEqual(0, [self normalize:0.0 - (360.0 * i)]);
        XCTAssertEqual(100, [self normalize:10.0 - (360.0 * i)]);
        XCTAssertEqual(3500, [self normalize:-10.0 - (360.0 * i)]);
    }
    XCTAssertEqual(0, [self normalize:0.0]);
    XCTAssertEqual(900, [self normalize:90.0]);
    XCTAssertEqual(1800, [self normalize:180.0]);
    XCTAssertEqual(2700, [self normalize:270.0]);
    XCTAssertEqual(0, [self normalize:0.0]);
    XCTAssertEqual(2700, [self normalize:-90.0]);
    XCTAssertEqual(1800, [self normalize:-180.0]);
    XCTAssertEqual(900, [self normalize:-270.0]);
    XCTAssertEqual(900, [self normalize:-270.0 + (-360.0 * 500.0)]);
}

-(void)testString {
    int maxCount = 100000;
    long zoomLevel = 20;
    MKMapPoint mapPoint = MKMapPointMake(0234237408923748092.79327498324, 98279832749237.98237493274);
    int dataType = 0;
    NSString* suffix = @"really long suffix yo dude blah 9023874092jflsdjflsjfoisuflsdjflsdjfl hi";
    NSString* string;
    NSDate* startDate = [NSDate date];
    for(int i = 0; i < maxCount; i++) {
        string = [NSString stringWithFormat:@"%ld_%.0f_%.0f_%d%@", zoomLevel, mapPoint.x, mapPoint.y, dataType, suffix];
    }
    NSLog(@"stringWithFormat seconds:%.6f", [[NSDate date] timeIntervalSinceDate:startDate]);
    startDate = [NSDate date];
    for(int i = 0; i < maxCount; i++) {
        char cString[256];
        sprintf(cString, "%ld_%.0f_%.0f_%d%s", zoomLevel, mapPoint.x, mapPoint.y, dataType, suffix.UTF8String);
        string = [[NSString alloc] initWithCString:cString encoding:NSUTF8StringEncoding];
    }
    NSLog(@"cString seconds:%.6f", [[NSDate date] timeIntervalSinceDate:startDate]);
    startDate = [NSDate date];
    NSData* theData;
    for(int i = 0; i < maxCount; i++) {
        NSMutableData* data = [[NSMutableData alloc] initWithCapacity:256];
        [data appendBytes:&zoomLevel length:sizeof(zoomLevel)];
        int value = (int)mapPoint.x;
        [data appendBytes:&value length:sizeof(value)];
        value = (int)mapPoint.y;
        [data appendBytes:&value length:sizeof(value)];
        [data appendBytes:&dataType length:sizeof(dataType)];
        [data appendBytes:[suffix cStringUsingEncoding:NSUTF8StringEncoding] length:[suffix length]];
        theData = data;//string = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    NSLog(@"NSMutableData seconds:%.6f", [[NSDate date] timeIntervalSinceDate:startDate]);
}

-(void)testEquality {
    int maxCount = 100000;
    long zoomLevel = 20;
    MKMapPoint mapPoint = MKMapPointMake(0234237408923748092.79327498324, 98279832749237.98237493274);
    int dataType = 0;
    NSString* suffix = @"really long suffix yo dude blah 9023874092jflsdjflsjfoisuflsdjflsdjfl hi";
    NSString* string = [NSString stringWithFormat:@"%ld_%.0f_%.0f_%d%@", zoomLevel, mapPoint.x, mapPoint.y, dataType, suffix];
    NSString* otherString = [NSString stringWithFormat:@"%ld_%.0f_%.0f_%d%@", zoomLevel, mapPoint.x, mapPoint.y, dataType, suffix];
    NSDate* startDate = [NSDate date];
    BOOL isEqual;
    for(int i = 0; i < maxCount; i++) {
        isEqual = [string isEqual:otherString];
    }
    NSLog(@"string seconds:%.6f", [[NSDate date] timeIntervalSinceDate:startDate]);
    startDate = [NSDate date];
    NSMutableData* data = [[NSMutableData alloc] initWithCapacity:256];
    [data appendBytes:&zoomLevel length:sizeof(zoomLevel)];
    int value = (int)mapPoint.x;
    [data appendBytes:&value length:sizeof(value)];
    value = (int)mapPoint.y;
    [data appendBytes:&value length:sizeof(value)];
    [data appendBytes:&dataType length:sizeof(dataType)];
    [data appendBytes:[suffix cStringUsingEncoding:NSUTF8StringEncoding] length:[suffix length]];
    NSData* otherData = [NSData dataWithData:data];
    for(int i = 0; i < maxCount; i++) {
        isEqual = [data isEqual:otherData];
    }
    NSLog(@"NSData seconds:%.6f", [[NSDate date] timeIntervalSinceDate:startDate]);
}

-(void)testArrayLiteral {
    XCTAssertNotEqual([self arrayLiteral], [self arrayLiteral]);
}

-(void)testSignificantDigits {
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setUsesSignificantDigits:YES];
    [formatter setMinimumSignificantDigits:3];
    [formatter setMaximumSignificantDigits:15];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:0];
    [formatter setMaximumFractionDigits:2];
    [formatter setMultiplier:@(1.0)];
    [formatter setZeroSymbol:@"0"];
    [formatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    [formatter setGroupingSize:3];
    [formatter setUsesGroupingSeparator:YES];
    double value = 0.001234567;
    for (int i = 0; i < 10; i++) {
        NSLog(@"%d - %@", i, [formatter stringFromNumber:@(value * pow(10, i))]);
    }
}

-(void)testPredicate {
    NSArray<NSString*>* strings = @[@"one", @"two", @"three", @"monkey", @"money"];
    NSArray<NSString*>* expectedResults[2] = {@[@"one"], @[@"one", @"money"]};
    NSArray<NSString*>* conditionals = @[@"=", @"contains[cd]"];
    int i = 0;
    for (NSString* condition in conditionals) {
        NSString* predicateString = [NSString stringWithFormat:@"self %@ '%@'", condition, @"one"];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateString];
        XCTAssertEqualObjects(expectedResults[i], [strings filteredArrayUsingPredicate:predicate]);
        i++;
    }
}

-(int)normalize:(float)value {
    int normalizedHeading = (int)(value * 10) % 3600;
    if(normalizedHeading < 0) {
        normalizedHeading += 3600;
    }
    return normalizedHeading;
}

-(NSArray*)arrayLiteral {
    return @[@"one", @"two", @"three"];
}

@end
