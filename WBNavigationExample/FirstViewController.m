//
//  FirstViewController.m
//  WBNavigationExample
//
//  Created by wans on 2017/5/25.
//  Copyright © 2017年 wans. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *testButton = [[UIButton alloc] init];
    testButton.frame = CGRectMake(50, 100, 120, 80);
    [testButton setTitle:@"simple push" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    testButton.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:testButton];
    
    UIButton *testButton2 = [[UIButton alloc] init];
    testButton2.frame = CGRectMake(50, 200, 120, 80);
    [testButton2 setTitle:@"simple present" forState:UIControlStateNormal];
    [testButton2 addTarget:self action:@selector(testButton2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    testButton2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:testButton2];
    
    UIButton *testButton3 = [[UIButton alloc] init];
    testButton3.frame = CGRectMake(200, 100, 100, 80);
    [testButton3 setTitle:@"push" forState:UIControlStateNormal];
    [testButton3 addTarget:self action:@selector(testButton3Pressed:) forControlEvents:UIControlEventTouchUpInside];
    testButton3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:testButton3];
    
    UIButton *testButton4 = [[UIButton alloc] init];
    testButton4.frame = CGRectMake(200, 200, 100, 80);
    [testButton4 setTitle:@"present" forState:UIControlStateNormal];
    [testButton4 addTarget:self action:@selector(testButton4Pressed:) forControlEvents:UIControlEventTouchUpInside];
    testButton4.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:testButton4];
    
}

- (void)testButtonPressed:(UIButton *)button {
    
    [self wb_pushSimpleViewController:URL_THIRD_VC];
}

- (void)testButton2Pressed:(UIButton *)button {
    
    [self wb_presentSimpleViewController:URL_SECOND_VC];
}

- (void)testButton3Pressed:(UIButton *)button {
    
    // 注意block的循环引用
    [self wb_pushViewController:^(WBNode *node) {
        node.url = URL_THIRD_VC;
//        node.animate = NO;
        node.params = @{@"params": @"push data"};
        node.replyAction = ^(id result) {
            NSLog(@"result >> %@", result[@"result"]);
        };
    }];
}

- (void)testButton4Pressed:(UIButton *)button {

    [self wb_presentViewController:^(WBNode *node) {
        node.url = URL_SECOND_VC;
//        node.animate = NO;
        node.params = @{@"params": @"present data"};
        node.completeAction = ^{
            NSLog(@"present complete");
        };
        node.replyAction = ^(id result) {
            NSLog(@"result >> %@", result[@"result"]);
        };
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
