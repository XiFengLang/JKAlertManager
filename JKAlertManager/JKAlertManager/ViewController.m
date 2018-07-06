//
//  ViewController.m
//  JKAlertManager
//
//  Created by 蒋鹏 on 16/8/10.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "ViewController.h"
//#import <JKAlertManager/JKAlertManager.h>
#import "UIAlertView+BlockExtension.h"
#import "UIActionSheet+BlockExtension.h"

#import "JKAlertManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray * dataArray;




@property (nonatomic, strong)JKAlertManager * manager;
@end

@implementation ViewController
NSString * const JKCellKey = @"UITableViewCellReuseKey";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"自动解除循环引用";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = UIView.new;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:JKCellKey];
    
    NSArray * array = @[@"StyleAlert,无CancelButtonTitle,有Destructive按钮",
                        @"StyleAlert,有CancelButtonTitle,无Destructive按钮",
                        @"StyleAlert,有title,无message",
                        @"StyleAlert,带1个TextField",
                        @"StyleAlert,带2个TextField",
                        @"ActionSheet,有Destructive按钮",
                        @"ActionSheet,无Destructive按钮",
                        @"ActionSheet,有title,无message"];
    self.dataArray = [[NSMutableArray alloc]initWithArray:array];
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * messgae = @"无Destructive按钮时destructiveIndex默认-2(JKAlertDestructiveIndexNone),Destructive按钮对应UIAlertActionStyleDestructive的title。";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    switch (indexPath.row) {
        case 0:{
//            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:self.dataArray[indexPath.row] message:messgae ];
//            self.manager = manager;
//            [manager configueCancelTitle:nil destructiveIndex:1 otherTitle:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
//            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
//                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self.manager);
//                self.tableView.backgroundColor = [UIColor whiteColor];
//            }];
            
        }break;
            
            
        case 1:{
            
//            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:self.dataArray[indexPath.row] message:messgae ];
//            self.manager = manager;
//            [manager configueCancelTitle:@"取消" destructiveIndex:JKAlertDestructiveIndexNone otherTitles:@[@"其他按钮0",@"其他按钮1",@"其他按钮2"]];
//            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
//                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
//                self.tableView.backgroundColor = [UIColor whiteColor];
//            }];
        }break;
            
            
        case 2:{
            
//            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:self.dataArray[indexPath.row] message:nil ];
//            self.manager = manager;
//            [manager configueCancelTitle:@"取消" destructiveIndex:1 otherTitle:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
//            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
//                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
//                self.tableView.backgroundColor = [UIColor whiteColor];
//            }];
            
        }break;
            
        case 3:{
            
//            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:self.dataArray[indexPath.row] message:self.dataArray[indexPath.row] ];
//            [manager configueCancelTitle:@"取消" destructiveIndex:1 otherTitle:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
//            [manager addTextFieldWithPlaceholder:@"请输入账号" secureTextEntry:NO ConfigurationHandler:nil textFieldTextChanged:nil];
//            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
//                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
//                self.tableView.backgroundColor = [UIColor whiteColor];
//            }];
            
        }break;
            
        case 4:{
            
//            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:self.dataArray[indexPath.row] message:self.dataArray[indexPath.row] ];
//            self.manager = manager;
//            [manager configueCancelTitle:@"取消" destructiveIndex:1 otherTitle:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
//            [manager addTextFieldWithPlaceholder:@"请输入账号" secureTextEntry:NO ConfigurationHandler:nil textFieldTextChanged:nil];
//            [manager addTextFieldWithPlaceholder:@"请输入密码" secureTextEntry:YES ConfigurationHandler:^(UITextField *textField) {
//                textField.clearsOnBeginEditing = YES;
//            } textFieldTextChanged:^(UITextField *textField) {
//                NSLog(@"2   %@",textField.text);
//                self.view.backgroundColor = [UIColor whiteColor];
//            }];
//            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
//                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
//
//                self.tableView.backgroundColor = [UIColor whiteColor];
////                UITextField * userNameTextField = tempAlertManager.textFields[0];
////                UITextField * passwordTextField = tempAlertManager.textFields[1];
//            }];
            
        }break;
            
            
        case 5:{
            
//            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleActionSheet title:self.dataArray[indexPath.row] message:messgae ];
//            self.manager = manager;
//            [manager configueCancelTitle:nil destructiveIndex:2 otherTitle:@"其他按钮1",@"其他按钮2",@"Destructive按钮", nil];
//            [manager configuePopoverControllerForActionSheetStyleWithSourceView:cell sourceRect:cell.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
//            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
//                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
//                self.tableView.backgroundColor = [UIColor whiteColor];
//            }];
            
        }break;
            
            
        case 6:{
            
//            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleActionSheet title:self.dataArray[indexPath.row] message:messgae];
//            self.manager = manager;
//            [manager configueCancelTitle:nil destructiveIndex:JKAlertDestructiveIndexNone otherTitle:@"其他按钮0",@"其他按钮1",@"其他按钮2", nil];
//            [manager configuePopoverControllerForActionSheetStyleWithSourceView:cell sourceRect:cell.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
//            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
//                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
//                self.tableView.backgroundColor = [UIColor whiteColor];
//            }];
            
        }break;
            
            
        case 7:{
            
//            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleActionSheet title:self.dataArray[indexPath.row] message:nil ];
//            self.manager = manager;
//            [manager configueCancelTitle:nil destructiveIndex:0 otherTitle:@"Destructive按钮",@"其他按钮1",@"其他按钮2", nil];
//            [manager configuePopoverControllerForActionSheetStyleWithSourceView:cell sourceRect:cell.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
//            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
//                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
//                self.tableView.backgroundColor = [UIColor whiteColor];
//            }];
            
        }break;
        default:
            break;
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:JKCellKey];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (void)dealloc{
    NSLog(@"%@被释放",[self class]);
}

@end
