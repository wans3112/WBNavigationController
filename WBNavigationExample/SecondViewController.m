//
//  SecondViewController.m
//  WBNavigationExample
//
//  Created by wans on 2017/5/25.
//  Copyright © 2017年 wans. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
WB_IMPLEMENT_LOAD(URL_SECOND_VC)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *testButton = [[UIButton alloc] init];
    testButton.frame = CGRectMake(50, 100, 100, 80);
    [testButton setTitle:@"dismiss" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    testButton.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:testButton];
    
    if( self.wb_params ) NSLog(@"present get params >> %@", self.wb_params[@"params"]);
    
}

- (void)testButtonPressed:(UIButton *)button {
        
    if ( self.wb_replyAction ) {
        self.wb_replyAction(@{@"result": @"dismiss return data"});
    }
    
    [self wb_dismissSimpleViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
