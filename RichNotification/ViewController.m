//
//  ViewController.m
//  RichNotification
//
//  Created by WebDunia on 17/07/18.
//  Copyright © 2018 Webdunia. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)sendNotification:(id)sender {
    [[AppDelegate appDelegateObject] sendNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
