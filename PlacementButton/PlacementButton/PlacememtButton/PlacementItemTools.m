//
//  PlacementItemTools.m
//
//  Created by Coody on 2016/2/3.
//

#import "PlacementItemTools.h"

/** Debug Mode */
#define D_CoodyTest
/** 多個按鈕是否移動的時候跟隨？ */
#define D_PlacementItemTools_Follow
/** 點擊後是否移到上方排列？ */
//#define D_PlacementItemTools_MoveToTop

/*
 底下 define 的說明：
 將畫面分成四個區塊：
 ┌─────────────┐
 │      1      │
 ├──────┬──────┤
 │      │      │
 │      │      │
 │  2   │   3  │
 │      │      │
 │      │      │
 ├──────┴──────┤
 │      4      │
 └─────────────┘
 當按鈕中心點再這些範圍的時候，會自動修正回邊邊，
 如：當按鈕移動到 1 的時候，放開會回到 1 的螢幕邊框貼住；當按鈕移動到 3 的時候，方開會回到 3 的螢幕邊框（也就是右邊邊框）貼住。
 D_PlacementItemTools_Edge_TopY_Height 就是設定 1 的高度
 D_PlacementItemTools_Edge_BottomY_Height 就是設定 4 的高度
 */
// 會貼牆壁的範圍
#define D_PlacementItemTools_Edge_TopY_Height (0)
#define D_PlacementItemTools_Edge_BottomY_Height D_PlacementItemTools_Edge_TopY_Height

// 離牆壁的微小距離
#define D_PlacementItemTools_Margin (2)
#define D_PlacementItemTools_TopMargin ([PlacementItemTools getSafeAreaInsets].top)
#define D_PlacementItemTools_BottomMargin ([PlacementItemTools getSafeAreaInsets].bottom)
#define D_PlacementItemTools_RightMargin ([PlacementItemTools getSafeAreaInsets].right)
#define D_PlacementItemTools_LeftMargin ([PlacementItemTools getSafeAreaInsets].left)


// 按鈕起始位置
#define D_PlacementItemTools_Init_X ([UIScreen mainScreen].bounds.size.width - D_PlacementItemTools_Width - D_PlacementItemTools_Margin - D_PlacementItemTools_RightMargin)
#define D_PlacementItemTools_Init_Y (D_PlacementItemTools_Height*2 + D_PlacementItemTools_TopMargin)

// 按鈕透明度
#define D_PlacementButton_NormalAlpha (0.6f)
#define D_PlacementButton_MoveAlpha (1.0f)

// 最大的 Button 數目
NSUInteger const kPlacementItemTools_Max_Button_Count = 2;

// 動畫時間
/** 目前拖拉按鈕放開後，回到邊緣的速度 */
float const kAnimationDuration_Move = 0.2f;
/** 跟隨的按鈕在拖拉按鈕放開後，回到邊緣的速度（建議慢一點點，會有跟隨移動的感覺） */
float const kAnimationDuration_Follow = 0.25f;

#pragma mark - Private UIButton
@interface PlacementUIButton : UIButton
/** 是否是按鈕按下的狀態？ */
@property (nonatomic , assign) BOOL isOnTouch;
/** 舊的按鈕位置 */
@property (nonatomic , assign) CGPoint originalCenter;
/** 是否 */
@property (nonatomic , copy) void(^pressedButtonBlock)(UIButton *);
-(void)followRootButton:(PlacementUIButton *)rootButton;
-(void)endFollowRootButton:(PlacementUIButton *)rootButton;
-(void)followCloselyWithButton:(PlacementUIButton *)rootButton;
-(CGPoint)getEndCenterPoint:(CGPoint)targetCenterPoint;
@end

@implementation PlacementUIButton
-(instancetype)init{
    self = [super init];
    if ( self ) {
        _isOnTouch = NO;
    }
    return self;
}

-(void)dealloc{
    
}

#pragma mark - 按鈕動畫
/**
 * @brief - 
 */
-(void)beginMoveToRootButton:(PlacementUIButton *)rootButton{
    CGFloat newX = self.center.x;
    CGFloat newY = self.center.y;
    CGFloat moveDistance = 12;
//    CGFloat checkMaxX = rootButton.center.x + (D_PlacementItemTools_Width + moveDistance);
//    CGFloat checkMinX = rootButton.center.x - (D_PlacementItemTools_Width + moveDistance);
//    CGFloat checkMaxY = rootButton.center.y + (D_PlacementItemTools_Height + moveDistance);
//    CGFloat checkMinY = rootButton.center.y - (D_PlacementItemTools_Height + moveDistance);
    CGFloat checkMaxX = rootButton.center.x + moveDistance;
    CGFloat checkMinX = rootButton.center.x - moveDistance;
    CGFloat checkMaxY = rootButton.center.y + moveDistance;
    CGFloat checkMinY = rootButton.center.y - moveDistance;
    if ( checkMaxX < newX ) {
        newX = checkMaxX;
    }
    else if( checkMinX > newX ){
        newX = checkMinX;
    }
    
    if ( checkMaxY < newY ) {
        newY = checkMaxY;
    }
    else if( checkMinY > newY ){
        newY = checkMinY;
    }

    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration_Move animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.center = CGPointMake(newX, newY);
    }];
}

-(void)followRootButton:(PlacementUIButton *)rootButton{
    CGFloat newX = self.center.x;
    CGFloat newY = self.center.y;
    CGFloat moveDistance = 12;
//    CGFloat checkMaxX = rootButton.center.x + (D_PlacementItemTools_Width + moveDistance);
//    CGFloat checkMinX = rootButton.center.x - (D_PlacementItemTools_Width + moveDistance);
//    CGFloat checkMaxY = rootButton.center.y + (D_PlacementItemTools_Height + moveDistance);
//    CGFloat checkMinY = rootButton.center.y - (D_PlacementItemTools_Height + moveDistance);
    CGFloat checkMaxX = rootButton.center.x + moveDistance;
    CGFloat checkMinX = rootButton.center.x - moveDistance;
    CGFloat checkMaxY = rootButton.center.y + moveDistance;
    CGFloat checkMinY = rootButton.center.y - moveDistance;
    if ( checkMaxX < newX ) {
        newX = checkMaxX;
    }
    else if( checkMinX > newX ){
        newX = checkMinX;
    }
    
    if ( checkMaxY < newY ) {
        newY = checkMaxY;
    }
    else if( checkMinY > newY ){
        newY = checkMinY;
    }
    
    self.center = CGPointMake(newX, newY);
}

-(void)endFollowRootButton:(PlacementUIButton *)rootButton{
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration_Follow animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.center = [strongSelf getEndCenterPoint:rootButton.center];
    }];
}

-(void)followCloselyWithButton:(PlacementUIButton *)rootButton{
    CGFloat newX = self.center.x;
    CGFloat newY = self.center.y;
    CGFloat checkMaxX = rootButton.center.x + (D_PlacementItemTools_Margin);
    CGFloat checkMinX = rootButton.center.x - (D_PlacementItemTools_Margin);
    CGFloat checkMaxY = rootButton.center.y + (D_PlacementItemTools_Margin);
    CGFloat checkMinY = rootButton.center.y - (D_PlacementItemTools_Margin);
    if ( checkMaxX < newX ) {
        newX = checkMaxX;
    }
    else if( checkMinX > newX ){
        newX = checkMinX;
    }
    
    if ( checkMaxY < newY ) {
        newY = checkMaxY;
    }
    else if( checkMinY > newY ){
        newY = checkMinY;
    }
    
    self.center = CGPointMake(newX, newY);
}

-(CGPoint)getEndCenterPoint:(CGPoint)targetCenterPoint{
    CGFloat fixX = targetCenterPoint.x;
    CGFloat fixY = targetCenterPoint.y;
    CGPoint newCenterPoint;
    CGSize mainScreenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    if ( targetCenterPoint.y >= mainScreenSize.height - D_PlacementItemTools_Edge_BottomY_Height ||
         targetCenterPoint.y <= D_PlacementItemTools_Edge_BottomY_Height ) {
        // 位在區域 1,4
        // 放在 TargetPoint 的右邊，如果超過，就自動改成左邊
        fixX = targetCenterPoint.x + D_PlacementItemTools_Width + D_PlacementItemTools_Margin;
        if ( fixX > mainScreenSize.width - D_PlacementItemTools_Width*0.5 - D_PlacementItemTools_Margin ) {
            fixX = targetCenterPoint.x - D_PlacementItemTools_Width - D_PlacementItemTools_Margin;
        }
    }
    else{
        // 位在區域 2,3
        // 放在 TargetPoint 的下面，如果超過，就自動改成上面
        fixY = targetCenterPoint.y + D_PlacementItemTools_Height + D_PlacementItemTools_Margin;
        if ( fixY > mainScreenSize.height - D_PlacementItemTools_Width*0.5 - D_PlacementItemTools_Margin ) {
            fixY = targetCenterPoint.y - D_PlacementItemTools_Height - D_PlacementItemTools_Margin;
        }
    }
    newCenterPoint = CGPointMake(fixX, fixY);
    return newCenterPoint;
}



@end


#pragma mark - PlacementItemTools
@interface PlacementItemTools()
@property (nonatomic , assign) BOOL isActive;
@property (nonatomic , assign) NSInteger buttonIndex;
@property (nonatomic , strong) NSMutableDictionary *buttonDic;
@property (nonatomic , strong) NSArray *buttonArray;
@property (nonatomic , assign) CGFloat buttonNormalAlpha;
@property (nonatomic , assign) CGFloat buttonMoveAlpha;
@end

@implementation PlacementItemTools

#pragma mark - 開放方法
+(instancetype)sharedInstance{
    static PlacementItemTools *sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if ( sharedInstance == nil ) {
            sharedInstance = [[PlacementItemTools alloc] init];
            sharedInstance.isActive = NO;
        }
    });
    return sharedInstance;
}

-(void)createButtonWithNormalImage:(UIImage *)normalImage
               withHightLightImage:(UIImage *)hightLightImage
                           withTag:(NSInteger)tempTag
                     withDoneBlock:(void(^)(UIButton *responseButton))tempDoneBlock
                  WithPressedBlock:(void(^)(UIButton *responseButton))tempPressedButtonBlock
{
    if ( [_buttonDic count] >= kPlacementItemTools_Max_Button_Count ) {
        return;
    }
    if ( [_buttonDic objectForKey:@(tempTag)] != nil ) {
        return;
    }
    _buttonIndex = tempTag;
    
    PlacementUIButton *button;
    button = [[PlacementUIButton alloc] initWithFrame:CGRectMake(D_PlacementItemTools_Init_X,
                                                                 D_PlacementItemTools_Init_Y*([_buttonDic count]+1),
                                                                 D_PlacementItemTools_Width,
                                                                 D_PlacementItemTools_Height)];
    
    if ( normalImage != nil ) {
        [button setImage:normalImage forState:UIControlStateNormal];
        //        [button setBackgroundImage:normalImage
        //                          forState:UIControlStateNormal];
    }
    if ( hightLightImage != nil ) {
        [button setImage:hightLightImage forState:UIControlStateHighlighted];
        //        [button setBackgroundImage:hightLightImage
        //                          forState:UIControlStateHighlighted];
    }
    
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = _buttonIndex;
    button.pressedButtonBlock = tempPressedButtonBlock;
#ifdef D_CoodyTest
    [button setTitle:[NSString stringWithFormat:@"%ld" , (long)button.tag] forState:(UIControlStateNormal)];
#endif
    [button setAlpha:_buttonNormalAlpha];
    [button addTarget:self action:@selector(beginTouch:) forControlEvents:(UIControlEventTouchDown)];
    [button addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:(UIControlEventTouchDragInside)];
    [button addTarget:self action:@selector(wasDraggedExit:) forControlEvents:(UIControlEventTouchUpInside)];
    [button addTarget:self action:@selector(wasDraggedExit:) forControlEvents:(UIControlEventTouchUpOutside)];
    
    [_tempKeyWindow addSubview:button];
    button.layer.zPosition = EnumPlacementItemToolsZPosition_normal;
    
    [_buttonDic setObject:button forKey:@(_buttonIndex)];
    _buttonArray = [[_buttonDic allValues] sortedArrayUsingComparator:^NSComparisonResult( PlacementUIButton *obj1 , PlacementUIButton *obj2) {
        if ( obj1.tag < obj2.tag ) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else if( obj1.tag > obj2.tag){
            return (NSComparisonResult)NSOrderedDescending;
        }
        else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    tempDoneBlock(button);
}

-(void)setButtonNormalAlpha:(CGFloat)buttonNormalAlpha{
    if( buttonNormalAlpha > 1.0f ){
        buttonNormalAlpha = 1.0f;
    }
    else if( buttonNormalAlpha < 0.0f ){
        buttonNormalAlpha = 0.0f;
    }
}

-(void)setButtonMoveAlpha:(CGFloat)buttonMoveAlpha{
    if( buttonMoveAlpha > 1.0f ){
        buttonMoveAlpha = 1.0f;
    }
    else if( buttonMoveAlpha < 0.0f ){
        buttonMoveAlpha = 0.0f;
    }
}

-(void)setHidden:(BOOL)isHidden{
    for ( PlacementUIButton *button in _buttonDic ) {
        [button setHidden:isHidden];
    }
}

-(UIButton *)getButtonWithTag:(NSUInteger)tempTag{
    PlacementUIButton *button = nil;
    if ( [_buttonDic count] >= tempTag || tempTag > 0 ) {
        button = [_buttonDic objectForKey:@(tempTag)];
    }
    return button;
}

-(void)removeAllButtons{
    for ( PlacementUIButton *button in _buttonDic.allValues ) {
        if ( button.superview != nil ) {
            [button removeFromSuperview];
        }
        button.pressedButtonBlock = nil;
    }
    [_buttonDic removeAllObjects];
    _buttonIndex = 0;
}

-(BOOL)removeButtonWithTag:(NSInteger)tempTag{
    BOOL isSuccess = NO;
    PlacementUIButton *button = [_buttonDic objectForKey:@(tempTag)];
    if ( button != nil ) {
        if ( button.superview != nil ) {
            [button removeFromSuperview];
        }
        button.pressedButtonBlock = nil;
        [_buttonDic removeObjectForKey:@(tempTag)];
        isSuccess = YES;
    }
    
    return isSuccess;
}

-(void)bringButtonToFront{
    for ( PlacementUIButton *unit in _buttonArray ) {
        [_tempKeyWindow bringSubviewToFront:unit];
    }
}

-(void)resetButtonPosition{
    //    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    //
    //    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
    //        //UI is in Default (Portrait) -- this is really a just a failsafe.
    //
    //    }
    //    else{
    //
    //    }
    __block NSUInteger index = 0;
    
    if( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) || UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) )
    {
        for ( PlacementUIButton *button in _buttonArray ) {
            [UIView animateWithDuration:0.1f animations:^{
                [button setFrame:CGRectMake(D_PlacementItemTools_Init_X,
                                            D_PlacementItemTools_Init_Y*(index+1),
                                            D_PlacementItemTools_Width,
                                            D_PlacementItemTools_Height)];
                
                index = index + 1;
            }];
        }
    }
}

#pragma mark - 內部方法
-(instancetype)init{
    self = [super init];
    if ( self ) {
        _buttonIndex = 0;
        _tempKeyWindow = [UIApplication sharedApplication].keyWindow;
        _buttonDic = [[NSMutableDictionary alloc] init];
        _buttonNormalAlpha = D_PlacementButton_NormalAlpha;
        _buttonMoveAlpha = D_PlacementButton_MoveAlpha;
        _isNeedFollow = NO;
    }
    return self;
}

-(void)dealloc{
    for ( UIButton *unit in [_buttonDic allValues] ) {
        [unit removeFromSuperview];
    }
    [_buttonDic removeAllObjects];
    _buttonDic = nil;
}

-(void)beginTouch:(UIButton *)button{
    [button setAlpha:_buttonMoveAlpha];
    button.layer.zPosition = EnumPlacementItemToolsZPosition_Top;
    
#ifdef D_PlacementItemTools_Follow
    if( _isNeedFollow ){
        // 移動其他的 point
        /*
         以一個框框為範圍縮限拉動距離， Dragged Exit 的時候再歸位就好
         */
        if ( [_buttonDic count] > 1 ) {
            
            /*
             演算法： 1~5 ，有 5 個按鈕，假設 3 被當成拖曳對象，
             則跟隨的順序會變成： 3 -> 1 -> 2 -> 4 -> 5
             ( 也就是說，當「 4 號按鈕」取出來要跟隨「 3 號按鈕」的時候，發現「 3 號按鈕」跟「拖曳的按鈕」一樣，就改成跟「 2 號按鈕」。)
             */
            
            NSUInteger index = 0;
            
            for ( PlacementUIButton *unit in _buttonArray ) {
                if ( unit != button ) {
                    if ( index == 0  ) {
                        [unit beginMoveToRootButton:(PlacementUIButton *)button];
                    }
                    else{
                        PlacementUIButton *checkButton = [_buttonArray objectAtIndex:(index - 1)];
                        if ( checkButton == button ) {
                            if ( index >= 2 ) {
                                checkButton = [_buttonArray objectAtIndex:(index - 2)];
                                [unit beginMoveToRootButton:checkButton];
                            }
                            else{
                                [unit beginMoveToRootButton:checkButton];
                            }
                        }
                        else{
                            [unit beginMoveToRootButton:checkButton];
                        }
                    }
                }
                index++;
            }
        }
    }
    
#endif
    
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    // get the touch
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    // get delta
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    // move button
    button.center = CGPointMake(button.center.x + delta_x,
                                button.center.y + delta_y);
    
#ifdef D_PlacementItemTools_Follow
    
    if( _isNeedFollow ){
        // 移動其他的 point
        /*
         以一個框框為範圍縮限拉動距離， Dragged Exit 的時候再歸位就好
         */
        if ( [_buttonDic count] > 1 ) {
            
            /*
             演算法： 1~5 ，有 5 個按鈕，假設 3 被當成拖曳對象，
             則跟隨的順序會變成： 3 -> 1 -> 2 -> 4 -> 5
             ( 也就是說，當「 4 號按鈕」取出來要跟隨「 3 號按鈕」的時候，發現「 3 號按鈕」跟「拖曳的按鈕」一樣，就改成跟「 2 號按鈕」。)
             */
            
            NSUInteger index = 0;
            
            for ( PlacementUIButton *unit in _buttonArray ) {
                if ( unit != button ) {
                    if ( index == 0  ) {
                        [unit followRootButton:(PlacementUIButton *)button];
                    }
                    else{
                        PlacementUIButton *checkButton = [_buttonArray objectAtIndex:(index - 1)];
                        if ( checkButton == button ) {
                            
                            if ( index > 1 ) {
                                checkButton = [_buttonArray objectAtIndex:(index - 2)];
                                [unit followCloselyWithButton:checkButton];
                            }
                            else{
                                [unit followRootButton:checkButton];
                            }
                            
                        }
                        else{
                            [unit followCloselyWithButton:checkButton];
                        }
                    }
                }
                index++;
            }
        }
    }
    
#endif
    
}

- (void)wasDraggedExit:(PlacementUIButton *)button
{
    button.layer.zPosition = EnumPlacementItemToolsZPosition_normal;
    
    CGPoint resultCenterPoint = CGPointMake(button.center.x,
                                            button.center.y);
    CGPoint tempCheckTouchPoint = resultCenterPoint;
    
    // 將中心點丟進類別方法，來調整其位置
    if ( button.isOnTouch == NO ) {
        resultCenterPoint = [PlacementItemTools getFixCenterPoint:resultCenterPoint];
    }
    
#ifdef D_PlacementItemTools_MoveToTop
    __weak __typeof(self) weakSelf = self;
#endif
    
    [UIView animateWithDuration:kAnimationDuration_Move animations:^{
        // move button
        button.center = resultCenterPoint;
        [button setAlpha:_buttonNormalAlpha];
        
    } completion:^(BOOL finished) {
        if ( finished ) {
            if ( tempCheckTouchPoint.x == button.center.x && tempCheckTouchPoint.y == button.center.y ) {
                
                
                
#ifdef D_PlacementItemTools_MoveToTop
                // 看狀況移動到上方
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                
                if ( strongSelf.isActive == NO ) {
                    /* 沒有任何按鈕被按到，所以所有按鈕移動到上方 */
                    strongSelf.isActive = YES;
                    button.isOnTouch = YES;
                    
                    // 依照陣列排序來排列
                    NSUInteger index = 0;
                    for ( PlacementUIButton *button in strongSelf.buttonArray ) {
                        button.originalCenter = CGPointMake(button.center.x, button.center.y);
                        [UIView animateWithDuration:kAnimationDuration_Follow animations:^{
                            button.center = CGPointMake(D_PlacementItemTools_Upper_X + D_PlacementItemTools_Width*(0.5+index),
                                                        D_PlacementItemTools_Upper_Y + D_PlacementItemTools_Height*0.5);
                        }];
                        index++;
                    }
                    
                }
                else{
                    /* 
                     有兩種可能：
                     1. 同一個按鈕被按到，所以要結束移動到上方，所有按鈕回到原位
                     2. 另一個按鈕被按到，所以要開啟另一個按鈕的狀態，然後內部其中有個按鈕要回復沒被按到的狀態
                     */
                    if ( button.isOnTouch == YES ) {
                        strongSelf.isActive = NO;
                        button.isOnTouch = NO;
                        // 依照陣列排序來排列
                        NSUInteger index = 0;
                        for ( PlacementUIButton *button in strongSelf.buttonArray ) {
                            [UIView animateWithDuration:kAnimationDuration_Follow animations:^{
                                button.center = button.originalCenter;
                            }];
                            index++;
                        }
                    }
                    else{
                        for (PlacementUIButton *unit in strongSelf.buttonArray) {
                            if ( unit.isOnTouch == YES ) {
                                unit.isOnTouch = NO;
                                break;
                            }
                        }
                        button.isOnTouch = YES;
                    }
                }
#endif
                
                // Touch
                button.pressedButtonBlock(button);
            }
        }
    }];
    
#ifdef D_PlacementItemTools_Follow
    if( _isNeedFollow ){
        // 移動其他的 point
        /*
         以一個框框為範圍縮限拉動距離， Dragged Exit 的時候再歸位就好
         */
        if ( [_buttonDic count] > 1 ) {
            
            /*
             演算法： 1~5 ，有 5 個按鈕，假設 3 被當成拖曳對象，
             則跟隨的順序會變成： 3 -> 1 -> 2 -> 4 -> 5
             ( 也就是說，當「 4 號按鈕」取出來要跟隨「 3 號按鈕」的時候，發現「 3 號按鈕」跟「拖曳的按鈕」一樣，就改成跟「 2 號按鈕」。)
             */
            
            NSUInteger index = 0;
            
            for ( PlacementUIButton *unit in _buttonArray ) {
                if ( unit != button ) {
                    if ( index == 0  ) {
                        [unit endFollowRootButton:(PlacementUIButton *)button];
                    }
                    else{
                        PlacementUIButton *checkButton = [_buttonArray objectAtIndex:(index - 1)];
                        if ( (checkButton == button) && (index > 1) ) {
                            checkButton = [_buttonArray objectAtIndex:(index - 2)];
                        }
                        [unit endFollowRootButton:checkButton];
                    }
                }
                index++;
            }
        }
    }
#endif
}

+(CGFloat)checkX:(CGFloat)recentX{
    // 如果 x 超過邊界，要回到邊界
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    CGFloat newX = recentX;
    if ( recentX < D_PlacementItemTools_Width*0.5 + D_PlacementItemTools_Margin + D_PlacementItemTools_LeftMargin ) {
        newX = D_PlacementItemTools_Width*0.5 + D_PlacementItemTools_Margin + D_PlacementItemTools_LeftMargin;
    }
    else if( recentX > mainScreenSize.width - D_PlacementItemTools_Width*0.5 - D_PlacementItemTools_Margin - D_PlacementItemTools_RightMargin ){
        newX = mainScreenSize.width - D_PlacementItemTools_Width*0.5 - D_PlacementItemTools_Margin - D_PlacementItemTools_RightMargin;
    }
    return newX;
}

+(CGFloat)checkY:(CGFloat)recentY{
    // 如果 x 超過邊界，要回到邊界
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    CGFloat newY = recentY;
    if ( recentY < D_PlacementItemTools_Height*0.5 + D_PlacementItemTools_Margin + D_PlacementItemTools_Margin*5 + D_PlacementItemTools_TopMargin ) {
        newY = D_PlacementItemTools_Height*0.5 + D_PlacementItemTools_Margin + D_PlacementItemTools_Margin*5 + D_PlacementItemTools_TopMargin;
    }
    else if( recentY > mainScreenSize.height - D_PlacementItemTools_Height*0.5 - D_PlacementItemTools_Margin - D_PlacementItemTools_BottomMargin ){
        newY = mainScreenSize.height - D_PlacementItemTools_Height*0.5 - D_PlacementItemTools_Margin - D_PlacementItemTools_BottomMargin;
    }
    return newY;
}

+(CGPoint)getFixCenterPoint:(CGPoint)originalPoint{
    CGPoint fixPoint = originalPoint;
    CGSize mainScreenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    // Y 值在 0~80 以及 400~480 的範圍（已高度 480 來算）
    if ( fixPoint.y <= D_PlacementItemTools_Edge_TopY_Height + D_PlacementItemTools_TopMargin ) {
        // 移動到最上面（ x 不動 , y 動 ）
        fixPoint.y = D_PlacementItemTools_Height*0.5 + D_PlacementItemTools_Margin + D_PlacementItemTools_TopMargin;
        
        // 如果 x 超過邊界，要回到邊界
        fixPoint.x = [PlacementItemTools checkX:fixPoint.x];
    }
    else if ( fixPoint.y >= mainScreenSize.height - D_PlacementItemTools_Edge_BottomY_Height - D_PlacementItemTools_BottomMargin ){
        // 移動到最下面（ x 不動 , y 動 ）
        fixPoint.y = mainScreenSize.height - D_PlacementItemTools_Height*0.5 - D_PlacementItemTools_Margin - D_PlacementItemTools_BottomMargin;
        
        // 如果 x 超過邊界，要回到邊界
        fixPoint.x = [PlacementItemTools checkX:originalPoint.x];
    }
    else{
        if ( fixPoint.x > mainScreenSize.width*0.5 ) {
            // 移動到最右邊（ x 動 , y 不動 ）
            fixPoint.x = mainScreenSize.width - D_PlacementItemTools_Width*0.5 - D_PlacementItemTools_Margin - D_PlacementItemTools_RightMargin;
        }
        else{
            // 移動到最左邊（ x 動 , y 不動 ）
            fixPoint.x = D_PlacementItemTools_Width*0.5 + D_PlacementItemTools_Margin + D_PlacementItemTools_LeftMargin;
        }
        
        fixPoint.y = [PlacementItemTools checkY:fixPoint.y];
        
    }
    
    return fixPoint;
}

#pragma mark - SafeArea
+(UIEdgeInsets)getSafeAreaInsets{
    UIEdgeInsets safeInsets;
    UIWindow *_keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if ( @available( iOS 11.0 , * ) ) {
        safeInsets = _keyWindow.safeAreaInsets;
    } else {
        safeInsets = _keyWindow.alignmentRectInsets;
    }
    return safeInsets;
}

+(CGRect)getSafeAreaFrame{
    CGRect safeFrame;
    UIWindow *_keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if ( @available( iOS 11.0 , * ) ) {
        safeFrame = UIEdgeInsetsInsetRect([UIScreen mainScreen].bounds, _keyWindow.safeAreaInsets);
    } else {
        safeFrame = [UIScreen mainScreen].bounds;
    }
    return safeFrame;
}

@end
