//
//  UIAlertView+BlockExtension.h
//  JKAlertManager
//
//  Created by 蒋鹏 on 16/3/2.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewBlock)(UIAlertView * newAlertView,NSInteger buttonIndex);


@interface UIAlertView (BlockExtension) <UIAlertViewDelegate>

/**    不用写代理方法，直接用Block回传，代码紧凑，并且不会产生循环引用    */
- (void)showAlertViewWithActionBlock:(AlertViewBlock)block;

@end
