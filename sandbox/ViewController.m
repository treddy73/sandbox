//
//  ViewController.m
//  sandbox
//
//  Created by Timothy Reddy on 4/20/16.
//  Copyright © 2016 Timothy Reddy. All rights reserved.
//

#import "ViewController.h"
#import "objc/runtime.h"
#import "FVTableAlertController.h"

@interface ViewController () <UITableViewDataSource> {
    UIView* _signalStrengthView;
    UIView* _serviceItemView;
    __weak IBOutlet UILabel* _signalStrengthLabel;
    __weak IBOutlet UILabel *_serviceLabel;
    FVTableAlertController* _tableAlertController;
}
-(void)refreshSignalStrength;
-(void)showAlertTable;
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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showAlertTable];
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

-(void)showAlertTable {
    UITableViewController* tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [[tableViewController tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [[tableViewController tableView] setDataSource:self];
    [tableViewController setPreferredContentSize:CGSizeMake(350, 300)];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    _tableAlertController = [[FVTableAlertController alloc] initWithAlertController:alertController tableViewController:tableViewController];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark UITableViewDataSourceDelegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [[cell textLabel] setText:[NSString stringWithFormat:@"Cell #%d", (int)[indexPath row]]];
    return cell;
}

@end
