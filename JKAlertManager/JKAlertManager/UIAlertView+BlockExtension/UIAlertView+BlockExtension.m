//
//  UIAlertView+BlockExtension.m
//  JKAlertManager
//
//  Created by 蒋鹏 on 16/3/2.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "UIAlertView+BlockExtension.h"
#import <objc/runtime.h>

@implementation UIAlertView (BlockExtension)


- (void)showAlertViewWithActionBlock:(AlertViewBlock)block{
    objc_setAssociatedObject(self, "AlertViewBlockKey", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.delegate = self;
    [self show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AlertViewBlock block = objc_getAssociatedObject(self, "AlertViewBlockKey");
    objc_removeAssociatedObjects(self);
    block(alertView,buttonIndex);
    alertView = nil;
    block = nil;
}


#warning !!! 测试完就注释掉下面的代码

#ifdef DEBUG
- (void)dealloc{
    NSLog(@"%@被释放",[self class]);
}
#endif

@end
