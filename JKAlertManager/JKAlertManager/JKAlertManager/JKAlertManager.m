//
//  JKAlertManager.m
//  JKAlertManager
//
//  Created by 蒋鹏 on 16/8/10.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//  https://github.com/XiFengLang/JKAlertManager

#import "JKAlertManager.h"

#define JK_iPad          UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad
const NSInteger JKAlertDestructiveIndexNone = -2;
typedef void(^JKAlertManagerBlock)(NSInteger actionIndex, NSString * actionTitle);


@interface JKAlertManager ()

@property (nonatomic, strong)UIAlertController * alertController;
@property (nonatomic, copy) NSString * destructiveTitle;
@property (nonatomic, copy) NSString * cancelTitle;
@property (nonatomic, strong)NSMutableArray * otherTitles;
@property (nonatomic, copy)JKAlertManagerBlock privateBlock;
@property (nonatomic, strong)NSMutableDictionary * textFieldChangedBlockMutDict;
@end

@implementation JKAlertManager

- (instancetype)init{
    if (self = [super init]) {
        _cancelIndex = -1;
        _destructiveIndex = JKAlertDestructiveIndexNone;
        self.frame = CGRectZero;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }return self;
}

+ (instancetype)alertWithPreferredStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message{
    JKAlertManager * alertManager = [[JKAlertManager alloc]init];
    alertManager.alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    return alertManager;
}

- (void)configueCancelTitle:(NSString *)cancelTitle destructiveIndex:(NSInteger)destructiveIndex otherTitle:(NSString *)otherTitle, ...NS_REQUIRES_NIL_TERMINATION{


    //VA_LIST 是在C语言中解决变参问题的一组宏
    va_list argList;
    NSMutableArray * otherTitles = [[NSMutableArray alloc]init];
    if (otherTitle) {
        [otherTitles addObject:otherTitle];
        
        // VA_START宏，获取可变参数列表的第一个参数的地址,在这里是获取firstObj的内存地址,这时argList的指针 指向firstObj
        va_start(argList, otherTitle);
        
        // 临时指针变量
        NSString * actionTitle = nil;
        
        // VA_ARG宏，获取可变参数的当前参数，返回指定类型并将指针指向下一参数
        // 首先 argList的内存地址指向的fristObj将对应储存的值取出,如果不为nil则判断为真,将取出的值房在数组中,
        // 并且将指针指向下一个参数,这样每次循环argList所代表的指针偏移量就不断下移直到取出nil
        while ((actionTitle = va_arg(argList, NSString*))) {
            [otherTitles addObject:actionTitle];
        }
    }
    [self configueCancelTitle:cancelTitle destructiveIndex:destructiveIndex otherTitles:otherTitles];
}

- (void)configueCancelTitle:(NSString *)cancelTitle destructiveIndex:(NSInteger)destructiveIndex otherTitles:(NSArray *)otherTitles{
    self.cancelTitle = cancelTitle;
    _destructiveIndex = destructiveIndex;
    [self addCancelAction];
    
    [self.otherTitles addObjectsFromArray:otherTitles];
    if(_destructiveIndex >= 0 && _destructiveIndex < self.otherTitles.count){
        self.destructiveTitle = self.otherTitles[destructiveIndex];
    }
    [self addOtherActions];
}




- (void)configuePopoverControllerForActionSheetStyleWithSourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect popoverArrowDirection:(UIPopoverArrowDirection)popoverArrowDirection{
    if (JK_iPad && self.alertController) {
        if (self.alertController.preferredStyle == UIAlertControllerStyleActionSheet) {
            UIPopoverPresentationController * popoverController = self.alertController.popoverPresentationController;
            if (popoverController) {
                popoverController.sourceView = sourceView;
                popoverController.sourceRect = sourceRect;
                popoverController.permittedArrowDirections = popoverArrowDirection;
            }
        }else{
            NSLog(@"\n\tJKAlertManager Error : 不能在UIAlertControllerStyleAlert类型中调用方法 %s\n",__FUNCTION__);
        }
    }
}

- (void)addTextFieldWithPlaceholder:(NSString *)placeholder secureTextEntry:(BOOL)secureTextEntry ConfigurationHandler:(void (^)(UITextField *))configurationHandler textFieldTextChanged:(JKAlertTextFieldTextChangedBlock)textFieldTextChanged{
    if (self.alertController) {
        __weak typeof(self) weakSelf = self;
        [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholder;
            textField.secureTextEntry = secureTextEntry;
            if (configurationHandler) configurationHandler(textField);
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (textFieldTextChanged) {
                [strongSelf.textFieldChangedBlockMutDict setObject:textFieldTextChanged forKey:[NSString stringWithFormat:@"%p",textField]];
            }
        }];
    }else{
        NSLog(@"self.alertController为空,%s",__FUNCTION__);
    }
}


- (void)textFieldTextDidChanged:(NSNotification *)notification{
    if (self.textFieldChangedBlockMutDict.count) {
        UITextField * textField = notification.object;
        JKAlertTextFieldTextChangedBlock textChanedBlock = self.textFieldChangedBlockMutDict[[NSString stringWithFormat:@"%p",textField]];
        textChanedBlock(textField);
    }
}

- (void)showAlertFromController:(UIViewController *)controller actionBlock:(JKAlertActionBlock)actionBlock{
    self.frame = CGRectZero;
    [controller.view addSubview:self];
    
    [controller presentViewController:self.alertController animated:YES completion:nil];
    
    // 解除Block循环引用，释放内存
    __weak typeof(self) weakSelf = self;
    self.privateBlock = ^(NSInteger actionIndex, NSString * actionTitle){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        actionBlock(strongSelf, actionIndex, actionTitle);
        [[NSNotificationCenter defaultCenter]removeObserver:strongSelf];
        strongSelf.alertController = nil;
        strongSelf.privateBlock = nil;
        strongSelf.textFieldChangedBlockMutDict = nil;
        strongSelf.otherTitles = nil;
        [strongSelf performSelector:@selector(removeFromSuperview)];
    };
}

- (void)addCancelAction{
    if (self.cancelTitle) {
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:self.cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.privateBlock(self.cancelIndex,self.cancelTitle);
        }];
        [self.alertController addAction:cancelAction];
    }
}

- (void)addDestructiveAction{
    if (self.destructiveTitle) {
        UIAlertAction * destructiveAction = [UIAlertAction actionWithTitle:self.destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.privateBlock(self.destructiveIndex,self.destructiveTitle);
        }];
        [self.alertController addAction:destructiveAction];
    }
}

- (void)addOtherActions{
    for (NSInteger index = 0; index < self.otherTitles.count; index ++) {
        if (_destructiveIndex == index) {
            [self addDestructiveAction];
            continue;
        }
        
        NSString * actionTitle = self.otherTitles[index];
        UIAlertAction * otherAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.privateBlock(index,actionTitle);
        }];
        [self.alertController addAction:otherAction];
    }
}


- (void)setTitle:(NSString *)title{
    self.alertController.title = title;
}

- (NSString *)title{
    return self.alertController.title;
}

- (void)setMessage:(NSString *)message{
    self.alertController.message = message;
}

- (NSString *)message{
    return self.alertController.message;
}

- (NSArray<UITextField *> *)textFields{
    return self.alertController.textFields;
}

- (NSMutableArray *)otherTitles{
    if (!_otherTitles) {
        _otherTitles = [[NSMutableArray alloc]init];
    }return _otherTitles;
}

- (NSMutableDictionary *)textFieldChangedBlockMutDict{
    if (!_textFieldChangedBlockMutDict) {
        _textFieldChangedBlockMutDict = [[NSMutableDictionary alloc]init];
    }return _textFieldChangedBlockMutDict;
}

- (void)dealloc{
    NSLog(@"JKAlertManager 已释放 ");
}


@end
