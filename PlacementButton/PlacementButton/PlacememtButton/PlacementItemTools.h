//
//  PlacementItemTools.h
//
//  Created by Coody on 2016/2/3.
//

#import <Foundation/Foundation.h>

@class UIButton;

@interface PlacementItemTools : NSObject

#pragma mark - Shared Instance
+(instancetype)sharedInstance;

#pragma mark - 建立動態按鈕

/**
 * @brief - 建立一個動態按鈕
 * 
 */
-(void)createButtonWithPressedBlock:(void(^)(UIButton *responseButton))tempPressedButtonBlock;

/**
 * @brief - 隱藏/顯示所有動態按鈕
 */
-(void)setHidden:(BOOL)isHidden;

/**
 * @brief - 移除全部動態按鈕
 */
-(void)removeButtons;

@end
