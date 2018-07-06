![version](https://img.shields.io/badge/Version-1.1.1-blue.svg) ![platform](https://img.shields.io/badge/platform-iOS-ligtgrey.svg)  ![ios](https://img.shields.io/badge/Requirements-iOS8%2B-green.svg)

JKAlertManager
===

JKAlertManager是基于UIAlertController封装的管理类，将UIAlertController分散的ActionBlcok集中到一个Blcok中，并且实现主动释放的Block，内存管理更安全，代码精简高效。

## CocoaPods 

```C
platform :ios, '8.0'

source 'https://github.com/CocoaPods/Specs.git'

pod 'JKAlertManager', '~> 1.2.1'
```


## 目录

* [JKAlertManager简介](#JKAlertManager)
* [JKAlertManager迭代记录](#Updation)
* [JKAlertManager用法](#JKAlertManagerUsage)
  * [UIAlertControllerStyleAlert样式](#UIAlertControllerStyleAlert)
  * [UIAlertControllerStyleAlert类型带TextField](#TextField)
  * [UIAlertControllerStyleActionSheet样式](#UIAlertControllerStyleActionSheet)
* [JKAlertManager部分代码用意介绍](#JKAlertManagerCode)
* [快速替换掉工程中所有的UIAlertView](#UIAlertView)
* [封装UIAlertView、UIActionSheet的Block分类,替换代理方法](#UIAlertViewBlock)



## <a id="JKAlertManager"></a> JKAlertManager简介

* 基于UIAlertController封装，兼容UIAlertControllerStyleAlert和UIAlertControllerStyleActionSheet
* UIAlertControllerStyleActionSheet类型兼容了iPad中的PopoverController
* 主动释放Block，内存管理更安全，有效规避Block循环引用
* 支持监听多个UITextField的文字内容变化，并通过Block回调监听结果


<img src="http://wx3.sinaimg.cn/mw690/c56eaed1gy1fetajy78s4j20af0ijdi3.jpg" width="230" height="400"><img src="http://wx4.sinaimg.cn/mw690/c56eaed1gy1fetajyiufyj20af0ijjtg.jpg" width="230" height="400"><img src="http://wx4.sinaimg.cn/mw690/c56eaed1gy1fetajyuefij20af0ijjtb.jpg" width="230" height="400">

## <a id="Updation"></a> JKAlertManager迭代记录

> * 1.0.4，增加JKAlertView类用于全局替换UIAlertView。
> * 1.1.0，JKAlertManager继承NSObject, 不再继承UIView。

## <a id="JKAlertManagerUsage"></a> JKAlertManager用法 

### <a id="UIAlertControllerStyleAlert"></a> UIAlertControllerStyleAlert样式

```Object-C
	 JKAlertManager * manager = [[JKAlertManager alloc] initWithPreferredStyle:UIAlertControllerStyleAlert title:<#title#> message:<#nil#>];
 	 [manager configueCancelTitle:<#@"取消"#> destructiveIndex:JKAlertDestructiveIndexNone otherTitles:<#array#>];
	 [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
	 	if (actionIndex != tempAlertManager.cancelIndex) {
 			<#doSomething#>
 		}
	 }];
```

### <a id="TextField"></a> UIAlertControllerStyleAlert类型带TextField

```Object-C
	JKAlertManager * manager = [[JKAlertManager alloc]initWithPreferredStyle:UIAlertControllerStyleAlert title:self.dataArray[indexPath.row] message:self.dataArray[indexPath.row] ];
	[manager configueCancelTitle:@"取消" destructiveIndex:1 otherTitles:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
	[manager addTextFieldWithPlaceholder:@"请输入账号" secureTextEntry:NO ConfigurationHandler:nil textFieldTextChanged:^(UITextField *textField) {
         NSLog(@"1   %@",textField.text);
	}];
	[manager addTextFieldWithPlaceholder:@"请输入密码" secureTextEntry:YES ConfigurationHandler:^(UITextField *textField) {
        textField.clearsOnBeginEditing = YES;
	} textFieldTextChanged:^(UITextField *textField) {
        NSLog(@"2   %@",textField.text);
	}];
    [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
         UITextField * userNameTextField = tempAlertManager.textFields[0];
         UITextField * passwordTextField = tempAlertManager.textFields[1];
    }];

```

### <a id="UIAlertControllerStyleActionSheet"></a> UIAlertControllerStyleActionSheet样式

如果App支持iPad，需调用`configuePopoverControllerForActionSheetStyleWithSourceView：`适配iPad。

```Object-C
	JKAlertManager * manager = [[JKAlertManager alloc]initWithPreferredStyle:UIAlertControllerStyleActionSheet title:@"title" message:@"massage" ];
	[manager configueCancelTitle:nil destructiveIndex:0 otherTitles:@"Destructive按钮",@"其他按钮1",@"其他按钮2", nil];
	[manager configuePopoverControllerForActionSheetStyleWithSourceView:cell sourceRect:cell.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
	[manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
       self...
	}];

```

## <a id="JKAlertManagerCode"></a> JKAlertManager部分代码用意介绍


* 之前封装的难点主要在于拆分`(NSString *)otherTitle, ...NS_REQUIRES_NIL_TERMINATION`，将otherTitle转换成数组，用法见Demo或者[NS_REQUIRES_NIL_TERMINATION](http://www.jianshu.com/p/f61ff5e72b72)。但后来发现并没啥优越性，可以直接传NSArray。
解除Block循环引用的思路参考了 `AFNetworking`，即调用了Block后，再将Block = nil置空，即可解除循环引用，这种思路只适合调用一次的Block，多次调用的Block还是需要进行self强弱转换。


* `1.1.0`版中，JKAlertManager 改成继承 NSObject,被内部`__JKAlertManagerPrivateHolder`类私有View强引用，JKAlertManager则会弱引用这个私有View。详情请看下面的代码:

```Object-C
@interface __JKAlertManagerPrivateHolder : UIView
@property (nonatomic, strong) JKAlertManager * alertManager;
@end
@implementation __JKAlertManagerPrivateHolder
@end


@interface JKAlertManager ()
@property (nonatomic, weak) __JKAlertManagerPrivateHolder * privateHolder;
@end

```

私有View `privateHolder `在`showAlertFromController:(UIViewController *)ViewController`方法中添加到控制器ViewController.view上，间接实现控制器对JKAlertManager的强引用。`privateHolder`调用`removeFromSuperView`来解除强引用，破坏原来的引用链，从而实现自释放。

```Object-C
- (void)showAlertFromController:(UIViewController *)controller actionBlock:(JKAlertActionBlock)actionBlock{

    if (self.privateHolder) {
        [self.privateHolder removeFromSuperview];
        self.privateHolder = nil;
    }
    
    
    /// 私有类，强引用JKAlertManager
    __JKAlertManagerPrivateHolder * privateHolder = [[__JKAlertManagerPrivateHolder alloc] initWithFrame:CGRectZero];
    privateHolder.backgroundColor = [UIColor clearColor];
    privateHolder.alertManager = self;
    self.privateHolder = privateHolder;
    [controller.view addSubview:privateHolder];
    
    
    [controller presentViewController:self.alertController animated:YES completion:nil];
    
    // 解除Block循环引用，释放内存
    __weak typeof(self) weakSelf = self;
    self.privateBlock = ^(NSInteger actionIndex, NSString * actionTitle){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (actionBlock) actionBlock(strongSelf, actionIndex, actionTitle);
        
        [[NSNotificationCenter defaultCenter]removeObserver:strongSelf];
        strongSelf.alertController = nil;
        strongSelf.otherTitles = nil;
        
        /// 主动释放Block，解除循环引用
        [strongSelf.privateHolder removeFromSuperview];
        strongSelf.textFieldChangedBlockMutDict = nil;
        strongSelf.privateBlock = nil;
    };
}

```


## <a id="UIAlertView"></a> 快速替换掉工程中所有的UIAlertView，换用UIAlertController

如果项目中用到的UIAlertView相当多，同时又想全部换成UIAlertController，可用JKAlertView全局替换UIAlertView，大部分的UIAlertView都能替换，同时不用改原来的逻辑代码和代理方法。现在UIAlertView使用过程中并无异常，所以替不替换都无所谓。**如果不需要全局替换UIAlertView,JKAlertView可删除掉**，详情请查看工程中`ReplaceViewController.m`文件中的代码。

1. `#import "JKAlertView.h"`

2. 同时按`Command + Option + Shift + F`组合键`，用JKAlertView全局替换UIAlertView



## <a id="UIAlertViewBlock"></a>基于Runtime+Block封装的UIAlertView和UIActionSheet分类

> * 一个UIAlertView或UIActionSheet对象对应一个Block，代码紧凑。
> * 实现Block主动释放，规避Block循环引用，不会出现内存泄露。

如果控制器使用到多个`UIAlertView或者UIActionSheet`，那么需要在多个地方创建对象并设置`delegate和tag`，然后集中在一个代理方法中先根据tag区分对象，再区分`buttonIndex`，这样写的代码比较分散，可读性不强。封装后的`UIAlertView或者UIActionSheet`使用代码可读性更强，代码更紧凑。

不建议使用strong修饰alertView或者actionSheet属性，如果非得用属性，建议使用weak。
```Object-C
@property (nonatomic, strong)UIAlertView * alertView;
@property (nonatomic, strong)UIActionSheet * actionSheet;
```

```Objct-C
    self.alertView = [[UIAlertView alloc]initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"其他", nil];
    [self.alertView showAlertViewWithActionBlock:^(UIAlertView *newAlertView, NSInteger buttonIndex) {
        self...
    }];
    
    
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:@"title" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"destructiveButtonTitle" otherButtonTitles:@"otherButtonTitles", nil];
    [self.actionSheet showActionSheetInView:self.view completion:^(UIActionSheet *originalActionSheet, NSInteger buttonIndex) {
        self...
    }];
```

