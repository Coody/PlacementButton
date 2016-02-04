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
@end

@implementation PlacementUIButton
@end


#pragma mark - PlacementItemTools
@interface PlacementItemTools()
{
    UIWindow *_tempKeyWindow;
    CGSize _mainScreenSize;
}
@property (nonatomic , assign) NSInteger buttonIndex;
@property (nonatomic , strong) NSMutableDictionary *buttonDic;

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

-(void)removeButtons{
    for ( PlacementUIButton *button in _buttonDic ) {
        [button removeFromSuperview];
        button.pressedButtonBlock = nil;
    }
    [_buttonDic removeAllObjects];
}

#pragma mark - 內部方法
-(instancetype)init{
    self = [super init];
    if ( self ) {
        _buttonIndex = 0;
        _tempKeyWindow = [UIApplication sharedApplication].keyWindow;
        _buttonDic = [[NSMutableDictionary alloc] init];
        _mainScreenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    return self;
}

-(void)createButtonWithPressedBlock:(void(^)(UIButton *responseButton))tempPressedButtonBlock
{
    _buttonIndex = _buttonIndex + 1;
    
    PlacementUIButton *button = [[PlacementUIButton alloc] initWithFrame:CGRectMake(D_PlacementItemTools_Init_X, 
                                                                                    D_PlacementItemTools_Init_Y, 
                                                                                    D_PlacementItemTools_Width, 
                                                                                    D_PlacementItemTools_Width)];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    button.pressedButtonBlock = tempPressedButtonBlock;
    button.layer.cornerRadius = 10.0f;
    button.layer.masksToBounds = YES;
    [button setAlpha:0.6f];
    [button addTarget:self action:@selector(beginTouch:) forControlEvents:(UIControlEventTouchDown)];
    [button addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:(UIControlEventTouchDragInside)];
    [button addTarget:self action:@selector(wasDraggedExit:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [_tempKeyWindow addSubview:button];
    
    [_buttonDic setObject:button forKey:@(_buttonIndex)];
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
}

- (void)wasDraggedExit:(PlacementUIButton *)button
{
    
    CGPoint resultCenterPoint = CGPointMake(button.center.x,
                                            button.center.y);
    CGPoint tempCheckTouchPoint = resultCenterPoint;
    
    // Y 值在 0~80 以及 400~480 的範圍（已高度 480 來算）
    if ( resultCenterPoint.y <= D_PlacementItemTools_Edge_TopY_Height) {
        // 移動到最上面（ x 不動 , y 動 ）
        resultCenterPoint.y = D_PlacementItemTools_Height*0.5 + D_PlacementItemTools_Margin;
        
        // 如果 x 超過邊界，要回到邊界
        resultCenterPoint.x = [self checkX:resultCenterPoint.x];
    }
    else if ( resultCenterPoint.y >= _mainScreenSize.height - D_PlacementItemTools_Edge_BottomY_Height ){
        // 移動到最下面（ x 不動 , y 動 ）
        resultCenterPoint.y = _mainScreenSize.height - D_PlacementItemTools_Height*0.5 - D_PlacementItemTools_Margin;
        
        // 如果 x 超過邊界，要回到邊界
        resultCenterPoint.x = [self checkX:resultCenterPoint.x];
    }
    else{
        if ( resultCenterPoint.x > _mainScreenSize.width*0.5 ) {
            // 移動到最右邊（ x 動 , y 不動 ）
            resultCenterPoint.x = _mainScreenSize.width - D_PlacementItemTools_Width*0.5 - D_PlacementItemTools_Margin;
        }
        else{
            // 移動到最左邊（ x 動 , y 不動 ）
            resultCenterPoint.x = D_PlacementItemTools_Width*0.5 + D_PlacementItemTools_Margin;
        }
    }
    
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
}

-(CGFloat)checkX:(CGFloat)recentX{
    // 如果 x 超過邊界，要回到邊界
    CGFloat newX = 0.0f;
    if ( recentX < D_PlacementItemTools_Width*0.5 + D_PlacementItemTools_Margin ) {
        newX = D_PlacementItemTools_Width*0.5 + D_PlacementItemTools_Margin;
    }
    else if( recentX > _mainScreenSize.width - D_PlacementItemTools_Width*0.5 - D_PlacementItemTools_Margin ){
        newX = _mainScreenSize.width - D_PlacementItemTools_Width*0.5 - D_PlacementItemTools_Margin;
    }
    return newX;
}


@end
