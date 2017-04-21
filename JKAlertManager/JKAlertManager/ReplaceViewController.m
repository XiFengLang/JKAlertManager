//
//  ReplaceViewController.m
//  JKAlertManager
//
//  Created by 蒋鹏 on 2017/4/21.
//  Copyright © 2017年 蒋鹏. All rights reserved.
//

#import "ReplaceViewController.h"
#import "JKAlertView.h"

@interface ReplaceViewController () <JKAlertViewDelegate>

@property (nonatomic, weak)JKAlertView * alertView;

@end

@implementation ReplaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)orginalAlterView:(id)sender {
    [self showAlertView:[UIAlertView class]];
}
- (IBAction)replacedAlertView:(id)sender {
    [self showAlertView:[JKAlertView class]];
}

- (void)showAlertView:(Class)class {
    
    /// 实际用法就是将UIAlertView全局替换成JKAlertView即可。
    /// UIAlertViewDelegate  --> JKAlertViewDelegate
    /// UIAlertView  --> JKAlertView
    
    JKAlertView * alertView = [[class alloc]initWithTitle:NSStringFromClass(class) message:@"message" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"1",@"2",@"3",nil];
    [alertView show];
    self.alertView = (JKAlertView *)alertView;
    
    
    /// 手动隐藏
//    [self performSelector:@selector(dismissWithClickedButtonIndex) withObject:nil afterDelay:2];
}



/**
 JKAlertView和UIAlertView通用代理方法
 */
-(void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"点击AlertView:%zd   %zd    %zd",buttonIndex,alertView.firstOtherButtonIndex,alertView.cancelButtonIndex);
}




/**
 手动隐藏
 */
- (void)dismissWithClickedButtonIndex {
    [self.alertView dismissWithClickedButtonIndex:2 animated:YES];
}


- (void)dealloc{
    NSLog(@"%@被释放",[self class]);
}
@end
