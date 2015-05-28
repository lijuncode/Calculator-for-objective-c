//
//  ViewController.m
//  计算器
//
//  Created by  李俊 on 15/5/23.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

#import "ViewController.h"
typedef enum {
    non, // 没有按运算符
    multiplication, // 乘法
    division, // 除法
    addition, // 加法
    subtra // 减法
} calculateMode;

typedef enum{
    numbleButton, // 数字按键（包括点号）
    calculateButton, //运算符
    equalButton // 等于号
}buttonMode;

@interface ViewController ()

@property (nonatomic , copy) NSString *num1; // 接收第一个数字
@property (nonatomic , copy) NSString *num2; // 接收第二个数字
@property (nonatomic , strong ) UILabel *numbleLable; //显示
@property (nonatomic, copy) NSMutableString *numString; // 接受按键输入的数字

//@property (nonatomic) int index; // 标记运算符类型

@property (nonatomic)  double result; // 接受运算结果

//@property (nonatomic) int index1; // 标记按钮类型（0为数字，1为运算符，2为等于号）

@property (nonatomic) calculateMode calculateMode; // 标记运算符类型
@property (nonatomic) buttonMode buttonMode;  // 标记按钮类型

@end

@implementation ViewController

- (NSMutableString *)numString{
    if (!_numString) {
        _numString = [NSMutableString stringWithString:@"0"];
    }
    
    return _numString;
}

- (void)numbleView:(UIButton *)but
{
   // 判断按键是数字还是点还是等号
    if (but.tag < 10) {
        // 按键是数字
#pragma mark - 接受输入的数字
        // 为了避免当numstring为@“0”时，出现“09”的情况
        if ([self.numString isEqual:@"0"]) {
            NSRange range = [self.numString rangeOfString:@"0"];
            [self.numString replaceCharactersInRange:range withString:[but currentTitle]];

        }else{
        
            [self.numString appendString:[but currentTitle]];
        
        }
        self.numbleLable.text = self.numString;
        
        self.buttonMode = numbleButton;
        
    }else if(but.tag == 10){
        
        // 按键是点号
        // 判断是否已经有“.”了，如果有，则点击无效。
        NSRange range = [self.numString rangeOfString:@"."];
        
        if (range.location == NSNotFound) {
           
            [self.numString appendFormat:@"."];
            
        }else{
            return;
        }
       
       self.numbleLable.text = self.numString;
    }else{
        
        // 按键是等号
        // 判断前一个按键是啥
        if (self.buttonMode == equalButton) {
            
            // 前一个按键是等号，则将label里显示的数字赋值给num1；
            self.num1 = self.numbleLable.text;
            
        }else if(self.buttonMode == numbleButton){
            
            // 前一个按键是数字，则将label里显示的数字赋值给num2；
            self.num2 = self.numbleLable.text;
            
        }else{
            
            // 前一个按键是运算符则返回；
            return;
        }
        
        // 进行运算
        [self calculate];
        
        // 清空numstring
        [self clearNubleString];
        
        // 运算完后，num1为空，
        self.num1 = nil;
       
        self.buttonMode = equalButton;
        
    }
    
    // 变换字体大小
    [self fontOfNumbleLabel];
   
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
#pragma mark - 设置数字按钮
    UIView *numbleView = [[UIView alloc] init];
    [numbleView setFrame:CGRectMake(0, (568-80*4), 240, 320)];
    
    [numbleView setBackgroundColor:[UIColor blueColor]];
    
    
    
    [self.view addSubview:numbleView];
    
    
    int total = 12;
    
    int tag = 0;
    // 列数
    int totalCow = 3;
    
    CGFloat buttonX;
    CGFloat buttonY;
    
    
    for (int i = 0; i < total; i++) {
        
        // 所在行数
        
        int row = i/totalCow;
        
        buttonY = row*80;
        
        // 所在列数
        
        int cow = i%totalCow;
        
        buttonX = cow*80;
        
        
        UIButton *numble = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [numble setFrame:CGRectMake(buttonX, buttonY, 80, 80)];
               
        numble.tag = tag;
        
        [numble setTitle:[NSString stringWithFormat:@"%d",9-i] forState:UIControlStateNormal];
        
        switch (numble.tag) {
            case 10:
                [numble setTitle:@"." forState:UIControlStateNormal];
                break;
                
            case 11:
                [numble setTitle:@"=" forState:UIControlStateNormal];
        }
        
        [numble addTarget:self action:@selector(numbleView:) forControlEvents:UIControlEventTouchUpInside];
        numble.titleLabel.font = [UIFont systemFontOfSize:28];
        
        
        
        tag++;
       
        [numble setBackgroundColor:[UIColor grayColor]];
        [numble setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        
        // 设置button的边框
        [numble.layer setMasksToBounds:YES];
        [numble.layer setBorderWidth:0.5];
        
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,1,1,1});
        
        [numble.layer setBorderColor:color];
        
        
        [numbleView addSubview:numble];

    }
    
#pragma mark - 设置运算符button
    
    UIView *countView = [[UIView alloc] init];
    [countView setFrame:CGRectMake(240, (568-80*4), 80, 320)];
    [countView setBackgroundColor:[UIColor orangeColor]];
    
    [self.view addSubview:countView];
    
    for (int i = 0; i < 4; i++) {
        UIButton *countButton = [[UIButton alloc] initWithFrame:CGRectMake(0, i*80, 80, 80)];
        
        countButton.tag = tag;
        
        tag++;
        
        switch (countButton.tag) {
            case 12:
                [countButton setTitle:@"/" forState:UIControlStateNormal];
                break;
                
            case 13:
                [countButton setTitle:@"*" forState:UIControlStateNormal];
                break;
            case 14:
                [countButton setTitle:@"-" forState:UIControlStateNormal];
                break;
            case 15:
                [countButton setTitle:@"+" forState:UIControlStateNormal];
                break;


        }
        [countButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        countButton.titleLabel.font = [UIFont systemFontOfSize:28];
        [countButton.layer setMasksToBounds:YES];
        [countButton.layer setBorderWidth:0.5];
        
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,1,1,1});
        
        [countButton.layer setBorderColor:color];
        
        [countView addSubview:countButton];
        
        [countButton addTarget:self action:@selector(count:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    
    
    
#pragma mark - 设置显示label
    
_numbleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 248)];
    
    [_numbleLable setBackgroundColor:[UIColor blackColor]];
        
    _numbleLable.text = @"0";
    _numbleLable.textColor = [UIColor whiteColor];
    [_numbleLable setTextAlignment:NSTextAlignmentRight];
    
    [self fontOfNumbleLabel];
    
//    if (_numbleLable.text.length < 12) {
//        
//    _numbleLable.font = [UIFont systemFontOfSize:50.0];
//    }else if (_numbleLable.text.length > 11 ){
//        _numbleLable.font = [UIFont systemFontOfSize:30.0];
//    }
    
    // 设置label的文字可显示的行数，0代表无限行数
    _numbleLable.numberOfLines = 0;
    [_numbleLable setLineBreakMode:NSLineBreakByClipping];
   // _numbleLable.adjustsFontSizeToFitWidth = YES;
    
    [self.view addSubview:_numbleLable];
    
#pragma mark - 设置删除按钮
    
    UIButton *cut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 248)];
    
    [self.view addSubview:cut];
    
    [cut addTarget:self action:@selector(cut) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 设置删除方法

- (void)cut{
    
    if (self.buttonMode != numbleButton) {
        
        // 前一个按键不是数字按键，将所有内容清空
        self.numbleLable.text = @"0";
        self.num1 = nil;
        self.num2 = nil;
        self.calculateMode = non;
        self.buttonMode = numbleButton;
        self.result =0;
        [self clearNubleString];
        
    }else{
    
        // 前一个按键是数字按键，则只需要删除最后一个字符，
        //如果只有一个字符，则将label设置为0，清空numstring；
        
        if (self.numString.length == 1 ) {
            self.numbleLable.text = @"0";
            self.numString = nil;
        }else {
            
            // 如果不止一个字符则删除最后一个字符
            NSRange range = {self.numString.length - 1,1};
            [self.numString deleteCharactersInRange:range];
            self.numbleLable.text = self.numString;
        
        }
    }
    
    
    
    // 数字有变化，要变换字体
    [self fontOfNumbleLabel];
    
    
}

#pragma mark - 设置运算符监听方法

- (void)count:(UIButton *)btn{
   
//判断是否连续按运算建，如果self.index1=1，则说明前一次按键也是运算建
    if (self.buttonMode == calculateButton) {
       
        // 前一个按键也是运算建，不做操作
        
    }else{
        
        // 前一个按键不是运算符，再判断num1是否有值
        if (!self.num1) {
            
            // 如果num1没有值，就赋值给num1；
            self.num1 = self.numbleLable.text;
        }else {
            // 如果num1有值，就赋值给num2；
            self.num2 = self.numbleLable.text;
            
            // 进行计算
            [self calculate];
            
            // 计算完后，将结果赋值给num1，以进行连续计算；
            self.num1 = self.numbleLable.text;
        }
        // 赋值完后清空接受数字的字符串
        [self clearNubleString];
    }
    
    // 修改运算建的标示数字
    switch (btn.tag) {
        case 12:
            self.calculateMode = division; // 除法
            break;
        case 13:
            self.calculateMode = multiplication; // 乘法
            break;
        case 14:
            self.calculateMode = subtra; // 减法
            break;
        case 15:
            self.calculateMode = addition; // 加法
            break;
            
    }
    // self.index1 = 1;
    self.buttonMode = calculateButton;
    
}

#pragma mark - 更改label的字体
- (void)fontOfNumbleLabel{
    if (_numbleLable.text.length < 9) {
        _numbleLable.font = [UIFont systemFontOfSize:60.0];
    }else if (_numbleLable.text.length > 8 && _numbleLable.text.length < 11 ){
        _numbleLable.font = [UIFont systemFontOfSize:50.0];
    }else if (_numbleLable.text.length > 10){
        _numbleLable.font = [UIFont systemFontOfSize:40.0];
    }
    
}

#pragma mark - 清空接受数字的数组，将label的数字赋值之后都要做一次清空；
- (void)clearNubleString{
    
    self.numString = nil;
}


#pragma mark - 运算方法
- (void)calculate{
    
    switch (self.calculateMode) {
        case division:
            _result = [self.num1 doubleValue]/[self.num2 doubleValue];
            break;
            
        case multiplication:
            _result = [self.num1 doubleValue]*[self.num2 doubleValue];
            break;
        case subtra:
            _result = [self.num1 doubleValue]-[self.num2 doubleValue];
            break;
            
        case addition:
            _result = [self.num1 doubleValue]+[self.num2 doubleValue];
            break;
        default:
            return;
            
    }
    
    if ((long)self.result == self.result) {
        self.numbleLable.text = [NSString stringWithFormat:@"%ld",(long)_result];
    }else{
        
        self.numbleLable.text = [NSString stringWithFormat:@"%.8f",_result];
        
        // 从最后一位开始判断小数点后数字的值，如果最后一位位0，则删除
        for (int i = 0; i < 9; i++) {
            // 取出最后的一个字符
            char s = [self.numbleLable.text characterAtIndex:(self.numbleLable.text.length-1)];
            // 判断最后一个字符
            if (s == '0' || s == '.') {
                NSString *string = [self.numbleLable.text substringToIndex:self.numbleLable.text.length - 1];
                self.numbleLable.text = string;
            }
            
            
        }
        
    }

   
    
}

@end
