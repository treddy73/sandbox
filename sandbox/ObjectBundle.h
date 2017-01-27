//
//  ObjectBundle.h
//  sandbox
//
//  Created by Timothy Reddy on 1/27/17.
//  Copyright © 2017 Timothy Reddy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef int BundleID;

@interface ObjectBundle<__covariant ObjectType> : NSObject

-(void)addObject:(ObjectType)object withBundleID:(BundleID)bundleID;
-(NSArray<NSNumber*>*)bundleIDs;

-(void)enumerateAllObjectsUsingBlock:(void (^)(ObjectType object, BundleID bundleID, BOOL* stop))block;
-(void)enumerateObjectsWithBundleID:(BundleID)bundleID usingBlock:(void (^)(ObjectType object, NSUInteger index, BOOL* stop))block;

@end
