//
//  FVTableAlertController.m
//  FieldView
//
//  Created by Timothy Reddy on 7/7/17.
//  Copyright © 2017 The Climate Corporation. All rights reserved.
//

#import "FVTableAlertController.h"

//Various plucky developers have wondered how to do this ... here's one example ...
//https://stackoverflow.com/questions/34593191/how-to-customize-uialertcontroller-with-uitableview-or-is-there-any-default-cont
@interface UIAlertController (FVTableAlertController)
@property (nonatomic, strong) UIViewController* contentViewController;  //I'm exposing a private iVar here ... might break with future iOS releases ...
@end

@interface FVTableAlertController () {
    UIAlertController* _alertController;
    UITableViewController* _tableViewController;
}
@end

@implementation FVTableAlertController

#pragma mark Lifecycle Management

-(instancetype)initWithAlertController:(UIAlertController *)alertController tableViewController:(UITableViewController *)tableViewController {
    self = [super init];
    if (self) {
        _alertController = alertController;
        _tableViewController = tableViewController;
        [_alertController setContentViewController:_tableViewController];
        [_alertController setPreferredContentSize:[_tableViewController preferredContentSize]];
    }
    return self;
}

-(void)dealloc {
    if (_alertController) {
        UIAlertController* alertController = _alertController;
        _alertController = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

@end
