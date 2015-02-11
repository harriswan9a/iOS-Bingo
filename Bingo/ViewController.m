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
    NSMutableArray *m_numberMutableArray;
    // 存放TextField ID
    NSMutableArray *m_textFieldMutableArray;
    __weak IBOutlet UITextField *m_TextField1;
    __weak IBOutlet UITextField *m_TextField2;
    __weak IBOutlet UITextField *m_TextField3;
    __weak IBOutlet UITextField *m_TextField4;
    __weak IBOutlet UITextField *m_TextField5;
    __weak IBOutlet UITextField *m_TextField6;
    __weak IBOutlet UITextField *m_TextField7;
    __weak IBOutlet UITextField *m_TextField8;
    __weak IBOutlet UITextField *m_TextField9;
    
    __weak IBOutlet UISegmentedControl *m_modeSegmentedControl;
    __weak IBOutlet UITextField *m_minTextField;
    __weak IBOutlet UITextField *m_maxTextField;

    __weak IBOutlet UIButton *m_startButton;

}


@end

@implementation ViewController


// 切換模式
- (IBAction)segmentedAction:(UISegmentedControl *)sender {
    
    // 中斷遊戲
    [self stopGame];
    switch (sender.selectedSegmentIndex) {

        case 0: // 手動輸入
        {
            [self showMessage:@"手動輸入" :@"請輸入數字範圍或直接在方格中插入數字"];
            // 開啟輸入
            [self enableTextField:true];
            break;
        }
        case 1: // 自動模式
        {
            [self showMessage:@"自動模式" :@"請點擊開始"];
            // 關閉輸入
            [self enableTextField:false];
            
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
    if(1 == m_modeSegmentedControl.selectedSegmentIndex){
        [self autoMode];
        NSLog(@"自動模式:重新取得亂數");
    }else if([self checkRangeNumber]) { // 確認使用者輸入的數字範圍
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
    if ([self checkInputNumber] == true) {
        int iCount = m_numberMutableArray.count;   // 數組個數
        int iGapX = 0;  // X軸偏移量
        int iGapY = 0;  // Y軸偏移量
        for(int i=0; i<iCount; i++) {
            //[self addNumberBoutton:i :[m_numberMutableArray objectAtIndex:i] :iCount  :iGapX  :iGapY];
            
            iGapX = 30 + (i % 3) * 100;
            iGapY = 160 + (i / 3) * 100;
            // 轉換型別 Int to String
            NSString *strValue = [[NSString alloc] initWithFormat:@"%@",[m_numberMutableArray objectAtIndex:i]];
            [self addNumberBoutton:i :strValue :iCount  :iGapX  :iGapY];
        }
        
        NSLog(@"---%@", startButton.currentTitle);
        [startButton setTitle:@"結束" forState:UIControlStateNormal];
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_numberMutableArray = [[NSMutableArray alloc]init];
    m_textFieldMutableArray = [[NSMutableArray alloc]init];
    
    // 初始化
    [self setInitialization];

    


}

// 初始化
- (void)setInitialization {
    
    [m_textFieldMutableArray removeAllObjects];
    [m_numberMutableArray removeAllObjects];
    
    // bingo數組
    for (int i= 0; i<=8; i++) {
        [m_numberMutableArray addObject:@"0"];
    }
    
    // init m_textFieldMutableArray
    [m_textFieldMutableArray addObject:m_TextField1];
    [m_textFieldMutableArray addObject:m_TextField2];
    [m_textFieldMutableArray addObject:m_TextField3];
    [m_textFieldMutableArray addObject:m_TextField4];
    [m_textFieldMutableArray addObject:m_TextField5];
    [m_textFieldMutableArray addObject:m_TextField6];
    [m_textFieldMutableArray addObject:m_TextField7];
    [m_textFieldMutableArray addObject:m_TextField8];
    [m_textFieldMutableArray addObject:m_TextField9];
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
    int iTag = sender.tag;
    NSString *strValue = sender.text;
    //NSLog(@"tag => %i", iTag);
    [m_numberMutableArray replaceObjectAtIndex:iTag withObject:strValue];
    //NSLog(@"%@", [m_numberMutableArray objectAtIndex:iTag]);
}




// Set textfield value -ok
- (void)setTextFieldValue {
    
    int iCount = m_textFieldMutableArray.count;
    UITextField * myTextField;
    for (int i=0; i<iCount; i++) {
        myTextField = (UITextField*)[m_textFieldMutableArray objectAtIndex:i];
        // 不能寫這樣 myTextField.text = @"%@", [m_numberMutableArray objectAtIndex:i];
        myTextField.text = [NSString stringWithFormat:@"%@", [m_numberMutableArray objectAtIndex:i]];
    }
}


//  清除輸入的數值 -ok
- (void)cleanTextFieldValue {
    
    int iCount = m_textFieldMutableArray.count;
    UITextField * myTextField;
    for (int i=0; i<iCount; i++) {
        myTextField = (UITextField*)[m_textFieldMutableArray objectAtIndex:i];
        myTextField.text = @"";
    }
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

// 關閉遊戲按鈕 -ok
- (void)removeNumberButton:(int)iCount {
    for (int i=50; i<=iCount+50; i++) {
        [(UIButton*)[self.view viewWithTag:i]  removeFromSuperview];
    }
}


// 取得亂數
- (void)getRandomArray:(int) count{

    int iRandom = 0;
    Boolean bRepeat = false;
    
    // 轉換型態 String to int
    int iMinNumber = [m_minTextField.text intValue];
    int iMaxNumber = [m_maxTextField.text intValue];
    
    // 清除Array內容
    [m_numberMutableArray removeAllObjects];
    
    while(m_numberMutableArray.count < count) {
        // 取得 iMinNumber 到 iMaxNumber 之間的亂數
        iRandom = (arc4random() % iMaxNumber) + iMinNumber;
        bRepeat = false;
        if(0 == m_numberMutableArray.count) {
            [m_numberMutableArray addObject:@(iRandom)];
        }
        // 檢查重複
        for (int i=0; i<m_numberMutableArray.count; i++) {
            
            if (iRandom == [[m_numberMutableArray objectAtIndex:i]intValue]) {
                bRepeat = true;
            }else if (bRepeat == true){
                break;
            }
        }
        if (bRepeat == false) {
            [m_numberMutableArray addObject:@(iRandom)];
        }

    }
    
    // test debug
    NSLog(@"陣列個數：%d  陣列內容：", m_numberMutableArray.count);
    for (int i=0; i<m_numberMutableArray.count; i++) {
        NSLog(@"%d => %@", i, [m_numberMutableArray objectAtIndex:i]);
    }
}


// popupAlertView
- (void)showMessage:(NSString *)title :(NSString *)message {
    UIAlertView *messageAlertView = [[UIAlertView alloc]
                                        initWithTitle    :title
                                        message          :message
                                        delegate         :nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    [messageAlertView show];
    [self viewDidLoad];
}


// 判斷是否為整數
+ (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


// 檢查輸入的數字範圍
- (BOOL)checkRangeNumber {
    
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


// 檢查手動輸入的數字
- (BOOL)checkInputNumber {
    UITextField * textField;
    for (int i=0; i<=8; i++) {
        textField = (UITextField *)[m_textFieldMutableArray objectAtIndex:i];
        int iValue = [textField.text intValue];
        
        // 檢查型態
        if([[self class]isPureInt: [textField text]]){
            NSLog(@"%i => OK", i);
        }else{
            [self showMessage:@"Error" :@"請輸入任意正整數"];
            [textField becomeFirstResponder];  // focus
            NSLog(@"請輸入任意正整數");
            return false;
        }
        
        // 是否為正整數
        if (0 >= iValue) {
            [self showMessage:@"Error" :@"數字必須大於0"];
            [textField becomeFirstResponder];  // focus
            NSLog(@"數字必須大於0");
            return false;
        }
        
        // 是否重複
        if ([m_textFieldMutableArray containsObject:[textField text]] == 1) {
            [textField becomeFirstResponder];  // focus
            [self showMessage:@"Error" :@"輸入重複"];
            NSLog(@"輸入重複");
            return false;
        }

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
        NSLog(@"開啟輸入模式");

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
        NSLog(@"關閉輸入模式");
    }
}


// 中斷遊戲
- (void)stopGame {
    // 移除按鈕
    [self removeNumberButton:9];
    // 清除TextField
    [self cleanTextFieldValue];
    // 初始化按鈕
    [m_startButton setTitle:@"開始" forState:UIControlStateNormal];
}

@end



