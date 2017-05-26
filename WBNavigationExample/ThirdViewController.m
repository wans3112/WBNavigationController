//
//  ThirdViewController.m
//  WBNavigationExample
//
//  Created by wans on 2017/5/25.
//  Copyright © 2017年 wans. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

WB_IMPLEMENT_LOAD(URL_THIRD_VC)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"third";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *testButton = [[UIButton alloc] init];
    testButton.frame = CGRectMake(50, 100, 100, 80);
    [testButton setTitle:@"pop" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    testButton.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:testButton];
    
    // 获取前页面传递过来的参数
    if( self.wb_params ) NSLog(@"push get params >> %@", self.wb_params[@"params"]);
    
}

- (void)testButtonPressed:(UIButton *)button {
    
    if ( self.wb_replyAction ) {
        // 将数据返回给前页面
        self.wb_replyAction(@{@"result": @"pop return data"});
    }
    
    [self wb_popViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
