//
//  PlacementItemTools+Badget.h
//  App
//
//  Created by Coody on 2016/4/1.
//  Copyright © 2016年 SGT. All rights reserved.
//

#import "PlacementItemTools.h"

@class UIView;

@interface PlacementItemTools (Badget)

/**
 * @brief - 給定要貼付的 View ，讓 Badget 靠齊右上角
 */
-(void)createBadgetWithAppendedView:(UIView *)tempView;

/**
 * @brief - 設定 badget 數量
 */
-(void)setBadgetNumber:(NSUInteger)tempBadgetNumber withTag:(NSUInteger)tempTag;

/**
 * @brief - 取得 Badget 數量( NSUInteger ) 
 */
-(NSUInteger)getBadgetNumberWithTag:(NSUInteger)tempTag;

/**
 * @brief - 清除 Badget 相關設定
 */
-(void)cleanAllBudgets;
-(void)cleanBadgetWithTag:(NSUInteger)tempTag;

/**
 * @brief - 設定某個 badget 顯示狀態（如果有的話）
 */
-(void)setShowBadget:(BOOL)isShow withTag:(NSUInteger)tempTag;

@end
