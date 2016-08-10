# JKAlertManager--高度封装UIAlertController的管理类
------
使用UIAlertController时，每个AlertAction对应一个Block，经常写重复代码,JKAlertManager将UIAlertController分散的ActionBlcok集中到一个Blcok中，精简代码，多个AlertAction时效果会非常明显。
> * 兼容UIAlertControllerStyleAlert和UIAlertControllerStyleActionSheet
> * UIAlertControllerStyleActionSheet类型可兼容iPad中的PopoverController
> * 避免内存泄露，有效规避Block循环引用
> * UIAlertControllerStyleAlert类型支持UITextField的使用
------
如果仍使用IAlertView和UIActionSheet，可以用Demo中附带的的UIAlertView和UIActionSheet分类来精简代码[^code]。
------
## JKAlertManager用法 ##
```Objct-C
** UIAlertControllerStyleAlert 普通多按钮**

    JKAlertManager * manager = [JKAlertManager alertWithPreferredStyle:UIAlertControllerStyleAlert title:@"title" message:@"messgae"];
    [manager configueCancelTitle:@"取消" destructiveIndex:1 otherTitles:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
    [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
    }];

** UIAlertControllerStyleAlert 带TextField**

    JKAlertManager * manager = [JKAlertManager alertWithPreferredStyle:UIAlertControllerStyleAlert title:@"title" message:@"message" ];
    [manager configueCancelTitle:@"取消" destructiveIndex:1 otherTitles:@"其他按钮1",@"Destructive按钮",@"其他按钮2", nil];
    [manager addTextFieldWithConfigurationHandler:^(UITextField *textField) {
          textField.placeholder = @"请输入账号";
      }];
    [manager addTextFieldWithConfigurationHandler:^(UITextField *textField) {
          textField.placeholder = @"请输入密码";
          textField.secureTextEntry = YES;
       }];
    [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
    }];

** UIAlertControllerStyleActionSheet 可兼容iPad**

    JKAlertManager * manager = [JKAlertManager alertWithPreferredStyle:UIAlertControllerStyleActionSheet title:self.dataArray[indexPath.row] message:messgae ];
    [manager configueCancelTitle:nil destructiveIndex:2 otherTitles:@"其他按钮1",@"其他按钮2",@"DestructiveTitle", nil];
    [manager configuePopoverControllerForActionSheetStyleWithSourceView:cell sourceRect:cell.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
    [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
    }];

```

此次封装的难点主要在于拆分(NSString *)otherTitle, ...NS_REQUIRES_NIL_TERMINATION，将otherTitle转换成数组，关于NS_REQUIRES_NIL_TERMINATION的用法可自行搜索或者参考Demo代码。

解除Block循环引用的思路参考了AFNetworking，即调用了Block后，再将Block = nil置空，即可解除循环引用，这种思路只适合调用一次的Block，多次调用的Block则需要进行self强弱转换。
JKAlertManager继承自UIView，宽高各1“像素”，透明色，被父视图superView强引用，需要释放时在内部调用[self performSelector:@selector(removeFromSuperview)]即可起到引用计数-1的效果，不需要在外部控制JKAlertManager的释放。
```Objct-C
    __weak typeof(self) weakSelf = self;
    self.privateBlock = ^(NSInteger actionIndex, NSString * actionTitle){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        actionBlock(strongSelf, actionIndex, actionTitle);
        strongSelf.privateBlock = nil;
        
        [strongSelf performSelector:@selector(removeFromSuperview)];
    };
```

------
[^code]: 如果控制器使用到多个IAlertView或者UIActionSheet，那么需要在多个地方创建对象并设置delegate和tag，然后集中在一个代理方法中先根据tag区分对象，再区分buttonIndex，这样写的代码比较分散，可视性不强。

## 基于Runtime+Block封装的IAlertView和UIActionSheet分类
> * 一个IAlertView或UIActionSheet对象对应一个Block，代码紧凑。
> * 不会出现内存泄露，规避Block循环引用

```Objct-C
    self.alertView = [[UIAlertView alloc]initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"其他", nil];
    [self.alertView showAlertViewWithActionBlock:^(UIAlertView *tempAlertView, NSInteger buttonIndex) {
        self...
    }];
    
    
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:@"title" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"destructiveButtonTitle" otherButtonTitles:@"otherButtonTitles", nil];
    [self.actionSheet showActionSheetInView:self.view completion:^(UIActionSheet *originalActionSheet, NSInteger buttonIndex) {
        self...
    }];
```

