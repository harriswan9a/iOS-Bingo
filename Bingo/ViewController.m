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
    // 存放TextField ID
    NSMutableArray *m_textFieldArray;
    __weak IBOutlet UITextField *m_TextField1;
    __weak IBOutlet UITextField *m_TextField2;
    __weak IBOutlet UITextField *m_TextField3;
    __weak IBOutlet UITextField *m_TextField4;
    __weak IBOutlet UITextField *m_TextField5;
    __weak IBOutlet UITextField *m_TextField6;
    __weak IBOutlet UITextField *m_TextField7;
    __weak IBOutlet UITextField *m_TextField8;
    __weak IBOutlet UITextField *m_TextField9;
    
    __weak IBOutlet UISegmentedControl *m_modeSegmented;
    __weak IBOutlet UITextField *m_minTextField;
    __weak IBOutlet UITextField *m_maxTextField;


}


@end

@implementation ViewController






// 切換模式觸發
- (IBAction)segmentedAction:(UISegmentedControl *)sender {
    
    // 清除按鈕/中斷遊戲
    [self removeNumberButton:9];
    
    switch (sender.selectedSegmentIndex) {

        case 0: // 手動輸入
        {
            [self showMessage:@"手動輸入" :@"請輸入數字範圍或直接在方格中插入數字"];
            // 開啟輸入
            [self enableTextField:true];
            // 清除畫面
            [self cleanTextFieldValue];
            break;
        }
        case 1: // 自動模式
        {
            [self showMessage:@"自動模式" :@"請點擊開始"];
            // 關閉輸入
            [self enableTextField:false];
            // 清除畫面
            [self cleanTextFieldValue];
            
            [self autoMode];
            break;
        }
        default:
            break;
    }
}


// 點擊亂數button
- (IBAction)clickRandomButton:(UIButton *)sender {
    
    // 自動模式重新取得亂數
    if(1 == m_modeSegmented.selectedSegmentIndex){
        [self autoMode];
        
        NSLog(@"自動模式:重新取得亂數");
    }else if([self checkInputNumber]) { // 確認使用者輸入的數字
        NSLog(@"===OK===");
        // 取得亂數
        [self getRandomArray:9];
        [self setTextFieldValue];
    }else{
        NSLog(@"===Error===");
    }
}


// 點擊[開始]/[結束]Button
- (IBAction)clickStartButton:(id)sender {
    UIButton *startButton = (UIButton *)sender;
    
    if ([[startButton currentTitle]isEqualToString: @"結束"]) {
        NSLog(@"---%@", [sender currentTitle]);
        [startButton setTitle:@"開始" forState:UIControlStateNormal];
        // remove button
        [self removeNumberButton:9];
        [self cleanTextFieldValue];
        
        return;
    }
    
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
    NSLog(@"---%@", startButton.currentTitle);
    [startButton setTitle:@"結束" forState:UIControlStateNormal];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化bingo數組
    g_MAarray = [[NSMutableArray alloc]init];
    m_textFieldArray = [[NSMutableArray alloc]init];
    
    // init m_textfieldArray
    [m_textFieldArray removeAllObjects];
    NSString *strID = nil;
    for (int i = 1; i<=9; i++) {
        strID = [[NSString alloc] initWithFormat:@"m_textField%d",i];
        [m_textFieldArray addObject:strID];
        NSLog(@"%@",strID);
    }
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 自動模式
-(void)autoMode {
    m_minTextField.text = @"1";
    m_maxTextField.text = @"9";
    [self getRandomArray:9];
    [self setTextFieldValue];
}

- (IBAction)changeValue:(UITextField *)sender {
  //  [g_MAarray replaceObjectAtIndex:0 withObject:];
   // NSLog(@"``%i", [[g_MAarray objectAtIndex:0]intValue]);
    NSLog(@"%i", g_MAarray.count);
//    if (9 <= g_MAarray.count) {
//        <#statements#>
//    }
    
    
    
//    NSLog(@"````%i",sender.tag);
//    int iTag = sender.tag;
//    NSLog(@"``%i", [[g_MAarray objectAtIndex:1]intValue]);
//    NSString *strValue = nil;
//    if ([[self class] isPureInt:sender.text]) {
//        NSLog(@"iTag %i", iTag);
//        strValue = sender.text;
//
//        NSLog(@"``%i", [[g_MAarray objectAtIndex:iTag]intValue]);
//    }
}




// Set textfield value.
- (void)setTextFieldValue {
    
    m_TextField1.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:0]];
    m_TextField2.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:1]];
    m_TextField3.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:2]];
    m_TextField4.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:3]];
    m_TextField5.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:4]];
    m_TextField6.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:5]];
    m_TextField7.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:6]];
    m_TextField8.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:7]];
    m_TextField9.text = [NSString stringWithFormat:@"%@", [g_MAarray objectAtIndex:8]];
}


// Set textfield value.
- (void)cleanTextFieldValue {

    m_TextField1.text = [NSString stringWithFormat:@""];
    m_TextField2.text = [NSString stringWithFormat:@""];
    m_TextField3.text = [NSString stringWithFormat:@""];
    m_TextField4.text = [NSString stringWithFormat:@""];
    m_TextField5.text = [NSString stringWithFormat:@""];
    m_TextField6.text = [NSString stringWithFormat:@""];
    m_TextField7.text = [NSString stringWithFormat:@""];
    m_TextField8.text = [NSString stringWithFormat:@""];
    m_TextField9.text = [NSString stringWithFormat:@""];
    
    // 清除陣列
    [g_MAarray removeAllObjects];
}


// 產生button  iTag  strValue  iCount  iGapX  iGapY (點擊[開始]才產生)
//- (void)addNumberBoutton:(int) iTag :(NSString *) strValue :(int) iCount :(int) iGapX :(int) iGapY{
- (void)addNumberBoutton:(int) iTag :(NSString *) strValue :(int) iCount :(int) iGapX :(int) iGapY{
    UIButton *numberButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];//生成一個圓角距形 Button
    [numberButton setFrame:CGRectMake(iGapX, iGapY, 60, 60)];//設定位置大小，大約是中偏上
    [numberButton setTitle:strValue forState:UIControlStateNormal]; //設定為顯示 Click，一般狀態顯示
    [numberButton setBackgroundColor:[UIColor whiteColor]];// 設定背景色
    [numberButton setTag:iTag+50];// 設定tag
    numberButton.layer.borderColor = [[UIColor blackColor] CGColor];// border顏色
    numberButton.layer.borderWidth = 1;// border寬度
    
    [self.view addSubview:numberButton]; // 加到 self.view 中
    
    if (numberButton.tag == 5) {
        // 拿掉button
        [numberButton removeFromSuperview];
    }
}

- (void)removeNumberButton:(int)iCount {
    for (int i=50; i<=iCount+50; i++) {
        [(UIButton*)[self.view viewWithTag:i]  removeFromSuperview];
    }
//    for(UIView *subview in [self.view subviews]) {
//        if([subview isKindOfClass:[UIButton class]]) {
//            NSLog(@"remove UIButton");
//
//        } else {
//            // Do nothing - not a UIButton or subclass instance
//        }
//    }
}


// 取得亂數
- (void)getRandomArray:(int) count{

    int iRandom = 0;
    Boolean bRepeat = false;
    
    // 轉換型態 String to int
    int iMinNumber = [m_minTextField.text intValue];
    int iMaxNumber = [m_maxTextField.text intValue];
    
    // 清除Array內容
    [g_MAarray removeAllObjects];
    
    while(g_MAarray.count < count) {
        // 取得 iMinNumber 到 iMaxNumber 之間的亂數
        iRandom = (arc4random() % iMaxNumber) + iMinNumber;
        bRepeat = false;
        if(0 == g_MAarray.count) {
            [g_MAarray addObject:@(iRandom)];
        }
        // 檢查重複
        for (int i=0; i<g_MAarray.count; i++) {
            
            if (iRandom == [[g_MAarray objectAtIndex:i]intValue]) {
                bRepeat = true;
            }else if (bRepeat == true){
                break;
            }
        }
        if (bRepeat == false) {
            [g_MAarray addObject:@(iRandom)];
        }

    }
    
    // test debug
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
                        cancelButtonTitle:@"OK"
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
    
    int iMinNumber = 0;
    int iMaxNumber = 0;
    
    if ([[self class] isPureInt:m_minTextField.text]) {
        NSLog(@"m_iMinNumber:%@", m_minTextField.text);
        iMinNumber = [m_minTextField.text intValue];
    }else{
        [self showMessage:@"Warning" :@"最小值只能輸入正整數"];
        [m_minTextField becomeFirstResponder];  // focus
        return false;
    }
    
    if ([[self class] isPureInt:m_maxTextField.text]) {
        NSLog(@"m_iMaxNumber:%@", m_maxTextField.text);
        iMaxNumber = [m_maxTextField.text intValue];
    }else{
        [self showMessage:@"Warning" :@"最大值只能輸入正整數"];
        [m_maxTextField becomeFirstResponder];  // focus
        return false;
    }
    
    if (iMinNumber > iMaxNumber ||
        8 > (iMaxNumber - iMinNumber)) {
        NSLog(@"err: iMinNumber >= iMaxNumber");
        [self showMessage:@"Warning" :@"Max值必須大於Min值,且相差9以上"];
        return false;
    }
    
    if (0 > iMinNumber || 7 > iMaxNumber) {
        [self showMessage:@"Warning" :@"輸入的數字必須是正整數"];
        return false;
    }
    
    return true;
}

// 開啟輸入功能
- (void)enableTextField:(bool)type {
    
    if (type == true) {
        m_minTextField.enabled = YES;
        m_maxTextField.enabled = YES;
        m_TextField1.enabled = YES;
        m_TextField2.enabled = YES;
        m_TextField3.enabled = YES;
        m_TextField4.enabled = YES;
        m_TextField5.enabled = YES;
        m_TextField6.enabled = YES;
        m_TextField7.enabled = YES;
        m_TextField8.enabled = YES;
        m_TextField9.enabled = YES;
        NSLog(@"開啟輸入功能");

    }else if(type == false) {
        m_minTextField.enabled = NO;
        m_maxTextField.enabled = NO;
        m_TextField1.enabled = NO;
        m_TextField2.enabled = NO;
        m_TextField3.enabled = NO;
        m_TextField4.enabled = NO;
        m_TextField5.enabled = NO;
        m_TextField6.enabled = NO;
        m_TextField7.enabled = NO;
        m_TextField8.enabled = NO;
        m_TextField9.enabled = NO;
        NSLog(@"關閉輸入功能");
    }
}

@end



