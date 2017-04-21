//
//  BlockViewController.m
//  JKAlertManager
//
//  Created by 蒋鹏 on 2017/4/21.
//  Copyright © 2017年 蒋鹏. All rights reserved.
//

#import "BlockViewController.h"


#import "UIAlertView+BlockExtension.h"
#import "UIActionSheet+BlockExtension.h"

@interface BlockViewController ()

@property (nonatomic, strong)UIAlertView * alertView;
@property (nonatomic, strong)UIActionSheet * actionSheet;

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)testAlterView:(id)sender {
    
    self.alertView = [[UIAlertView alloc]initWithTitle:@"UIAlertView + Block" message:@"message" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"1",@"2",@"3",nil];
    [self.alertView show];
    [self.alertView showAlertViewWithActionBlock:^(UIAlertView *newAlertView, NSInteger buttonIndex) {
        NSLog(@"%zd",buttonIndex);
        self.view.backgroundColor = [UIColor redColor];
        self.alertView.backgroundColor = [UIColor redColor];
    }];
}

- (IBAction)testActionSheet:(id)sender {
    
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:@"UIActionSheet + Block" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"destructiveButtonTitle" otherButtonTitles:@"otherButtonTitles", nil];
    [self.actionSheet showActionSheetInView:self.view completion:^(UIActionSheet *originalActionSheet, NSInteger buttonIndex) {
        self.view.backgroundColor = [UIColor redColor];
        self.alertView.backgroundColor = [UIColor clearColor];
    }];
}


- (void)dealloc{
    NSLog(@"%@被释放",[self class]);
}
@end
