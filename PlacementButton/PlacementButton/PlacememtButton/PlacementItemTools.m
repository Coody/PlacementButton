//
//  PlacementItemTools.m
//
//  Created by Coody on 2016/2/3.
//

#import "PlacementItemTools.h"
#import <UIKit/UIKit.h>

// 會貼牆壁的範圍
#define D_PlacementItemTools_Edge_TopY_Height (100)
#define D_PlacementItemTools_Edge_BottomY_Height D_PlacementItemTools_Edge_TopY_Height
/*
 說明：
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

// 離牆壁的微小距離
#define D_PlacementItemTools_Margin (2)

// 圖片大小
#define D_PlacementItemTools_Width (50)
#define D_PlacementItemTools_Height D_PlacementItemTools_Width

// 按鈕起始位置
#define D_PlacementItemTools_Init_X ([UIScreen mainScreen].bounds.size.width - D_PlacementItemTools_Width - D_PlacementItemTools_Margin)
#define D_PlacementItemTools_Init_Y (D_PlacementItemTools_Height*2)

#pragma mark - Private UIButton
@interface PlacementUIButton : UIButton
@property (nonatomic , copy) void(^pressedButtonBlock)(UIButton *);
-(void)followRootButton:(PlacementUIButton *)rootButton;
-(void)endFollowRootButton:(PlacementUIButton *)rootButton;
-(void)followCloselyWithButton:(PlacementUIButton *)rootButton;
-(CGPoint)getEndCenterPoint:(CGPoint)targetCenterPoint;
@end

@implementation PlacementUIButton
#pragma mark - 按鈕移動
-(void)followRootButton:(PlacementUIButton *)rootButton{
    CGFloat newX = self.center.x;
    CGFloat newY = self.center.y;
    CGFloat checkMaxX = rootButton.center.x + (D_PlacementItemTools_Width + 10);
    CGFloat checkMinX = rootButton.center.x - (D_PlacementItemTools_Width + 10);
    CGFloat checkMaxY = rootButton.center.y + (D_PlacementItemTools_Height + 10);
    CGFloat checkMinY = rootButton.center.y - (D_PlacementItemTools_Height + 10);
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
    [UIView animateWithDuration:0.5f animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.center = [strongSelf getEndCenterPoint:rootButton.center];
    }];
}

-(void)followCloselyWithButton:(PlacementUIButton *)rootButton{
    
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
            fixX = targetCenterPoint.x - D_PlacementItemTools_Width - D_PlacementItemTools_Width;
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
{
    UIWindow *_tempKeyWindow;
}
@property (nonatomic , assign) NSInteger buttonIndex;
@property (nonatomic , strong) NSMutableDictionary *buttonDic;
@property (nonatomic , strong) NSArray *buttonArray;
@end

@implementation PlacementItemTools

#pragma mark - 開放方法
+(instancetype)sharedInstance{
    static PlacementItemTools *sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if ( sharedInstance == nil ) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

-(void)setHidden:(BOOL)isHidden{
    for ( PlacementUIButton *button in _buttonDic ) {
        [button setHidden:isHidden];
    }
}

-(void)removeAllButtons{
    for ( PlacementUIButton *button in _buttonDic ) {
        [button removeFromSuperview];
        button.pressedButtonBlock = nil;
    }
    [_buttonDic removeAllObjects];
}

-(BOOL)removeButtonWithTag:(NSInteger)tempTag{
    BOOL isSuccess = NO;
    PlacementUIButton *button = [_buttonDic objectForKey:@(tempTag)];
    if ( button != nil ) {
        [_buttonDic removeObjectForKey:@(tempTag)];
        [button removeFromSuperview];
        button.pressedButtonBlock = nil;
        button = nil;
        isSuccess = YES;
    }
    return isSuccess;
}

#pragma mark - 內部方法
-(instancetype)init{
    self = [super init];
    if ( self ) {
        _buttonIndex = 0;
        _tempKeyWindow = [UIApplication sharedApplication].keyWindow;
        _buttonDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)createButtonWithPressedBlock:(void(^)(UIButton *responseButton))tempPressedButtonBlock
{
    if ( [_buttonArray count] >= 2 ) {
        return;
    }
    _buttonIndex = _buttonIndex + 1;
    
    PlacementUIButton *button;
    if ( _buttonIndex == 0 ) {
        button = [[PlacementUIButton alloc] initWithFrame:CGRectMake(D_PlacementItemTools_Init_X, 
                                                                     D_PlacementItemTools_Init_Y, 
                                                                     D_PlacementItemTools_Width, 
                                                                     D_PlacementItemTools_Height)];
    }
    else{
        UIButton *latestButton = [_buttonDic objectForKey:@(_buttonIndex - 1)];
        button = [[PlacementUIButton alloc] initWithFrame:CGRectMake(latestButton.frame.origin.x, 
                                                                     latestButton.frame.origin.y + latestButton.frame.size.height + 10 , 
                                                                     D_PlacementItemTools_Width, 
                                                                     D_PlacementItemTools_Height)];
    }
    
    [button setBackgroundColor:[UIColor lightGrayColor]];
    button.tag = _buttonIndex;
    button.pressedButtonBlock = tempPressedButtonBlock;
    button.layer.cornerRadius = 10.0f;
    button.layer.masksToBounds = YES;
    [button setAlpha:0.6f];
    [button addTarget:self action:@selector(beginTouch:) forControlEvents:(UIControlEventTouchDown)];
    [button addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:(UIControlEventTouchDragInside)];
    [button addTarget:self action:@selector(wasDraggedExit:) forControlEvents:(UIControlEventTouchUpInside)];
    [button addTarget:self action:@selector(wasDraggedExit:) forControlEvents:(UIControlEventTouchUpOutside)];
    
    [_tempKeyWindow addSubview:button];
    
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
}

-(void)beginTouch:(UIButton *)button{
    [button setAlpha:1.0f];
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
                    if ( checkButton == button  && index > 1 ) {
                        checkButton = [_buttonArray objectAtIndex:(index - 2)];
                    }
                    [unit followRootButton:checkButton];
                }
            }
            index++;
        }
    }
}

- (void)wasDraggedExit:(PlacementUIButton *)button
{
    
    CGPoint resultCenterPoint = CGPointMake(button.center.x,
                                            button.center.y);
    CGPoint tempCheckTouchPoint = resultCenterPoint;
    
    // 將中心點丟進類別方法，來調整其位置
    resultCenterPoint = [PlacementItemTools getFixCenterPoint:resultCenterPoint];
    
    [UIView animateWithDuration:0.25f animations:^{
        // move button
        button.center = resultCenterPoint;
        [button setAlpha:0.6f];
    } completion:^(BOOL finished) {
        if ( finished ) {
            if ( tempCheckTouchPoint.x == button.center.x && tempCheckTouchPoint.y == button.center.y ) {
                // Touch
                button.pressedButtonBlock(button);
            }
        }
    }];
    
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
                    if ( checkButton == button  && index > 1 ) {
                        checkButton = [_buttonArray objectAtIndex:(index - 2)];
                    }
                    [unit endFollowRootButton:checkButton];
                }
            }
            index++;
        }
    }
}

+(CGFloat)checkX:(CGFloat)recentX{
    // 如果 x 超過邊界，要回到邊界
    CGSize mainScreenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat newX = recentX;
    if ( recentX < D_PlacementItemTools_Width*0.5 + D_PlacementItemTools_Margin ) {
        newX = D_PlacementItemTools_Width*0.5 + D_PlacementItemTools_Margin;
    }
    else if( recentX > mainScreenSize.width - D_PlacementItemTools_Width*0.5 - D_PlacementItemTools_Margin ){
        newX = mainScreenSize.width - D_PlacementItemTools_Width*0.5 - D_PlacementItemTools_Margin;
    }
    return newX;
}

+(CGPoint)getFixCenterPoint:(CGPoint)originalPoint{
    CGPoint fixPoint = originalPoint;
    CGSize mainScreenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    // Y 值在 0~80 以及 400~480 的範圍（已高度 480 來算）
    if ( fixPoint.y <= D_PlacementItemTools_Edge_TopY_Height) {
        // 移動到最上面（ x 不動 , y 動 ）
        fixPoint.y = D_PlacementItemTools_Height*0.5 + D_PlacementItemTools_Margin;
        
        // 如果 x 超過邊界，要回到邊界
        fixPoint.x = [PlacementItemTools checkX:fixPoint.x];
    }
    else if ( fixPoint.y >= mainScreenSize.height - D_PlacementItemTools_Edge_BottomY_Height ){
        // 移動到最下面（ x 不動 , y 動 ）
        fixPoint.y = mainScreenSize.height - D_PlacementItemTools_Height*0.5 - D_PlacementItemTools_Margin;
        
        // 如果 x 超過邊界，要回到邊界
        fixPoint.x = [self checkX:originalPoint.x];
    }
    else{
        if ( fixPoint.x > mainScreenSize.width*0.5 ) {
            // 移動到最右邊（ x 動 , y 不動 ）
            fixPoint.x = mainScreenSize.width - D_PlacementItemTools_Width*0.5 - D_PlacementItemTools_Margin;
        }
        else{
            // 移動到最左邊（ x 動 , y 不動 ）
            fixPoint.x = D_PlacementItemTools_Width*0.5 + D_PlacementItemTools_Margin;
        }
    }
    
    return fixPoint;
}

@end
