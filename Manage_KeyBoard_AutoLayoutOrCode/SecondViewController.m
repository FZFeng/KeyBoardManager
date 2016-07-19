//
//  SecondViewController.m
//  Manage_KeyBoard_AutoLayoutOrCode
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 fabius's studio. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<UITextFieldDelegate>{

    UITextField *_txtObject;

}

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 自定义界面
- (void)setupUI{
    
    _txtObject=[[UITextField alloc] initWithFrame:CGRectMake(15,450,CGRectGetWidth(self.view.frame)-30, 35)];
    _txtObject.text=@"test";
    _txtObject.textColor=[UIColor whiteColor];
    _txtObject.backgroundColor=[UIColor redColor];
    _txtObject.font=[UIFont systemFontOfSize:16];
    _txtObject.secureTextEntry=NO;
    _txtObject.placeholder=@"";
    _txtObject.clearButtonMode=UITextFieldViewModeWhileEditing;
    _txtObject.delegate=self;
    [self.view addSubview:_txtObject];

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
        
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        
        CGRect rect=CGRectMake(0.0f,-keyboardHeight,width,height);
        self.view.frame=rect;
        
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)note{
    
    NSDictionary *userInfo = [note userInfo];
    //键盘显示动画时长
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //键盘显示动画方式
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:[duration floatValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        
        CGRect rect=CGRectMake(0.0f,0.0f,width,height);
        self.view.frame=rect;
        
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    //关闭键盘
    [self closeAllKeyBoard];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)didCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//点击空白关闭键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self closeAllKeyBoard];
}

- (void)closeAllKeyBoard{
    [_txtObject resignFirstResponder];
}
@end
