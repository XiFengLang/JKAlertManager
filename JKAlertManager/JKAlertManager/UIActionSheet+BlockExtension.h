//
//  UIActionSheet+BlockExtension.h
//  JKAlertManager
//
//  Created by 蒋鹏 on 16/4/7.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionSheetBlock)(UIActionSheet * originalActionSheet, NSInteger buttonIndex);

@interface UIActionSheet (BlockExtension) <UIActionSheetDelegate>

/**    不用写代理方法，直接用Block回传，代码紧凑，并且不会产生循环引用    */
- (void)showActionSheetInView:(UIView *)contentView completion:(ActionSheetBlock)completion;

@end
