//
//  QSCLoginImageVerifyView.m
//  qingsongchou
//
//  Created by zhangzhenwei on 16/10/25.
//  Copyright © 2016年 Chai. All rights reserved.
//

#import "QSCLoginImageVerifyView.h"
#import "CYRandomCodeView.h"
#import <CoreText/CoreText.h>


#define ImageVerifyCodeCount 4

@interface QSCLoginImageVerifyView()<UITextFieldDelegate>
@property (nonatomic,strong) CYRandomCodeView* verifyCodeView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *charArr;
@property (nonatomic,strong)  NSString* verifyCodeString;
@property (nonatomic,strong)  UITextField *passwordText;
@property (nonatomic,strong) UIView *imageVerifyView;

@property (nonatomic,strong) NSString *imageVerifyString;
@end

@implementation QSCLoginImageVerifyView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI{
    UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    backGroundView.backgroundColor = [UIColor lightGrayColor];
    backGroundView.alpha = 0.8;
    [self addSubview:backGroundView];
    
    UIView *imageVerifyView = [[UIView alloc]init];
    self.imageVerifyView = imageVerifyView;
    imageVerifyView.backgroundColor = [UIColor whiteColor];
    imageVerifyView.size = CGSizeMake(275, 225);
    imageVerifyView.center = self.center;
    [backGroundView addSubview:imageVerifyView];
    imageVerifyView.layer.cornerRadius = 5.0;
    [imageVerifyView.layer masksToBounds];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 25, 115, 16)];
    titleLabel.text = @"输入图片验证码";
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    [imageVerifyView addSubview:titleLabel];
    
    UIImageView *closeImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageVerifyView.width -11-16, 12, 16, 16)];
    closeImage.image = [UIImage imageNamed:@"nav_Close.png"];
    closeImage.backgroundColor =[UIColor redColor];
    [imageVerifyView addSubview:closeImage];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(imageVerifyView.width-40, 0, 40, 40)];
    [imageVerifyView addSubview:closeBtn];
    closeBtn.backgroundColor = [UIColor clearColor];
    [closeBtn addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+4, imageVerifyView.width, 17)];
    errorLabel.text = @"图片验证失败";
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.font = [UIFont systemFontOfSize:12.0];
    errorLabel.textColor = [UIColor redColor];
    [imageVerifyView addSubview:errorLabel];
    
    self.verifyCodeView = [[CYRandomCodeView alloc] initWithFrame:CGRectMake(28,CGRectGetMaxY(errorLabel.frame)+4, 220, 50)];
    [imageVerifyView addSubview:self.verifyCodeView];
    self.verifyCodeView.backgroundColor = [UIColor lightGrayColor];
    [self.verifyCodeView didChangeCode:^(NSString *code) {
        self.verifyCodeString = code;
    }];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.verifyCodeView.x, CGRectGetMaxY(self.verifyCodeView.frame)+1, self.verifyCodeView.width, 21)];
    [button addTarget:self action:@selector(refreshImageCode) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"看不清？ 点击刷新" forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    button.backgroundColor = [UIColor redColor];
    [imageVerifyView addSubview:button];
    
    [self createPasswordLabels:CGSizeMake(self.verifyCodeView.width, 46) superView:imageVerifyView];
    
    [self createPasswordView:CGSizeMake(self.verifyCodeView.width, 46) superView:imageVerifyView];
    
//    //监听键盘，键盘出现
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(keyboardwill:)
//                                                name:UIKeyboardWillShowNotification object:nil];
//    
//    //监听键盘隐藏
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(keybaordhide:)
//                                                name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)createPasswordLabels:(CGSize )size superView:(UIView *)superview{
    self.dataArray = [[NSMutableArray alloc]init];
    
    UIView *passView = [[UIView alloc]initWithFrame:CGRectMake(28, 160, size.width, 46)];
    passView.backgroundColor = [UIColor whiteColor];
    [superview addSubview:passView];
    for (int i = 0; i<ImageVerifyCodeCount; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(46*i+(size.width-46*ImageVerifyCodeCount)/(ImageVerifyCodeCount-1)*i, 0, 46, 46)];
        label.tag = i+1;
        label.layer.borderWidth = 0.3;
        label.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        if (label.tag == 1) {
            label.layer.borderWidth = 1;
            label.layer.borderColor = [QSCTextColor CGColor];
        }
        [passView addSubview:label];
        [self.dataArray addObject:label];
    }
}

- (void)createPasswordView:(CGSize )size superView:(UIView *)superview{
    if (_charArr.count > 0) {
        [_charArr removeAllObjects];
        _charArr = nil;
    }
    _charArr = [[NSMutableArray alloc]init];
    UITextField *passwordText = [[UITextField alloc]initWithFrame:CGRectMake(28, 160, size.width, 46)];
    passwordText.tintColor = QSCTextColor;
    passwordText.delegate = self;
    passwordText.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordText = passwordText;
    [self.passwordText addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    passwordText.textColor = [UIColor clearColor];
    passwordText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23, 46)];
    passwordText.leftViewMode = UITextFieldViewModeAlways;
    [passwordText becomeFirstResponder];
    [superview addSubview:passwordText];
}


- (void)refreshImageCode{
    [self.verifyCodeView refreshRandomCode];
}


- (void)dismissView:(UIGestureRecognizer *)tap{
    [self removeFromSuperview];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]){ // 删除字符
        [_charArr removeLastObject];
        UILabel *label = self.dataArray[_charArr.count];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30];
        label.text = @"";
        label.layer.borderWidth = 0.3;
        label.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        
        if (!_charArr.count) {
            UILabel *label = self.dataArray[0];
            label.layer.borderWidth = 1;
            label.layer.borderColor = [QSCTextColor CGColor];
        }
    }
    else{
        if ( _charArr.count < ImageVerifyCodeCount ) {
            [_charArr addObject:string];
        }else{
            return NO;
        }
    }
    
    if (_charArr.count == ImageVerifyCodeCount) {
        if ([self.verifyCodeString isEqualToString:[textField.text stringByAppendingString:string]]) {
            if (self.successBolck) {
                self.successBolck();
            }
            
            [textField resignFirstResponder];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                textField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
                [self dismissView:nil];
            });
        }else{
            if (self.failureBlock) {
                self.failureBlock();
            }
            NSLog(@"您输入的有错误");
        }
    }
    
    for (int i = 0; i<_charArr.count; i++) {
        UILabel *label = self.dataArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30];
        label.text = _charArr[i];
        if (label.tag == _charArr.count) {
            label.layer.borderWidth = 1;
            label.layer.borderColor = [QSCTextColor CGColor];
        }else{
            label.layer.borderWidth = 0.3;
            label.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        }
    }
    
    self.imageVerifyString = textField.text;
    return YES;
}


- (void)textChanged:(UITextField *)imageVerifyString{
    long number = 48;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:imageVerifyString.text];
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
    CFRelease(num);
    
    self.passwordText.attributedText = attributedString;
}




////当键盘出现时，调用此方法
//-(void)keyboardwill:(NSNotification *)sender
//{
//    NSDictionary *dict=[sender userInfo];
//    NSValue *value=[dict objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardrect = [value CGRectValue];
//    int height=keyboardrect.size.height;
//
////    self.imageVerifyView.frame  = CGRectMake(self.imageVerifyView.x, KDeviceHeight-self.imageVerifyView.height-height, self.imageVerifyView.width, self.imageVerifyView.height);
//    
//}
//
////当键盘隐藏时候，视图回到原定
//-(void)keybaordhide:(NSNotification *)sender
//{
//    self.imageVerifyView.center = self.center;
//}

- (void)verifySuccess:(InputSuccessBlock)successBolck filure:(InputFailureBlock)failureBlock{
    self.successBolck = successBolck;
    self.failureBlock = failureBlock;
}

@end
