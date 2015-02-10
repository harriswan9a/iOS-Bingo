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
    // 存放Bingo數組
    NSMutableArray *g_MAarray;
}


@end

@implementation ViewController




@synthesize g_minNumberTextField = g_minNumberTextField;
@synthesize g_maxNumberTextField = g_maxNumberTextField;
@synthesize g_TextField1 = g_TextField1;
@synthesize g_TextField2 = g_TextField2;
@synthesize g_TextField3 = g_TextField3;
@synthesize g_TextField4 = g_TextField4;
@synthesize g_TextField5 = g_TextField5;
@synthesize g_TextField6 = g_TextField6;
@synthesize g_TextField7 = g_TextField7;
@synthesize g_TextField8 = g_TextField8;
@synthesize g_TextField9 = g_TextField9;


// 轉成Int型別
int g_iMinNumber = 0;
int g_iMaxNumber = 0;


// 切換模式觸發
- (IBAction)segamentedAction:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0: // 自動模式
            [self showMessage:@"text" :@"自動模式，點擊開始"];
            g_iMinNumber = 1;
            g_iMaxNumber = 9;
            [self getRandomArray:9];
            
            g_TextField1.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:0]];
            g_TextField2.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:1]];
            g_TextField3.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:2]];
            g_TextField4.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:3]];
            g_TextField5.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:4]];
            g_TextField6.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:5]];
            g_TextField7.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:6]];
            g_TextField8.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:7]];
            g_TextField9.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:8]];
            break;
        case 1: // 手動輸入
            [self showMessage:@"text" :@"手動輸入"];
        default:
            break;
    }
}

// 點擊亂數button
- (IBAction)clickRandomButton:(UIButton *)sender {
    // 確認使用者輸入的數字
    if([self checkInputNumber]) {
        NSLog(@"===OK===");
        // 取得亂數
        [self getRandomArray:9];
    }else{
        NSLog(@"===Error===");
    }
}

// 點擊[開始]Button
- (IBAction)clickStartButton:(id)sender {
    int iCount = g_MAarray.count;   // 數組個數
    int iGapX = 0;  // X軸偏移量
    int iGapY = 0;  // Y軸偏移量
    for(int i=0; i<iCount; i++) {
        //[self addNumberBoutton:i :[g_MAarray objectAtIndex:i] :iCount  :iGapX  :iGapY];
        
        iGapX = 30 + (i % 3) * 100;
        iGapY = 160 + (i / 3) * 100;
        // 轉換型別 Int to String
        NSString *strValue = [[NSString alloc] initWithFormat:@"%@",[g_MAarray objectAtIndex:i]];
        [self addNumberBoutton:i :strValue :iCount  :iGapX  :iGapY];
    }
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化bingo數組
    g_MAarray = [[NSMutableArray alloc]init];
    

//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn addTarget:self
//            action:@selector(showMessage:)
//  forControlEvents:UIControlEventTouchDown];
//     [btn setTitle:@"Click Me" forState:UIControlStateNormal];
//    btn.frame = CGRectMake(0, 0, 60, 60);
//    btn.center = self.view.center;
//    [self.view addSubview:btn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 產生button  iTag  strValue  iCount  iGapX  iGapY (點擊[開始]才產生)
//- (void)addNumberBoutton:(int) iTag :(NSString *) strValue :(int) iCount :(int) iGapX :(int) iGapY{
- (void)addNumberBoutton:(int) iTag :(NSString *) strValue :(int) iCount :(int) iGapX :(int) iGapY{
    UIButton *numberButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];//生成一個圓角距形 Button
    [numberButton setFrame:CGRectMake(iGapX, iGapY, 60, 60)];//設定位置大小，大約是中偏上
    [numberButton setTitle:strValue forState:UIControlStateNormal]; //設定為顯示 Click，一般狀態顯示
    [numberButton setBackgroundColor:[UIColor whiteColor]];// 設定背景色
    [numberButton setTag:iTag];// 設定tag
    numberButton.layer.borderColor = [[UIColor blackColor] CGColor];// border顏色
    numberButton.layer.borderWidth = 1;// border寬度
    
    [self.view addSubview:numberButton]; // 加到 self.view 中
}


// 取得亂數
- (void)getRandomArray:(int) count{

    int m_iRandom = 0;
    Boolean m_bRepeat = false;
    while(g_MAarray.count < count) {
        // 取得 g_iMinNumber 到 g_iMaxNumber 之間的亂數
        m_iRandom = (arc4random() % g_iMaxNumber) + g_iMinNumber;
        m_bRepeat = false;
        if(0 == g_MAarray.count) {
            [g_MAarray addObject:@(m_iRandom)];
        }
        // 檢查重複
        for (int i=0; i<g_MAarray.count; i++) {
            
            if (m_iRandom == [[g_MAarray objectAtIndex:i]intValue]) {
                m_bRepeat = true;
            }else if (m_bRepeat == true){
                break;
            }
        }
        if (m_bRepeat == false) {
            [g_MAarray addObject:@(m_iRandom)];
        }

    }
    
    // 存入陣列
    //[g_MAarray addObject: @(m_iRandom)];
    
    NSLog(@"陣列個數：%d  陣列內容：", g_MAarray.count);
    for (int i=0; i<g_MAarray.count; i++) {
        NSLog(@"%d => %@", i, [g_MAarray objectAtIndex:i]);
    }
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



