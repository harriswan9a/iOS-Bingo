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

    NSMutableArray *m_aryTextField;
    NSMutableArray *m_aryButtonStatus;
    
    __weak IBOutlet UITextField *m_minTextField;
    __weak IBOutlet UITextField *m_maxTextField;

    __weak IBOutlet UIButton *m_startButton;
    __weak IBOutlet UIButton *m_randomButton;
    
    __weak IBOutlet UILabel *m_connectionLabel;
    __weak IBOutlet UILabel *m_difficultyLable;
    
    __weak IBOutlet UIView *m_controlView;
    __weak IBOutlet UIView *m_playAreaView;
    
    __weak IBOutlet UISegmentedControl *m_modeSegmentedControl;
    __weak IBOutlet UIStepper *m_difficultyStepper;
}


@end

@implementation ViewController


// 切換模式
- (IBAction)selectModeAction:(UISegmentedControl *)sender {   NSLog(@"-selectModeAction");
    
    // 中斷遊戲
    [self stopGame];
    
    switch (sender.selectedSegmentIndex) {

        case 0: // 手動輸入
        {
            [self showMessage:@"手動輸入" :@"請輸入數字範圍或在方格中插入數字"];
            [self enableControl:true :true :true :true];
            break;
        }
        case 1: // 自動模式
        {
            [self showMessage:@"自動模式" :@"請點擊開始"];
            [self enableControl:false :false :true :false];
            [self autoMode];
            break;
        }
        default:
            break;
    }
}


// 點擊亂數button -ok
- (IBAction)clickRandomButtonAction:(UIButton *)sender {    NSLog(@"-clickRandomButtonAction");
    
    // 自動模式重新取得亂數
    if(1 == m_modeSegmentedControl.selectedSegmentIndex){
        [self autoMode];
        NSLog(@"自動模式:重新取得亂數");
    }else if([self checkRangeNumber]) { // 確認使用者輸入的數字範圍
        NSLog(@"===OK===");
        // 取得亂數
        [self getRandom:(int)[m_aryTextField count]];
    }else{
        NSLog(@"===Error===");
    }
}


// 點擊[開始]/[結束]Button
- (IBAction)clickStartButtonAction:(id)sender { NSLog(@"-clickStartButtonAction");
    UIButton *startButton = (UIButton *)sender;

    int iCount = (int)[m_aryTextField count];
    
    if ([[startButton currentTitle]isEqualToString: @"結束"]) {
        
        NSLog(@"---%@", [sender currentTitle]);
        [self stopGame];
        return;
    }
    
    // 檢查輸入的數值
    if ([self checkInputNumber] == true) {

        // 動態產生Button
        for(int i=0; i<iCount; i++) {
            [self addNumberButton:(UITextField*)[m_aryTextField objectAtIndex:i]];
        }
        
        NSLog(@"---%@", [startButton currentTitle]);
        [startButton setTitle:@"結束" forState:UIControlStateNormal];
        [self enableControl:false :false :false :false];
    }

}


- (IBAction)changeDifficultyAction:(UIStepper *)sender {    NSLog(@"-changeDifficultyAction");
    
    int iCount = (int)[m_aryTextField count];    // 現有的 TextField
    [self removeTextField:iCount];               // 移除畫面上的 TexField
    [m_aryTextField removeAllObjects];           // 清空陣列重新產生
    iCount = pow([sender value], 2.0);
    [m_difficultyLable setText:[NSString stringWithFormat:@"%d", (int)[sender value]]];
    [self assignTextField:iCount];
}



- (void)viewDidLoad {      NSLog(@"-viewDidLoad");
    [super viewDidLoad];
    
    // init
    m_aryTextField = [[NSMutableArray alloc] init];
    m_aryButtonStatus = [[NSMutableArray alloc] init];
    
    
    [self assignTextField:9];
    
}

// select difficulty
- (void)assignTextField:(int)iCount {  NSLog(@"-assignTextField");
    //NSArray *aryTextFieldParam = [NSArray alloc] initWithObjects:<#(id), ...#>, nil;

    int iSetParam = ((int)sqrt(iCount))-3;          // 指定用哪一組參數
    int iParamArray[10][6] = {100, 100, 60, 60, 20, 15, //3
                               70,  70, 50, 50, 20, 15, //4
                               55,  55, 40, 40, 20, 15, //5
                               45,  45, 34, 34, 20, 15, //6
                               38,  38, 30, 30, 20, 15 }; //7
    
    //產生 textField
    for(int i=0; i<iCount; i++) {
        int iGapX = iParamArray[iSetParam][4] + (i % (int)sqrt(iCount)) * iParamArray[iSetParam][0];  // 計算Ｘ軸位置
        int iGapY = iParamArray[iSetParam][5] + (i / (int)sqrt(iCount)) * iParamArray[iSetParam][1]; // 計算Y軸位置
        // 轉換型別 Int to String
        
        [self addTextField:i :nil :iGapX  :iGapY :iParamArray[iSetParam][2] :iParamArray[iSetParam][3]];
    }
    
    [self resetNumberStatus];
}

// 重置連線紀錄
- (void)resetNumberStatus {  NSLog(@"-resetNumberStatus");
    // 重置顯示連線數
    [m_connectionLabel setText:@"0"];
    // 重置判斷連線array
    [m_aryButtonStatus removeAllObjects];
    for (int i= 0; i<m_aryTextField.count; i++) {
        [m_aryButtonStatus addObject:@"0"];
    }
}


- (void)didReceiveMemoryWarning {  NSLog(@"-didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 自動模式 -ok
-(void)autoMode {  NSLog(@"-autoMode");
    m_minTextField.text = @"1";
    m_maxTextField.text = @"9";
    [self removeTextField:(int)[m_aryTextField count]]; // 清除畫面上的TextField
    [m_aryTextField removeAllObjects];                  // 清除textField元件陣列
    [self assignTextField:9];                           // 產生textField元件
    [self getRandom:(int)[m_aryTextField count]];       // 取得亂數
    [self enableControl:false :false :true :false];     // 關閉控制項
}


//  清除輸入的數值 -ok
- (void)cleanTextFieldValue {  NSLog(@"-cleanTextFieldValue");
    
    int iCount = (int)[m_aryTextField count];
    UITextField * myTextField;
    for (int i=0; i<iCount; i++) {
        myTextField = (UITextField*)[m_aryTextField objectAtIndex:i];
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
- (void)addNumberButton:(UITextField*) myTextField{ NSLog(@"-addNumberButton");
    
    int iTag = (int)myTextField.tag-100;    // textField tag = 100 ~
    int iGapX = (int)[myTextField frame].origin.x;
    int iGapY = (int)[myTextField frame].origin.y;
    int iSizeW = (int)[myTextField frame].size.width;
    int iSizeH = (int)[myTextField frame].size.height;
    NSString *strValue = myTextField.text;
    
    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];//生成一個圓角距形 Button  需搭配下一行的code才有圓角
    [numberButton.layer setCornerRadius:0];
    [numberButton setFrame:CGRectMake(iGapX, iGapY, iSizeW, iSizeH)];//設定位置大小，大約是中偏上
    [numberButton setTitle:strValue forState:UIControlStateNormal]; //設定為顯示 Click，一般狀態顯示
    [numberButton setBackgroundColor:[UIColor whiteColor]];// 設定背景色
    [numberButton setTag:iTag+500];// 設定tag
    numberButton.layer.borderColor = [[UIColor blackColor] CGColor];// border顏色
    numberButton.layer.borderWidth = 1;// border寬度
    
    
    [numberButton addTarget:self
                     action:@selector(clickNumberButton:)
           forControlEvents:UIControlEventTouchDown];

    
    [m_playAreaView addSubview:numberButton]; // 加到 self.view 中

}

// 動態產生TextField遊戲輸入框
- (void)addTextField:(int) iTag
                    :(NSString *) strValue
                    :(int) iGapX
                    :(int) iGapY
                    :(int) iSizeX
                    :(int) iSizeY{  NSLog(@"-addTextField");
    
    UITextField *myTextField = [[UITextField alloc] init];
    [myTextField setFrame           :CGRectMake(iGapX, iGapY, iSizeX, iSizeY)];
    [myTextField setText            :strValue ];
    [myTextField setBackgroundColor :[UIColor whiteColor]];// 設定背景色
    [myTextField setTag             :iTag+100];// 設定tag
    [myTextField setTextColor       :[UIColor colorWithRed:150.0/256.0 green:150.0/256.0 blue:150.0/256.0 alpha:1.0]];
    [myTextField setTextAlignment   :NSTextAlignmentCenter]; // 文字置中
    [myTextField setKeyboardType    :UIKeyboardTypeNumberPad]; //改成數字鍵盤
    [myTextField setPlaceholder     :@"?"];  // 提示字串
    
    myTextField.layer.borderColor = [[UIColor blackColor] CGColor];// border顏色
    myTextField.layer.borderWidth = 1;// border寬度
    
    [m_aryTextField addObject:myTextField];
    
    [m_playAreaView addSubview:myTextField]; // 加到 m_playAreaView view 中

}


// 遊戲中點擊Button -ok
-(void)clickNumberButton:(id)sender {  NSLog(@"-clickNumberButton");
    UIButton* myButton = sender;
    int iTag = (int)(myButton.tag - 500);
    
    // 如果沒有被點選過 0
    if ([[m_aryButtonStatus objectAtIndex:iTag] isEqualToString:@"0"]) {
        [myButton setBackgroundColor:[UIColor redColor]];
        [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [myButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];    // 改字型大小
        [m_aryButtonStatus replaceObjectAtIndex:iTag withObject:@"1"];    // 被點選更改陣列值
    }else if ([[m_aryButtonStatus objectAtIndex:iTag] isEqualToString:@"1"]) {
        [myButton setBackgroundColor:[UIColor whiteColor]];
        [myButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal]; // 改回預設顏色
        [myButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];    // 改字型大小
        [m_aryButtonStatus replaceObjectAtIndex:iTag withObject:@"0"];    // 被點選更改陣列值
    }

    [self countTotalLine];
}

// 判斷連線數 function
-(void)countTotalLine {  NSLog(@"-countTotalLine");
    int iCount = (int)[m_aryTextField count];  // 取得總個數  9
    int iOneLineCount = sqrt(iCount);  // 取得連線的個數(開根號)  3
    int iConnections = 0;
    int k = 0;
  
    
    // 判斷橫向連線
    for (int i=0; i<iOneLineCount; i++) {
        k = 0;
        for (int j=0+(i*iOneLineCount); j<iOneLineCount+(i*iOneLineCount); j++) {
            if (1 == [[m_aryButtonStatus objectAtIndex:j] intValue]) {
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
            if (1 == [[m_aryButtonStatus objectAtIndex:i] intValue]) {
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
        if (1 == [[m_aryButtonStatus objectAtIndex:i] intValue]) {
            k++;
        }
    }
    if (k == iOneLineCount) {
        iConnections++;
    }
    
    // 判斷正斜線 "/"
    
    k = 0;
    for (int i=(iOneLineCount-1); i<iCount-(iOneLineCount-1); i=i+(iOneLineCount-1)) {
        if (1 == [[m_aryButtonStatus objectAtIndex:i] intValue]) {
            k++;
        }
    }
    if (k == iOneLineCount) {
        iConnections++;
    }
    
    
    NSLog(@"目前連線數：%d", iConnections);
    
    // 更新目前連線數
    m_connectionLabel.text = [[NSString alloc] initWithFormat:@"%d", iConnections];

}


/* 關閉遊戲按鈕 -ok
 * @param1: int 關閉幾個按鈕
 */
- (void)removeNumberButton:(int)iCount {  NSLog(@"-removeNumberButton");
    for (int i=500; i<=iCount+500; i++) {
        [(UIButton*)[self.view viewWithTag:i]  removeFromSuperview];
    }
}

/* 關閉遊戲按鈕 -ok
 * @param1: int 關閉幾個按鈕
 */
- (void)removeTextField:(int)iCount {  NSLog(@"-removeTextField");
    for (int i=100; i<=iCount+100; i++) {
        [(UIButton*)[self.view viewWithTag:i]  removeFromSuperview];
    }
}


/* 取得亂數   -ok
 * @param1: int 產生幾個亂數
 */
- (void)getRandom:(int) iCount{  NSLog(@"-getRandom");

    int iRandom = 0;
    Boolean bRepeat = false;
    
    // 轉換型態 String to int
    int iMinNumber = (int)[[m_minTextField text] intValue];
    int iMaxNumber = (int)[[m_maxTextField text] intValue];
    
    // 清除 TextField 內容
    [self cleanTextFieldValue];
    
    // 產生亂數
    NSMutableArray *numberMutableArray = [[NSMutableArray alloc] init];
    while(numberMutableArray.count < iCount) {
        // 取得 iMinNumber 到 iMaxNumber 之間的亂數
        iRandom = (arc4random() % iMaxNumber) + iMinNumber;
        bRepeat = false;
        if(0 == numberMutableArray.count) {
            [numberMutableArray addObject:[NSString stringWithFormat:@"%d",iRandom]];
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
            [numberMutableArray addObject:[NSString stringWithFormat:@"%d",iRandom]];
        }
    }
    // 將亂數推到畫面上
    UITextField *myTextField = nil;
    for (int i=0; i<iCount; i++) {
        
        myTextField = (UITextField*)[m_aryTextField objectAtIndex:i];
        myTextField.text = [NSString stringWithFormat:@"%@", [numberMutableArray objectAtIndex:i]];
    }
}


/* show Message -ok
 * @param1: str title
 * @param2: str message
 */
- (void)showMessage:(NSString *)title :(NSString *)message {  NSLog(@"-showMessage");
    UIAlertView *messageAlertView = [[UIAlertView alloc]
                                        initWithTitle    :title
                                        message          :message
                                        delegate         :nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    [messageAlertView show];
}


// 判斷是否為整數 -ok
+ (BOOL)isPureInt:(NSString*)string {   NSLog(@"-isPureInt");
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val; // 初始化會判斷錯誤 ..
    return[scan scanInt:&val] && [scan isAtEnd];
}


/* 檢查輸入的數字範圍 -ok
 * iMinNumber >= 0
 * iMaxNumber < 99
 */
- (BOOL)checkRangeNumber {  NSLog(@"-checkRangeNumber");
    
    int iMinNumber = 0;
    int iMaxNumber = 0;
    int iCount = (int)[m_aryTextField count];
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
- (BOOL)checkInputNumber {  NSLog(@"-checkInputNumber");
    int iCount = (int)[m_aryTextField count];
    int iValue = 0;
    int iMinNumber = 0;
    int iMaxNumber = 0;
    UITextField * myTextField = nil;
    for (int i=0; i<iCount; i++) {
        myTextField = (UITextField *)[m_aryTextField objectAtIndex:i];
        
        // 檢查型態
        if([[self class]isPureInt:myTextField.text]){
            NSLog(@"%i => OK", i);
            // String to int
            iValue = [myTextField.text intValue];
        }else{
            [self showMessage:@"Error" :@"請輸入任意正整數或[亂數]產生"];
            [myTextField becomeFirstResponder];  // focus
            NSLog(@"請輸入任意正整數或[亂數]產生");
            return false;
        }
        
        // 限制範圍 1~99
        if (0 >= iValue || 100 <= iValue) {
            [self showMessage:@"Error" :@"輸入的數字必須介於1~99之間"];
            [myTextField becomeFirstResponder];  // focus
            NSLog(@"輸入的數字必須介於1~99之間");
            return false;
        }
        
        // 是否重複
        for (int n = 0; n<iCount; n++) {
            if (n == i) {
                
            }else if ([[(UITextField*)[m_aryTextField objectAtIndex:n] text]
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
    
    // 更新範圍值
    m_minTextField.text = [[NSString alloc] initWithFormat:@"%d", iMinNumber];
    m_maxTextField.text = [[NSString alloc] initWithFormat:@"%d", iMaxNumber];
    
    return true;
}


/* 開啟輸入功能 -ok
 * @param1: bool 手動輸入
 * @param2: bool 輸入範圍
 * @param3: bool 亂數Button
 * @param4: bool 難度控制
 */
- (void)enableControl:(BOOL)bType
                     :(BOOL)bRangeType
                     :(BOOL)bRandomType
                     :(BOOL)bChangeDifficulty{  NSLog(@"-enableControl");
    
    int iCount = (int)[m_aryTextField count];
    UITextField * myTextField = nil;
    if (bType == true) {
        for (int i=0; i<iCount; i++) {
            myTextField = (UITextField*)[m_aryTextField objectAtIndex:i];
            myTextField.enabled = YES;
        }

        NSLog(@"開啟輸入模式");

    }else if(bType == false) {
        for (int i=0; i<iCount; i++) {
            myTextField = (UITextField*)[m_aryTextField objectAtIndex:i];
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
    
    if (bChangeDifficulty == true) {
        m_difficultyStepper.enabled = YES;
    }else if (bChangeDifficulty == false) {
        m_difficultyStepper.enabled = NO;
    }
}


// 中斷遊戲重置所有配置 -ok
- (void)stopGame {  NSLog(@"-stopGame");
    
    // 移除按鈕
    int iCount = (int)[m_aryTextField count];
    for (int i=500; i<=iCount+500; i++) {
        [(UIButton*)[self.view viewWithTag:i]  removeFromSuperview];
    }
    
    // 清除TextField
    [self cleanTextFieldValue];
    
    // 初始化按鈕
    [m_startButton setTitle:@"開始" forState:UIControlStateNormal];
    
    // 重置連線數及按鈕狀態
    [self resetNumberStatus];
    if (1 == m_modeSegmentedControl.selectedSegmentIndex) {
        [self enableControl:false :false :true :false];
    }else{
        [self enableControl:true :true :true :true];
    }
    
}


// 點擊任意畫面關閉鍵盤
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{  NSLog(@"-touchesBegan");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


@end


