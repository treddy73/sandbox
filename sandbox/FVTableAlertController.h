//
//  FVTableAlertController.h
//  FieldView
//
//  Created by Timothy Reddy on 7/7/17.
//  Copyright © 2017 The Climate Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FVTableAlertController : NSObject
@property (strong, nonatomic, readonly) UIAlertController* alertController;
@property (strong, nonatomic, readonly) UITableViewController* tableViewController;

-(instancetype)initWithAlertController:(UIAlertController*)alertController tableViewController:(UITableViewController*)tableViewController;

@end
