//
//  PlacementItemTools.h
//
//  Created by Coody on 2016/2/3.
//

#import <UIKit/UIKit.h>

extern NSUInteger const kPlacementItemTools_Max_Button_Count;

typedef enum : NSInteger{
    EnumPlacementItemToolsZPosition_Activity = 200,
    EnumPlacementItemToolsZPosition_normal = 500,
    EnumPlacementItemToolsZPosition_Top = 1000
}EnumPlacementItemToolsZPosition;

// 圖片大小
#define D_PlacementItemTools_Width (50)
#define D_PlacementItemTools_Height D_PlacementItemTools_Width

// 按鈕移到上方後的起始位置
#define D_PlacementItemTools_Upper_X (D_PlacementItemTools_Width)
#define D_PlacementItemTools_Upper_Y (D_PlacementItemTools_Height*0.5)

// 動畫時間
/** 目前拖拉按鈕放開後，回到邊緣的速度 */
extern float const kAnimationDuration_Move;
/** 跟隨的按鈕在拖拉按鈕放開後，回到邊緣的速度（建議慢一點點，會有跟隨移動的感覺） */
extern float const kAnimationDuration_Follow;

@interface PlacementItemTools : NSObject
{
    UIWindow *_tempKeyWindow;
}
@property (nonatomic , assign) BOOL isNeedFollow;
#pragma mark - Shared Instance
+(instancetype)sharedInstance;

#pragma mark - 建立動態按鈕
/**
 * @brief   - 建立一個動態按鈕
 * @details - 動態按鈕會以 Tag 的方式產生， Tag 請勿重複
 */
-(void)createButtonWithNormalImage:(UIImage *)normalImage
               withHightLightImage:(UIImage *)hightLightImage
                           withTag:(NSInteger)tempTag
                     withDoneBlock:(void(^)(UIButton *responseButton))tempDoneBlock
                  WithPressedBlock:(void(^)(UIButton *responseButton))tempPressedButtonBlock;

/** 設定按鈕不動的時候，按鈕的 Alpha */
-(void)setButtonNormalAlpha:(CGFloat)buttonNormalAlpha;

/** 設定按鈕移動的時候，按鈕的 Alpha */
-(void)setButtonMoveAlpha:(CGFloat)buttonMoveAlpha;

/**
 * @brief - 隱藏/顯示所有動態按鈕
 */
-(void)setHidden:(BOOL)isHidden;

/**
 * @brief   - 取得指定 Tag 的 button
 * @warning - 
 */
-(UIButton *)getButtonWithTag:(NSUInteger)tempTag;

/**
 * @brief - 移除全部動態按鈕
 */
-(void)removeAllButtons;

/**
 * @brief - 移除指定 tag 的 button
 */
-(BOOL)removeButtonWithTag:(NSInteger)tempTag;

/**
 * @brief - 將按鈕都推到最前面
 */
-(void)bringButtonToFront;

/**
 *  重新設定 button 的位置
 */
-(void)resetButtonPosition;

@end
