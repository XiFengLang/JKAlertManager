//
//  JKAlertView.h
//  JKAlertManager
//
//  Created by 蒋鹏 on 16/8/18.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@class JKAlertView;
@protocol JKAlertViewDelegate <NSObject>
@optional
-(void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end



/**    JKAlertView可用于全局替换UIAlertView，如果不需要全局替换UIAlertView，可删除本类文件    */
@interface JKAlertView : UIView
- (instancetype)init                                NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder   NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame         NS_UNAVAILABLE;
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak)id delegate;
@property(nonatomic,readonly) NSInteger cancelButtonIndex;      // if the delegate does not implement -alertViewCancel:, we pretend this button was clicked on. default is -1

@property(nonatomic,readonly) NSInteger firstOtherButtonIndex;	// -1 if no otherButtonTitles or initWithTitle:... not used

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
NS_ASSUME_NONNULL_END
@end
