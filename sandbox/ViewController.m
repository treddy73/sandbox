//
//  ViewController.m
//  sandbox
//
//  Created by Timothy Reddy on 4/20/16.
//  Copyright © 2016 Timothy Reddy. All rights reserved.
//

#import "ViewController.h"
#import "objc/runtime.h"

@interface ViewController () {
    UIView* _signalStrengthView;
    UIView* _serviceItemView;
    __weak IBOutlet UILabel* _signalStrengthLabel;
    __weak IBOutlet UILabel *_serviceLabel;
}
-(void)refreshSignalStrength;
@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    UIApplication *app = [UIApplication sharedApplication];
    NSArray* subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    for (id subview in subviews) {
        NSLog(@"%@", [subview class]);
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]]) {
            _signalStrengthView = subview;
        }
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarServiceItemView") class]]) {
            _serviceItemView = subview;
        }
    }
    
    [self refreshSignalStrength];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)refreshSignalStrength {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int signalStrength = [[_signalStrengthView valueForKey:@"signalStrengthRaw"] intValue];
        [_signalStrengthLabel setText:[NSString stringWithFormat:@"%d", signalStrength]];
        [_serviceLabel setText:[_serviceItemView valueForKey:@"serviceString"]];
        [self refreshSignalStrength];
    });
}

@end
