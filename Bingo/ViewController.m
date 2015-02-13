//
//  ViewController.m
//  Bingo
//
//  Created by Eric on 2015/2/9.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    
    //NSMutableArray *m_numberMutableArray;
    NSMutableArray *m_textFieldMutableArray;
    NSMutableArray *m_countLineMutableArray;
    
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
    __weak IBOutlet UIButton *m_randomButton;
    __weak IBOutlet UILabel *m_lineLabel;
}


@end

@implementation ViewController


// 切換模式
- (IBAction)selectModeAction:(UISegmentedControl *)sender {
    
    // 中斷遊戲
    [self stopGame];
    
    switch (sender.selectedSegmentIndex) {

        case 0: // 手動輸入
        {
            [self showMessage:@"手動輸入" :@"請輸入數字範圍或直接在方格中插入數字"];
            // 開啟輸入
            [self enableTextField:true :true :true];
            break;
        }
        case 1: // 自動模式
        {
            [self showMessage:@"自動模式" :@"請點擊開始"];
            // 關閉輸入
            [self enableTextField:false :false :true];
            
            [self autoMode];
            break;
        }
        default:
            break;
    }
}


// 點擊亂數button -ok
- (IBAction)clickRandomButton:(UIButton *)sender {
    
    // 自動模式重新取得亂數
    if(1 == m_modeSegmentedControl.selectedSegmentIndex){
        [self autoMode];
        NSLog(@"自動模式:重新取得亂數");
    }else if([self checkRangeNumber]) { // 確認使用者輸入的數字範圍
        NSLog(@"===OK===");
        // 取得亂數
        [self getRandom:(int)[m_textFieldMutableArray count]];
    }else{
        NSLog(@"===Error===");
    }
}


// 點擊[開始]/[結束]Button
- (IBAction)clickStartButton:(id)sender {
    UIButton *startButton = (UIButton *)sender;

    int iCount = (int)[m_textFieldMutableArray count];   // 數組個數
    int iGapX = 0;  // X軸偏移量
    int iGapY = 0;  // Y軸偏移量
    
    if ([[startButton currentTitle]isEqualToString: @"結束"]) {
        NSLog(@"---%@", [sender currentTitle]);
        // 中斷遊戲
        [self stopGame];
        return;
    }
    
    // 檢查輸入的數值
    if ([self checkInputNumber] == true) {
        
        //動態產生Button
        NSString *strValue = nil;
        for(int i=0; i<iCount; i++) {
            iGapX = 30 + (i % 3) * 100;  // 計算Ｘ軸位置
            iGapY = 160 + (i / 3) * 100; // 計算Y軸位置
            // 轉換型別 Int to String
            strValue = [[NSString alloc] initWithFormat:@"%@",[(UITextField*)[m_textFieldMutableArray objectAtIndex:i] text]];
            [self addNumberButton:i :strValue :iCount  :iGapX  :iGapY];
        }
        NSLog(@"---%@", startButton.currentTitle);
        [startButton setTitle:@"結束" forState:UIControlStateNormal];
        [self enableTextField:false :false :false];
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init
    m_textFieldMutableArray = [[NSMutableArray alloc] init];
    m_countLineMutableArray = [[NSMutableArray alloc] init];
    
    [self setInitialization];
    
}


// 初始化 -ok
- (void)setInitialization {
    
    [m_textFieldMutableArray removeAllObjects];
    [m_countLineMutableArray removeAllObjects];
    
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

    // 重置判斷連線array
    for (int i= 0; i<m_textFieldMutableArray.count; i++) {
        [m_countLineMutableArray addObject:@"0"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 自動模式 -ok
-(void)autoMode {
    m_minTextField.text = @"1";
    m_maxTextField.text = @"9";
    [self getRandom:(int)[m_textFieldMutableArray count]];
}

// 手動模式修改值後寫入Array -ok
// 不用了
- (IBAction)changeValue:(UITextField *)sender {
    
//    int iTag = (int)[sender tag];
//    NSString *strValue = sender.text;
//    [m_numberMutableArray replaceObjectAtIndex:iTag withObject:strValue];
//    
//    NSLog(@"%@", m_numberMutableArray);
}




// 將陣列內容複製到畫面上 m_numberMutabArray to TextField  -ok
//不用了
- (void)setTextFieldText {
//    
//    int iCount = (int)[m_textFieldMutableArray count];
//    UITextField * myTextField;
//    for (int i=0; i<iCount; i++) {
//        myTextField = (UITextField*)[m_textFieldMutableArray objectAtIndex:i];
//        // 不能寫這樣 myTextField.text = @"%@", [m_numberMutableArray objectAtIndex:i];
//        myTextField.text = [NSString stringWithFormat:@"%@", [m_numberMutableArray objectAtIndex:i]];
//    }
}


//  清除輸入的數值 -ok
- (void)cleanTextFieldValue {
    
    int iCount = (int)[m_textFieldMutableArray count];
    UITextField * myTextField;
    for (int i=0; i<iCount; i++) {
        myTextField = (UITextField*)[m_textFieldMutableArray objectAtIndex:i];
        myTextField.text = nil;
    }
}


/* 產生遊戲的Button (點擊[開始]才產生) -ok
 * @param1: int 指定Tag
 * @param2: str Button Title  
 * @param3: int 共有多少個Button
 * @param4: int X軸位置
 * @param5: int Y軸位置
 */
- (void)addNumberButton:(int) iTag
                       :(NSString *) strValue
                       :(int) iCount
                       :(int) iGapX
                       :(int) iGapY{
    
    UIButton *numberButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];//生成一個圓角距形 Button
    [numberButton setFrame:CGRectMake(iGapX, iGapY, 60, 60)];//設定位置大小，大約是中偏上
    [numberButton setTitle:strValue forState:UIControlStateNormal]; //設定為顯示 Click，一般狀態顯示
    [numberButton setBackgroundColor:[UIColor whiteColor]];// 設定背景色
    [numberButton setTag:iTag+50];// 設定tag
    numberButton.layer.borderColor = [[UIColor blackColor] CGColor];// border顏色
    numberButton.layer.borderWidth = 1;// border寬度
    
    
    [numberButton addTarget:self
                     action:@selector(clickNumberButton:)
           forControlEvents:UIControlEventTouchDown];

    
    [self.view addSubview:numberButton]; // 加到 self.view 中
}

// 遊戲中點擊Button -ok
-(void)clickNumberButton:(id)sender {
    UIButton* myButton = sender;
    int iTag = (int)(myButton.tag - 50);
    
    // 如果沒有被點選過 0
    if ([[m_countLineMutableArray objectAtIndex:iTag] isEqualToString:@"0"]) {
        [myButton setBackgroundColor:[UIColor redColor]];
        [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [myButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];    // 改字型大小
        [m_countLineMutableArray replaceObjectAtIndex:iTag withObject:@"1"];    // 被點選更改陣列值
    }else if ([[m_countLineMutableArray objectAtIndex:iTag] isEqualToString:@"1"]) {
        [myButton setBackgroundColor:[UIColor whiteColor]];
        [myButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal]; // 改回預設顏色
        [myButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];    // 改字型大小
        [m_countLineMutableArray replaceObjectAtIndex:iTag withObject:@"0"];    // 被點選更改陣列值
    }

    [self countTotalLine];
}

// 判斷連線數 function
-(void)countTotalLine {
    int iCount = (int)[m_textFieldMutableArray count];  // 取得總個數  9
    int iOneLineCount = sqrt(iCount);  // 取得連線的個數(開根號)  3
    int iConnections = 0;
    int k = 0;
  
    
    // 判斷橫向連線
    for (int i=0; i<iOneLineCount; i++) {
        k = 0;
        for (int j=0+(i*iOneLineCount); j<iOneLineCount+(i*iOneLineCount); j++) {
            if (1 == [[m_countLineMutableArray objectAtIndex:j] intValue]) {
                k++;
            }
            
            if (k == iOneLineCount) {
                iConnections++;
            }
        }
    }
    
    // 判斷直向連線
    for (int j=0; j<iOneLineCount; j++) {
        k = 0;
        for (int i=0+j; i<iCount; i=i+iOneLineCount) {
            if (1 == [[m_countLineMutableArray objectAtIndex:i] intValue]) {
                k++;
            }
            
            if (k == iOneLineCount) {
                iConnections++;
            }
        }
    }

    // 判斷反斜線 "\"
    
    k = 0;
    for (int i=0; i<iCount; i=i+(iOneLineCount+1)) {
        if (1 == [[m_countLineMutableArray objectAtIndex:i] intValue]) {
            k++;
        }
    }
    if (k == iOneLineCount) {
        iConnections++;
    }
    
    // 判斷正斜線 "/"
    
    k = 0;
    for (int i=(iOneLineCount-1); i<iCount-(iOneLineCount-1); i=i+(iOneLineCount-1)) {
        if (1 == [[m_countLineMutableArray objectAtIndex:i] intValue]) {
            k++;
        }
    }
    if (k == iOneLineCount) {
        iConnections++;
    }
    
    
    NSLog(@"目前連線數：%d", iConnections);
    
    // 更新目前連線數
    m_lineLabel.text = [[NSString alloc] initWithFormat:@"%d", iConnections];

}


/* 關閉遊戲按鈕 -ok
 * @param1: int 關閉幾個按鈕
 */
- (void)removeNumberButton:(int)iCount {
    for (int i=50; i<=iCount+50; i++) {
        [(UIButton*)[self.view viewWithTag:i]  removeFromSuperview];
    }
}


/* 取得亂數   -ok
 * @param1: int 產生幾個亂數
 */
- (void)getRandom:(int) iCount{

    int iRandom = 0;
    Boolean bRepeat = false;
    
    // 轉換型態 String to int
    int iMinNumber = [m_minTextField.text intValue];
    int iMaxNumber = [m_maxTextField.text intValue];
    
    // 清除 TextField 內容
    [self cleanTextFieldValue];
    
    // 產生亂數
    NSMutableArray *numberMutableArray = [[NSMutableArray alloc] init];
    while(numberMutableArray.count < iCount) {
        // 取得 iMinNumber 到 iMaxNumber 之間的亂數
        iRandom = (arc4random() % iMaxNumber) + iMinNumber;
        bRepeat = false;
        if(0 == numberMutableArray.count) {
            [numberMutableArray addObject:@(iRandom)];
        }
        // 檢查重複
        for (int i=0; i<numberMutableArray.count; i++) {

            if (iRandom == (int)[[numberMutableArray objectAtIndex:i]intValue]) {
                bRepeat = true;
            }
            if (bRepeat == true){
                break;
            }
        }
        if (bRepeat == false) {
            [numberMutableArray addObject:@(iRandom)];
        }
    }
    // 將亂數推到畫面上
    UITextField *myTextField = nil;
    for (int i=0; i<iCount; i++) {
        
        myTextField = (UITextField*)[m_textFieldMutableArray objectAtIndex:i];
        myTextField.text = [NSString stringWithFormat:@"%@", [numberMutableArray objectAtIndex:i]];
    }
}


/* show Message -ok
 * @param1: str title
 * @param2: str message
 */
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


// 判斷是否為整數 -ok
+ (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val; // 初始化會判斷錯誤 ..
    return[scan scanInt:&val] && [scan isAtEnd];
}


/* 檢查輸入的數字範圍 -ok
 * iMinNumber >= 0
 * iMaxNumber < 99
 */
- (BOOL)checkRangeNumber {
    
    int iMinNumber = 0;
    int iMaxNumber = 0;
    int iCount = (int)[m_textFieldMutableArray count];
    if ([[self class] isPureInt:m_minTextField.text]) {
        NSLog(@"m_minTextField:%@", m_minTextField.text);
        iMinNumber = [[m_minTextField text] intValue];
        //限制最大的範圍
        if (99 < iMinNumber || 1 > iMinNumber ) {
            [self showMessage:@"Warning" :@"最小值不能超過1~99"];
            return false;
        }
    }else{
        [self showMessage:@"Warning" :@"最小值只能輸入正整數"];
        [m_minTextField becomeFirstResponder];  // focus
        return false;
    }
    
    if ([[self class] isPureInt:m_maxTextField.text]) {
        NSLog(@"m_maxTextField:%@", m_maxTextField.text);
        iMaxNumber = [[m_maxTextField text] intValue];
        //限制最大的範圍
        if (99 < iMaxNumber || 1 > iMaxNumber ) {
            [self showMessage:@"Warning" :@"最大值不能超過1~99"];
            return false;
        }
    }else{
        [self showMessage:@"Warning" :@"最大值只能輸入正整數"];
        [m_maxTextField becomeFirstResponder];  // focus
        return false;
    }
    
    if (iMinNumber > iMaxNumber ||
        iCount > (iMaxNumber-iMinNumber+1)) {
        NSLog(@"err: iMinNumber >= iMaxNumber");
        [self showMessage:@"Warning"
                         :[[NSString alloc]initWithFormat:@"Max值必須大於Min值,且範圍包含%d個數字", iCount]];
        return false;
    }

    return true;
}


// 檢查手動輸入的數字 -ok
- (BOOL)checkInputNumber {
    int iCount = (int)[m_textFieldMutableArray count];
    int iValue = 0;
    int iMinNumber = 0;
    int iMaxNumber = 0;
    UITextField * myTextField = nil;
    for (int i=0; i<iCount; i++) {
        myTextField = (UITextField *)[m_textFieldMutableArray objectAtIndex:i];
        
        // 檢查型態
        if([[self class]isPureInt:myTextField.text]){
            NSLog(@"%i => OK", i);
            // String to int
            iValue = [myTextField.text intValue];
        }else{
            [self showMessage:@"Error" :@"請輸入任意正整數"];
            [myTextField becomeFirstResponder];  // focus
            NSLog(@"請輸入任意正整數");
            return false;
        }
        
        // 限制範圍 1~99
        if (0 > iValue || 99 < iValue) {
            [self showMessage:@"Error" :@"輸入的數字必須介於1~99之間"];
            [myTextField becomeFirstResponder];  // focus
            NSLog(@"輸入的數字必須介於1~99之間");
            return false;
        }
        
        // 是否重複
        for (int n = 0; n<iCount; n++) {
            if (n == i) {
                
            }else if ([[(UITextField*)[m_textFieldMutableArray objectAtIndex:n] text]
                isEqualToString:[myTextField text]]) {
                [myTextField becomeFirstResponder];  // focus
                [self showMessage:@"Error" :@"重複輸入"];
                NSLog(@"重複輸入");

                return false;
            }
        }
        
        // 記錄最大值/最小值
        if (0 == i) {
            iMinNumber =[[myTextField text]intValue];
        }
        if (iMaxNumber < [[myTextField text]intValue]) {
            iMaxNumber = [[myTextField text]intValue];
        }else if (iMinNumber > [[myTextField text]intValue]) {
            iMinNumber = [[myTextField text]intValue];
        }
    }
    
    // 更新範圍數字
    m_minTextField.text = [[NSString alloc] initWithFormat:@"%d", iMinNumber];
    m_maxTextField.text = [[NSString alloc] initWithFormat:@"%d", iMaxNumber];
    
    return true;
}


/* 開啟輸入功能 -ok
 * @param1: bool 手動輸入
 * @param2: bool 輸入範圍
 * @param3: bool 亂數Button
 */
- (void)enableTextField:(BOOL)bType :(BOOL)bRangeType :(BOOL)bRandomType{
    
    int iCount = (int)[m_textFieldMutableArray count];
    UITextField * myTextField = nil;
    if (bType == true) {
        for (int i=0; i<iCount; i++) {
            myTextField = (UITextField*)[m_textFieldMutableArray objectAtIndex:i];
            myTextField.enabled = YES;
        }

        NSLog(@"開啟輸入模式");

    }else if(bType == false) {
        for (int i=0; i<iCount; i++) {
            myTextField = (UITextField*)[m_textFieldMutableArray objectAtIndex:i];
            myTextField.enabled = NO;
        }
        
        NSLog(@"關閉輸入模式");
    }
    
    if (bRangeType == true) {
        m_minTextField.enabled = YES;
        m_maxTextField.enabled = YES;
        NSLog(@"開啟範圍輸入");
    }else if(bRangeType == false) {
        m_minTextField.enabled = NO;
        m_maxTextField.enabled = NO;
        NSLog(@"關閉範圍輸入");
    }
    
    if (bRandomType == true) {
        m_randomButton.enabled = YES;
    }else if (bRandomType == false) {
        m_randomButton.enabled = NO;
    }
}


// 中斷遊戲重置所有配置 -ok
- (void)stopGame {
    // 移除按鈕
    [self removeNumberButton:(int)[m_textFieldMutableArray count]];
    // 清除TextField
    [self cleanTextFieldValue];
    // 初始化按鈕
    [m_startButton setTitle:@"開始" forState:UIControlStateNormal];
    m_randomButton.enabled = YES;
    // 重置連線數
    m_lineLabel.text = @"0";
    // 重置設定
    [self setInitialization];
    if (1 == m_modeSegmentedControl.selectedSegmentIndex) {
        [self enableTextField:false :false :true];
    }else{
        [self enableTextField:true :true :true];
    }
    
}


// 點擊任意畫面關閉鍵盤
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end


/* @todo    1. Button Tag 目前設定50以後，暫時避開重複tag才能remove
 *          2. 搞清楚 "." 跟 "[ ]" 用法
 *        ★★3. 無法顯示鍵盤
 *
 *
 */