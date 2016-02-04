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

-(void)createButtonWithPressedBlock:(void(^)(UIButton *responseButton))tempPressedButtonBlock;

-(void)setHidden:(BOOL)isHidden;

-(void)removeButtons;

@end
