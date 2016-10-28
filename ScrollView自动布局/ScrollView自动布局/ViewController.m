//
//  ViewController.m
//  ScrollView自动布局
//
//  Created by 张江东 on 16/10/28.
//  Copyright © 2016年 58kuaipai. All rights reserved.
//

#import "ViewController.h"
#import "TwoViewController.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)next:(id)sender {
    TwoViewController *twoVc = [TwoViewController new];
    twoVc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:twoVc animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
