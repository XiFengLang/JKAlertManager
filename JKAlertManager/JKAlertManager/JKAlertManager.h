//
//  JKAlertManager.h
//  JKAlertManager
//
//  Created by 蒋鹏 on 16/8/10.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN const NSInteger JKAlertDestructiveIndexNone;/**<  默认-2,没有destructiveTitle时设置  */


@class JKAlertManager;
typedef void(^JKAlertActionBlock)(JKAlertManager * tempAlertManager, NSInteger actionIndex, NSString * actionTitle);
typedef void(^JKAlertTextFieldTextChangedBlock)(UITextField * textField);


/**
 JKAlertManager继承UIView,会被superView请引用,removeFromSuperview后即可实现自动释放
 */
NS_CLASS_AVAILABLE_IOS(8_0) @interface JKAlertManager : UIView



/**    *********************不要使用init方法初始化,而是用类方法初始化*********************    */
- (instancetype)init ;                              //NS_DESIGNATED_INITIALIZER
- (instancetype)initWithCoder:(NSCoder *)aDecoder   NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame         NS_UNAVAILABLE;




@property (nonatomic, copy) NSString * title NS_AVAILABLE_IOS(8_0);

@property (nonatomic, copy) NSString * message NS_AVAILABLE_IOS(8_0);

/**    默认-1    */
@property (nonatomic, assign, readonly)NSInteger cancelIndex NS_AVAILABLE_IOS(8_0);
/**    默认-2    */
@property (nonatomic, assign, readonly)NSInteger destructiveIndex NS_AVAILABLE_IOS(8_0);


/**
 *  初始化方法JKAlertManager实例对象
 *
 *  @param style   UIAlertControllerStyle
 *  @param title   标题
 *  @param message 提示内容
 *
 *  @return JKAlertManager
 */
+ (instancetype)alertWithPreferredStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message NS_AVAILABLE_IOS(8_0);



/**
 *  设置CancelButtonTitle/DestructiveTitle/otherTitle,没有DestructiveTitle时设置destructiveIndex = JKAlertDestructiveIndexNone（或-2）,destructiveIndex对应DestructiveTitle在otherTitles中的index。
 *
 *  @param cancelTitle      CancelButtonTitle
 *  @param destructiveIndex destructiveIndex对应DestructiveTitle在otherTitles中的index
 *  @param otherTitle       otherTitles
 */
- (void)configueCancelTitle:(NSString *)cancelTitle destructiveIndex:(NSInteger)destructiveIndex otherTitles:(NSString *)otherTitle,...NS_REQUIRES_NIL_TERMINATION NS_AVAILABLE_IOS(8_0);


/**    1.兼容iPad时需调用,APP只供iPhone可忽略  2.必须使用UIAlertControllerStyleActionSheet    */
- (void)configuePopoverControllerForActionSheetStyleWithSourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect popoverArrowDirection:(UIPopoverArrowDirection)popoverArrowDirection NS_AVAILABLE_IOS(8_0);


/**
 *  需要用到textField时调用,2个Block ConfigurationHandler/textFieldTextChanged都可为nil
 *
 *  @param placeholder          占位字符
 *  @param secureTextEntry      是否使用密文输入
 *  @param configurationHandler TextField配置Block，可nil
 *  @param textFieldTextChanged TextField内容变化的Block，可nil
 */
- (void)addTextFieldWithPlaceholder:(NSString *)placeholder secureTextEntry:(BOOL)secureTextEntry ConfigurationHandler:(void (^)(UITextField *textField))configurationHandler textFieldTextChanged:(JKAlertTextFieldTextChangedBlock)textFieldTextChanged NS_AVAILABLE_IOS(8_0);


/**  不用担心self和JKAlertManager产生循环引用，方法内部会解除Block循环引用
 *
 *
 *  @param controller  用来跳转的控制器
 *  @param actionBlock
 */
- (void)showAlertFromController:(UIViewController *)controller actionBlock:(JKAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0);

@end
