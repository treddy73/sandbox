//
//  ObjectBundle.m
//  sandbox
//
//  Created by Timothy Reddy on 1/27/17.
//  Copyright © 2017 Timothy Reddy. All rights reserved.
//

#import "ObjectBundle.h"

@interface ObjectBundle<ObjectType> () {
    NSMutableDictionary<NSNumber*, NSMutableArray<ObjectType>*>* _bundles;
}
-(NSMutableArray<ObjectType>*)bundleForBundleID:(BundleID)bundleID;
@end

@implementation ObjectBundle

#pragma mark Lifecycle Management

-(instancetype)init {
    self = [super init];
    if (self) {
        _bundles = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark Bundle Operations

-(void)addObject:(id)object withBundleID:(BundleID)bundleID {
    [[self bundleForBundleID:bundleID] addObject:object];
}

-(NSArray<NSNumber *> *)bundleIDs {
    return [[_bundles allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

-(void)enumerateAllObjectsUsingBlock:(void (^)(id, BundleID, BOOL *))block {
    BOOL stop = NO;
    for (NSNumber* key in [self bundleIDs]) {
        BundleID bundleID = [key intValue];
        for (id object in _bundles[key]) {
            block(object, bundleID, &stop);
            if (stop) {
                break;
            }
        }
        if (stop) {
            break;
        }
    }
}

-(void)enumerateObjectsWithBundleID:(BundleID)bundleID usingBlock:(void (^)(id, NSUInteger, BOOL *))block {
    //DEVELOPER:Access the data directly here so a bundleID that isn't found will just return nil
    [_bundles[@(bundleID)] enumerateObjectsUsingBlock:block];
}

#pragma mark Private Methods

-(NSMutableArray*)bundleForBundleID:(BundleID)bundleID {
    //DEVELOPER:This method is not thread safe ... it is your job to make it safe ...
    NSNumber* bundleKey = @(bundleID);
    NSMutableArray* bundle = _bundles[bundleKey];
    if (!bundle) {
        bundle = [[NSMutableArray alloc] init];
        _bundles[bundleKey] = bundle;
    }
    return bundle;
}

@end
