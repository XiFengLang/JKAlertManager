//
//  JKAlertView.m
//  JKAlertManager
//
//  Created by 蒋鹏 on 16/8/18.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "JKAlertView.h"
#import "JKAlertManager.h"

@implementation JKAlertView{
    JKAlertManager * _manager;
    NSString * _cancelButtonTitle;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION{
    if(self = [super initWithFrame:CGRectZero]){
        
        va_list argList;
        NSMutableArray * otherTitles = [[NSMutableArray alloc]init];
        if (otherButtonTitles) {
            [otherTitles addObject:otherButtonTitles];
            va_start(argList, otherButtonTitles);
            NSString * actionTitle = nil;
            while ((actionTitle = va_arg(argList, NSString*))) {
                [otherTitles addObject:actionTitle];
            }
        }
        _cancelButtonTitle = cancelButtonTitle;
        
        if(cancelButtonTitle){
            _cancelButtonIndex = 0;
        }else{
            _cancelButtonIndex = -1;
        }
        
        
        if (otherTitles.count){
            _firstOtherButtonIndex = _cancelButtonIndex + 1;
        }else{
            _firstOtherButtonIndex = -1;
        }
        
        self.delegate = delegate;
        
        JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:title message:message];
        [manager configueCancelTitle:cancelButtonTitle destructiveIndex:JKAlertDestructiveIndexNone otherTitles:otherTitles.copy];
        _manager = manager;
    }return self;
}


- (void)show{
    [self.keyWindow addSubview:self];
    [_manager showAlertFromController:self.currentViewController actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
        
        
        BOOL hasCancelButtonTitle = _cancelButtonTitle ? 1 : 0;
        NSInteger buttonIndex = actionIndex + hasCancelButtonTitle;
        if(actionIndex == tempAlertManager.cancelIndex){
            buttonIndex = 0;
        }
        
        NSLog(@"%zd  %@  %zd",actionIndex,actionTitle,buttonIndex);
        if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]){
            [self.delegate alertView:self clickedButtonAtIndex:buttonIndex];
        }
        [self removeFromSuperview];
    }];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    NSInteger buttonIndex_copy = buttonIndex;
    if(_cancelButtonTitle){
        if (buttonIndex == self.cancelButtonIndex) {
            buttonIndex_copy = _manager.cancelIndex;
        }else{
            buttonIndex_copy = buttonIndex - 1;
        }
    }
    [_manager dismissWithClickedButtonIndex:buttonIndex_copy animated:animated];
}



- (UIWindow *)keyWindow{
    NSArray * windows = [UIApplication sharedApplication].windows;
    for (id window in windows) {
        if ([window isKindOfClass:[UIWindow class]]) {
            return (UIWindow *)window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}


- (UIViewController *)currentViewController{
    UIViewController * viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

// 遍历正在显示（最上层）的控制器
- (UIViewController *)findBestViewController:(UIViewController *)viewController{
    if (viewController.presentedViewController) {
        return [self findBestViewController:viewController.presentedViewController];
        
    } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController * masterViewController = (UISplitViewController *)viewController;
        if (masterViewController.viewControllers.count > 0)
            return [self findBestViewController:masterViewController.viewControllers.lastObject];
        else
            return viewController;
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * masterViewController = (UINavigationController *)viewController;
        if (masterViewController.viewControllers.count > 0)
            return [self findBestViewController:masterViewController.topViewController];
        else
            return viewController;
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController * masterViewController = (UITabBarController *) viewController;
        if (masterViewController.viewControllers.count > 0)
            return [self findBestViewController:masterViewController.selectedViewController];
        else
            return viewController;
    } else {
        return viewController;
    }
}



- (void)dealloc{
    NSLog(@"JKAlertView 已释放 ");
}
@end
