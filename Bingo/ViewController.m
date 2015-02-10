//
//  ViewController.m
//  Bingo
//
//  Created by Eric on 2015/2/9.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>  // button border
@interface ViewController ()
{
    NSMutableArray *g_MAarray;
}

@end

@implementation ViewController


@synthesize g_minNumberTextField = g_minNumberTextField;
@synthesize g_maxNumberTextField = g_maxNumberTextField;

// 轉成Int型別
int g_iMinNumber = 0;
int g_iMaxNumber = 0;




// 點擊亂數button
- (IBAction)clickRandomButtom:(UIButton *)sender {
    if([self checkInputNumber]) {
        NSLog(@"===OK===");
        [self getRandomArray:9];
    }else{
        NSLog(@"===Error===");
    }
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_MAarray = [[NSMutableArray alloc]init];
    
    
    //NSString *s_minRandom = g_minNumberTextField.text;
    //int i_MinRandom = [intString s_minRandom];
    
    
//    NSMutableArray *buttonArray = [NSMutableArray array];
//    
//    for (int i = 0; i < 5; i++){
//        UIButton *button = [[UIButton Alloc] init];
//        [buttonArray addObject: button];
//    }
    
    for(int i=1; i<=9; i++) {
        NSString *ii = [[NSString alloc] initWithFormat:@"%d",i];
        [self addNumberBoutton:ii];
    }
    
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self
            action:@selector(showMessage:)
  forControlEvents:UIControlEventTouchDown];
     [btn setTitle:@"Click Me" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 60);
    btn.center = self.view.center;
    [self.view addSubview:btn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//產生button
- (void)addNumberBoutton:(NSString *) number {
    UIButton *numberButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];//生成一個圓角距形 Button
    [numberButton setFrame:CGRectMake(30, 160, 60, 60)];//設定位置大小，大約是中偏上
    [numberButton setTitle:number forState:UIControlStateNormal]; //設定為顯示 Click，一般狀態顯示
    [numberButton setBackgroundColor:[UIColor whiteColor]];// 設定背景色
    numberButton.layer.borderColor = [[UIColor blackColor] CGColor];// border顏色
    numberButton.layer.borderWidth = 1;// border寬度
    
    [self.view addSubview:numberButton]; // 加到 self.view 中
}



- (void)getRandomArray:(int) count{

    int m_iRandom = 0;
    Boolean m_bRepeat = false;
    while(g_MAarray.count <= count) {
        // 取得 g_iMinNumber 到 g_iMaxNumber 之間的亂數
        m_iRandom = (arc4random() % g_iMaxNumber) + g_iMinNumber;
        m_bRepeat = false;
        if(0 == g_MAarray.count) {
            [g_MAarray objectAtIndex:@(m_iRandom)];
        }
        // 檢查重複
        for (int i=0; i<g_MAarray.count; i++) {
            
            if (m_bRepeat == false ) {
                [g_MAarray addObject: @(m_iRandom)];
            }
            
            if (m_iRandom == [[g_MAarray objectAtIndex:i]intValue]) {
                m_bRepeat = true;
            }else if (m_bRepeat == true){
                break;
            }
            

        }

    }
    
    // 存入陣列
    //[g_MAarray addObject: @(m_iRandom)];
    
    NSLog(@"陣列個數：%d  陣列內容：", g_MAarray.count);


}


// popupAlertView
- (void)showMessage:(NSString *)title :(NSString *)message {
    UIAlertView *m_Message = [[UIAlertView alloc]
                            initWithTitle:title
                              message:message
                             delegate:nil
                        cancelButtonTitle:@"Button"
                        otherButtonTitles:nil];
    [m_Message show];
    
    [self viewDidLoad];
}
// 判斷是否為整數
+ (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
// 檢查輸入的數字
- (BOOL)checkInputNumber {
    
    if ([[self class] isPureInt:g_minNumberTextField.text]) {
        NSLog(@"g_iMinNumber:%@", g_minNumberTextField.text);
        g_iMinNumber = [g_minNumberTextField.text intValue];
    }else{
        [self showMessage:@"Warning" :@"最小值只能輸入正整數"];
        return false;
    }
    
    if ([[self class] isPureInt:g_maxNumberTextField.text]) {
        NSLog(@"g_iMaxNumber:%@", g_maxNumberTextField.text);
        g_iMaxNumber = [g_maxNumberTextField.text intValue];
    }else{
        [self showMessage:@"Warning" :@"最大值只能輸入正整數"];
        return false;
    }
    
    if (g_iMinNumber > g_iMaxNumber ||
        8 > (g_iMaxNumber - g_iMinNumber)) {
        NSLog(@"err: g_iMinNumber >= g_iMaxNumber");
        [self showMessage:@"Warning" :@"Max值必須大於Min值,且相差9以上"];
        return false;
    }
    
    if (0 > g_iMinNumber || 7 > g_iMaxNumber) {
        [self showMessage:@"Warning" :@"輸入的數字必須是正整數"];
        return false;
    }
    
    return true;
}

@end



