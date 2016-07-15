//
//  ViewController.m
//  Manage_KeyBoard_AutoLayoutOrCode
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 fabius's studio. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>{

//View
    
    IBOutlet UITextField *_userNameTextField;
    
    IBOutlet UITextField *_userPwdTextField;
    
    IBOutlet UILabel *_testLenLabel;
    
    
    IBOutlet NSLayoutConstraint *_logoImageWidthLayoutConstraint;
    IBOutlet UIButton *_startButton;
    
    NSLayoutConstraint *_startButtonBottomLayoutConstraint;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 注册通知键盘
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //显示键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //隐藏键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyBoardWillShow:(NSNotification *)note{
    
    NSDictionary *userInfo = [note userInfo];
    NSValue *value = [userInfo objectForKeyedSubscript:UIKeyboardFrameEndUserInfoKey];
    //键盘高度
    CGFloat keyboardHeight = value.CGRectValue.size.height;
    //键盘显示动画时长
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //键盘显示动画方式
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:[duration floatValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        [self updateViewConstraintsForKeyboardHeight:keyboardHeight];
    }];

}

- (void)keyboardWillHide:(NSNotification *)note{
    
    NSDictionary *userInfo = [note userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [self updateViewConstraintsForKeyboardHeight:0];
    
    [UIView animateWithDuration:[duration floatValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        [self.view layoutIfNeeded];
        
    }];

    
}


- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 操作Event
- (IBAction)didStartButton:(id)sender {
    
}

#pragma mark 动态改变控件约束
- (void)updateViewConstraintsForKeyboardHeight:(CGFloat)keyboardHeight{
    if (_startButtonBottomLayoutConstraint) {
        [self.view removeConstraint:_startButtonBottomLayoutConstraint];
        _startButtonBottomLayoutConstraint = nil;
    }
    if (keyboardHeight) {
        _startButtonBottomLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_startButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:keyboardHeight + 10];
        
        [self.view addConstraint:_startButtonBottomLayoutConstraint];
        [self.view layoutIfNeeded];
    }
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//点击空白关闭键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [_userPwdTextField resignFirstResponder];
    [_userNameTextField resignFirstResponder];
    
    
}
@end
