//
//  PlacementItemTools.h
//
//  Created by Coody on 2016/2/3.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class UIButton;

extern NSUInteger const kPlacementItemTools_Max_Button_Count;

@interface PlacementItemTools : NSObject

#pragma mark - Shared Instance
+(instancetype)sharedInstance;

#pragma mark - 建立動態按鈕

/**
 * @brief   - 建立一個動態按鈕
 * @details - 動態按鈕會以 Tag 的方式產生， Tag 由 1 開始，每次產生完下一個就會累加 1
 */
-(void)createButtonWithNormalImage:(UIImage *)normalImage 
               withHightLightImage:(UIImage *)hightLightImage 
                  WithPressedBlock:(void(^)(UIButton *responseButton))tempPressedButtonBlock;

/**
 * @brief - 隱藏/顯示所有動態按鈕
 */
-(void)setHidden:(BOOL)isHidden;

/**
 * @brief   - 取得指定 Tag 的 button
 * @warning - Tag 編號從 1 開始， 1,2,3 ...
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

@end
