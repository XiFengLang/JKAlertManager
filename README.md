# JKAlertManager--深度封装UIAlertController
`1.1`
------
使用 UIAlertController 时，每个AlertAction对应一个Block，会经常写重复代码。

而JKAlertManager 将 UIAlertController 分散的ActionBlcok集中到一个Blcok中，代码精简高效。


> * 兼容UIAlertControllerStyleAlert和UIAlertControllerStyleActionSheet
> * UIAlertControllerStyleActionSheet类型可兼容iPad中的PopoverController
> * 不会有内存泄露，有效规避Block循环引用
> * 支持多个UITextField，在Block中监听UITextField的文字变化。

------

* 1.0.4版本中增加JKAlertView类用于全局替换UIAlertView，若无此需求可将JKAlertView类删除掉。
* 1.1版本 JKAlertManager 继承NSObject, 封装更完整。

 ![image](http://wx4.sinaimg.cn/mw690/c56eaed1gy1fetajxry5mg20aj0j77wh.gif)
------

如果仍使用`IAlertView和UIActionSheet`，可以用Demo中的的UIAlertView和UIActionSheet分类来精简代码,详情见后面的介绍。

------
## JKAlertManager用法 ##
```Objct-C

** UIAlertControllerStyleAlert 普通多按钮**


            JKAlertManager * manager = [[JKAlertManager alloc]initWithPreferredStyle:UIAlertControllerStyleAlert title:@"title" message:@"messgae"];
            [manager configueCancelTitle:@"取消" destructiveIndex:1 otherTitles:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
                self...
            }];



** UIAlertControllerStyleAlert 带TextField**


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



** UIAlertControllerStyleActionSheet 可兼容iPad**


            JKAlertManager * manager = [[JKAlertManager alloc]initWithPreferredStyle:UIAlertControllerStyleActionSheet title:@"title" message:@"massage" ];
            [manager configueCancelTitle:nil destructiveIndex:0 otherTitles:@"Destructive按钮",@"其他按钮1",@"其他按钮2", nil];
            [manager configuePopoverControllerForActionSheetStyleWithSourceView:cell sourceRect:cell.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
            [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
                self...
            }];

```

之前封装的难点主要在于拆分`(NSString *)otherTitle, ...NS_REQUIRES_NIL_TERMINATION`，将otherTitle转换成数组，用法见Demo或者[NS_REQUIRES_NIL_TERMINATION](http://www.jianshu.com/p/f61ff5e72b72)。但后来发现并没啥优越性，也可以直接传NSArray。
解除Block循环引用的思路参考了 `AFNetworking`，即调用了Block后，再将Block = nil置空，即可解除循环引用，这种思路只适合调用一次的Block，多次调用的Block还是需要进行self强弱转换。

`1.0.4`版中~~`JKAlertManager`继承自`UIView`，宽高各1“像素”，透明色，被父视图superView强引用，需要释放时在内部调用`[self performSelector:@selector(removeFromSuperview)]`即可起到引用计数-1的效果，不需要在外部控制JKAlrtManager的释放。~~

`1.1`版中，JKAlertManager 继承 NSObject,被内部继承`__JKAlertManagerPrivateHolder`类的私有View强引用，JKAlertManager则会弱引用这个私有View。私有View在`showAlertFromController:(UIViewController *)ViewController`方法中添加到控制器ViewController.view上，间接实现控制器对JKAlertManager的强引用，但也可以通过私有View调用`removeFromSuperView`来解除强引用，从而实现自释放。
```Object-C
@interface __JKAlertManagerPrivateHolder : UIView
@property (nonatomic, strong) JKAlertManager * alertManager;
@end
@implementation __JKAlertManagerPrivateHolder
@end


@interface JKAlertManager ()
@property (nonatomic, weak) __JKAlertManagerPrivateHolder * privateHolder;
@end



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
        strongSelf.privateBlock = nil;
        strongSelf.textFieldChangedBlockMutDict = nil;
        strongSelf.otherTitles = nil;
        [strongSelf.privateHolder removeFromSuperview];
    };
}
```
<img src="http://wx3.sinaimg.cn/mw690/c56eaed1gy1fetajy78s4j20af0ijdi3.jpg" width="230" height="400"><img src="http://wx4.sinaimg.cn/mw690/c56eaed1gy1fetajyiufyj20af0ijjtg.jpg" width="230" height="400"><img src="http://wx4.sinaimg.cn/mw690/c56eaed1gy1fetajyuefij20af0ijjtb.jpg" width="230" height="400">

------


## 基于Runtime+Block封装的UIAlertView和UIActionSheet分类
> * 一个IAlertView或UIActionSheet对象对应一个Block，代码紧凑。
> * 不会出现内存泄露，规避Block循环引用

如果控制器使用到多个`IAlertView或者UIActionSheet`，那么需要在多个地方创建对象并设置`delegate和tag`，然后集中在一个代理方法中先根据tag区分对象，再区分`buttonIndex`，这样写的代码比较分散，可视性不强。

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

## 全局替换UIAlertView ##
如果项目中用到的UIAlertView相当多，同时又想全部换成UIAlertController，可全局替换UIAlertView和JKAlertView，大部分的UIAlertView都能替换，同时不用改原来的逻辑代码和代理方法。但是现在UIAlertView使用过程中并无异常，所以替不替换都无所谓。
** 如果不需要全局替换UIAlertView,JKAlertView可删除掉 **

