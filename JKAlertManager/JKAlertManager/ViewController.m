//
//  ViewController.m
//  JKAlertManager
//
//  Created by 蒋鹏 on 16/8/10.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "ViewController.h"
#import "JKAlertManager.h"
#import "UIAlertView+BlockExtension.h"
#import "UIActionSheet+BlockExtension.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)JKAlertView * alertView;
@property (nonatomic, strong)UIActionSheet * actionSheet;

@property (nonatomic, strong)JKAlertManager * manager;
@end

@implementation ViewController
NSString * const JKCellKey = @"UITableViewCellReuseKey";
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.title = @"JKAlertManagerDemo";
    }else{
        self.navigationItem.title = @"自动解除循环引用";
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * messgae = @"无Destructive按钮时destructiveIndex默认-2(JKAlertDestructiveIndexNone),Destructive按钮对应UIAlertActionStyleDestructive的title。";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    switch (indexPath.row) {
        case 0:{
            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:self.dataArray[indexPath.row] message:messgae ];
            self.manager = manager;
            [manager configueCancelTitle:nil destructiveIndex:1 otherTitle:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self.manager);
                self.tableView.backgroundColor = [UIColor whiteColor];
            }];
            
        }break;
            
            
        case 1:{
            
            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:self.dataArray[indexPath.row] message:messgae ];
            self.manager = manager;
            [manager configueCancelTitle:@"取消" destructiveIndex:JKAlertDestructiveIndexNone otherTitles:@[@"其他按钮0",@"其他按钮1",@"其他按钮2"]];
            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
                self.tableView.backgroundColor = [UIColor whiteColor];
            }];
//            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:@"请求失败，错误码：2234" message:nil];
//            [manager configueCancelTitle:@"确认" destructiveIndex:JKAlertDestructiveIndexNone otherTitles:nil];
//            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
//                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
//            }];
        }break;
            
            
        case 2:{
            
            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:self.dataArray[indexPath.row] message:nil ];
            self.manager = manager;
            [manager configueCancelTitle:@"取消" destructiveIndex:1 otherTitle:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
                self.tableView.backgroundColor = [UIColor whiteColor];
            }];
            
        }break;
            
        case 3:{
            
            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:self.dataArray[indexPath.row] message:self.dataArray[indexPath.row] ];
            [manager configueCancelTitle:@"取消" destructiveIndex:1 otherTitle:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
            [manager addTextFieldWithPlaceholder:@"请输入账号" secureTextEntry:NO ConfigurationHandler:nil textFieldTextChanged:nil];
            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
                self.tableView.backgroundColor = [UIColor whiteColor];
            }];
            
        }break;
            
        case 4:{
            
            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:self.dataArray[indexPath.row] message:self.dataArray[indexPath.row] ];
            self.manager = manager;
            [manager configueCancelTitle:@"取消" destructiveIndex:1 otherTitle:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
            [manager addTextFieldWithPlaceholder:@"请输入账号" secureTextEntry:NO ConfigurationHandler:nil textFieldTextChanged:nil];
            [manager addTextFieldWithPlaceholder:@"请输入密码" secureTextEntry:YES ConfigurationHandler:^(UITextField *textField) {
                textField.clearsOnBeginEditing = YES;
            } textFieldTextChanged:^(UITextField *textField) {
                NSLog(@"2   %@",textField.text);
                self.view.backgroundColor = [UIColor whiteColor];
            }];
            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
                self.tableView.backgroundColor = [UIColor whiteColor];
//                UITextField * userNameTextField = tempAlertManager.textFields[0];
//                UITextField * passwordTextField = tempAlertManager.textFields[1];
            }];
            
        }break;
            
            
        case 5:{
            
            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleActionSheet title:self.dataArray[indexPath.row] message:messgae ];
            self.manager = manager;
            [manager configueCancelTitle:nil destructiveIndex:2 otherTitle:@"其他按钮1",@"其他按钮2",@"Destructive按钮", nil];
            [manager configuePopoverControllerForActionSheetStyleWithSourceView:cell sourceRect:cell.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
                self.tableView.backgroundColor = [UIColor whiteColor];
            }];
            
        }break;
            
            
        case 6:{
            
            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleActionSheet title:self.dataArray[indexPath.row] message:messgae];
            self.manager = manager;
            [manager configueCancelTitle:nil destructiveIndex:JKAlertDestructiveIndexNone otherTitle:@"其他按钮0",@"其他按钮1",@"其他按钮2", nil];
            [manager configuePopoverControllerForActionSheetStyleWithSourceView:cell sourceRect:cell.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
                self.tableView.backgroundColor = [UIColor whiteColor];
            }];
            
//            [self performSelector:@selector(excuteDelayAction) withObject:nil afterDelay:2.0];
            
            
        }break;
            
            
        case 7:{
            
            JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleActionSheet title:self.dataArray[indexPath.row] message:nil ];
            self.manager = manager;
            [manager configueCancelTitle:nil destructiveIndex:0 otherTitle:@"Destructive按钮",@"其他按钮1",@"其他按钮2", nil];
            [manager configuePopoverControllerForActionSheetStyleWithSourceView:cell sourceRect:cell.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
                NSLog(@" %@, %ld  %@", actionTitle, actionIndex,self);
                self.tableView.backgroundColor = [UIColor whiteColor];
            }];
            
        }break;
        default:
            break;
    }
    
    
}


//- (void)excuteDelayAction {
//    [self.manager dismissWithClickedButtonIndex:1 animated:YES];
//}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳转" style:UIBarButtonItemStylePlain target:self action:@selector(pushAction)];
    }else if (self.navigationController.viewControllers.count == 2){
        UIBarButtonItem * alertIetm = [[UIBarButtonItem alloc]initWithTitle:@"Alert" style:UIBarButtonItemStylePlain target:self action:@selector(testAlertCategory)];
        UIBarButtonItem * sheetItem = [[UIBarButtonItem alloc]initWithTitle:@"ActionSheet" style:UIBarButtonItemStylePlain target:self action:@selector(testActionSheetCategory)];
        self.navigationItem.rightBarButtonItems = @[alertIetm,sheetItem];
    }
}


- (void)pushAction{
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController * controller = [mainStory instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)testAlertCategory{
    self.alertView = [[JKAlertView alloc]initWithTitle:@"title" message:@"message" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"1",@"2",@"3",nil];
    [self.alertView show];
//    [self.alertView showAlertViewWithActionBlock:^(JKAlertView *newAlertView, NSInteger buttonIndex) {
//        NSLog(@"%zd",buttonIndex);
//        self.view.backgroundColor = [UIColor redColor];
//        self.alertView.backgroundColor = [UIColor clearColor];
//    }];
    
    [self performSelector:@selector(dismissWithClickedButtonIndex) withObject:nil afterDelay:2];
}

- (void)dismissWithClickedButtonIndex{
    [self.alertView dismissWithClickedButtonIndex:2 animated:YES];
}

-(void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%zd   %zd    %zd",buttonIndex,alertView.firstOtherButtonIndex,alertView.cancelButtonIndex);
}



- (void)testActionSheetCategory{
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:@"title" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"destructiveButtonTitle" otherButtonTitles:@"otherButtonTitles", nil];
    [self.actionSheet showActionSheetInView:self.view completion:^(UIActionSheet *originalActionSheet, NSInteger buttonIndex) {
        self.view.backgroundColor = [UIColor redColor];
        self.alertView.backgroundColor = [UIColor clearColor];
    }];
}

- (void)dealloc{
    NSLog(@"ViewController 控制器已释放");
}

@end
