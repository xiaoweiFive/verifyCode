//
//  ViewController.m
//  ImageVerifyCode
//
//  Created by zhangzhenwei on 16/11/4.
//  Copyright © 2016年 zhangzhenwei. All rights reserved.
//

#import "ViewController.h"
#import "QSCLoginImageVerifyView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:@"点击有惊喜" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}


- (void)clickBtn {
    QSCLoginImageVerifyView *view = [[QSCLoginImageVerifyView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
    
    [view verifySuccess:^{
        NSLog(@"去登陆吧，还在等什么");
    } filure:^{
        NSLog(@"输入错误，请继续输入");
    }];
    
}


@end
