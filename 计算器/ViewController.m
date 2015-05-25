//
//  ViewController.m
//  计算器
//
//  Created by  李俊 on 15/5/23.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic , copy) NSString *num1;
@property (nonatomic , copy) NSString *num2;
@property (nonatomic , strong ) UILabel *numbleLable;
@property (nonatomic, copy)NSMutableString *numString;

@property (nonatomic) int index;

@property (nonatomic) float result;

@end

@implementation ViewController

- (NSMutableString *)numString{
    if (!_numString) {
        _numString = [NSMutableString string];
    }
    
    return _numString;
}

//- (NSMutableArray *)numbleMutableArray{
//    if (!_numbleMutableArray) {
//        _numbleMutableArray = [NSMutableArray arrayWithObject:nil];
//        
//    }
//    return _numbleMutableArray;
//}


- (NSString *)num1{
    if (!_num1) {
        
        _num1 = _numbleLable.text;
    }
    
    return _num1;
}

- (void)numbleView:(UIButton *)but
{
   
    
    if (but.tag < 10) {
        
#pragma mark - 接受输入的数字
        
        [self.numString appendString:[but currentTitle]];
        
        
        
    }else if (but.tag == 10){
        
        [self.numString appendFormat:@"."];
        
    }
    
    self.numbleLable.text = self.numString;
    
    if (but.tag == 11) {
        self.num2 = self.numbleLable.text;
        
        
        switch (_index) {
            case 1:
                _result = [self.num1 doubleValue]/[self.num2 doubleValue];
                break;
                
            case 2:
                _result = [self.num1 doubleValue]*[self.num2 doubleValue];
                break;
            case 3:
                _result = [self.num1 doubleValue]-[self.num2 doubleValue];
                break;

            case 4:
                _result = [self.num1 doubleValue]+[self.num2 doubleValue];
                break;

        }
        
        if ((int)self.result == self.result) {
            self.numbleLable.text = [NSString stringWithFormat:@"%d",(int)_result];
        }else{
        
         self.numbleLable.text = [NSString stringWithFormat:@"%.2f",_result];
        }
        
        self.numString = nil;
        
        _index = 5;

        
    }
    
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
        
        /*
         typedef NS_ENUM(NSInteger, UIButtonType) {
         UIButtonTypeCustom = 0,                         // no button type
         UIButtonTypeSystem NS_ENUM_AVAILABLE_IOS(7_0),  // standard system button
         
         UIButtonTypeDetailDisclosure,
         UIButtonTypeInfoLight,
         UIButtonTypeInfoDark,
         UIButtonTypeContactAdd,
         
         UIButtonTypeRoundedRect = UIButtonTypeSystem,   // Deprecated, use UIButtonTypeSystem instead
         };

         
         
         */
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
        
        
        tag++;
       
        [numble setBackgroundColor:[UIColor grayColor]];
        
        [numbleView addSubview:numble];

    }
    
#pragma mark - 设置运算符button
    
    UIView *countView = [[UIView alloc] init];
    [countView setFrame:CGRectMake(240, (568-80*4), 80, 320)];
    [countView setBackgroundColor:[UIColor redColor]];
    
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
        
        [countView addSubview:countButton];
        
        [countButton addTarget:self action:@selector(count:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    
    
    
#pragma mark - 设置显示label
    
_numbleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 248)];
    
    [_numbleLable setBackgroundColor:[UIColor blackColor]];
    
    
    _numbleLable.text = @"0";
    _numbleLable.textColor = [UIColor whiteColor];
    [_numbleLable setTextAlignment:NSTextAlignmentRight];
    
   
    
    
    [self.view addSubview:_numbleLable];
    
#pragma mark - 设置删除按钮
    
    UIButton *cut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 248)];
    
    [self.view addSubview:cut];
    
    [cut addTarget:self action:@selector(cut) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

#pragma mark - 设置删除方法

- (void)cut{
    
    if (_index) {
        self.numbleLable.text = @"0";
        self.num1 = nil;
        self.num2 = nil;
        _index = 0;
        self.result =0;
    }
    if(!_index){
    
    NSRange range = {self.numString.length - 1,1};
    
     if (self.numString.length == 1 ) {
        self.numbleLable.text = @"0";
        self.numString = nil;
    }else if (self.numString.length > 1){
    [self.numString deleteCharactersInRange:range];
            self.numbleLable.text = self.numString;
        
   
    }
    }
    
    
    
}

#pragma mark - 设置运算符监听方法

- (void)count:(UIButton *)btn{
    
    self.num1 = self.numbleLable.text;
    
    self.numString = nil;
    
    switch (btn.tag) {
        case 12:
            _index = 1;
            break;
        case 13:
            _index = 2;
            break;
        case 14:
            _index = 3;
            break;
        case 15:
            _index = 4;
            break;
        
    }
    
    
}


@end
