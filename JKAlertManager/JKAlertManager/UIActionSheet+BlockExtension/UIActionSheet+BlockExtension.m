//
//  UIActionSheet+BlockExtension.m
//  JKAlertManager
//
//  Created by 蒋鹏 on 16/4/7.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "UIActionSheet+BlockExtension.h"
#import <objc/runtime.h>

@implementation UIActionSheet (BlockExtension)

- (void)showActionSheetInView:(UIView *)contentView completion:(ActionSheetBlock)completion{
    objc_setAssociatedObject(self, "ActionSheetBlockKey", completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.delegate = self;
    [self showInView:contentView];
}


- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    ActionSheetBlock completion = objc_getAssociatedObject(self, "ActionSheetBlockKey");
    objc_removeAssociatedObjects(self);
    completion(actionSheet,buttonIndex);
    actionSheet = nil;
    completion = nil;
}



#warning !!! 测试完就注释掉下面的代码

#ifdef DEBUG
- (void)dealloc{
    NSLog(@"%@被释放",[self class]);
}
#endif

@end
