//
//  PlacementItemTools+Badget.m
//  App
//
//  Created by Coody on 2016/4/1.
//  Copyright © 2016年 SGT. All rights reserved.
//

#import "PlacementItemTools+Badget.h"

// for Tools
#import <UIKit/UIKit.h>

static CGFloat const K_PlacemntItemTools_Badget_AnimationDuration = 0.1f;
static NSUInteger const K_PlacemntItemTools_Badget_MaxCount = 99;

#define K_PlacemntItemTools_Badget_Small [UIFont boldSystemFontOfSize:14]
#define K_PlacemntItemTools_Badget_Big [UIFont boldSystemFontOfSize:16]


/********************/
// Dynamic property
#include <objc/runtime.h>

#define Category_Property_Get_Macro(type, property) \
/* */ - (type) property \
/* */ {\
/* */   return objc_getAssociatedObject(self, @selector(property));\
/* */ }

#define Category_Property_Set_Macro(type, property, setter, associationFlag) \
/* */ - (void) setter (type) property \
/* */ { \
/* */   objc_setAssociatedObject(self, @selector(property), property, associationFlag);\
/* */ }

#define Category_Property_Get_Set_RetainNonatomic_Macro(type, property, setter) \
/* */ Category_Property_Get_Macro(type, property) \
/* */ Category_Property_Set_Macro(type, property, setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
/********************/


#pragma mark - BadgetObject
@interface BadgetView : UIImageView
{
    NSUInteger _badgetTag;
}
@property (nonatomic , assign) BOOL showBadget;
@property (nonatomic , strong) UIImage *badgetImage;
@property (nonatomic , strong) UILabel *badgetLabel;
@end

@implementation BadgetView

-(instancetype)initWithAppendedView:(UIView *)tempView{
    self = [super init];
    if ( self ) {
        _showBadget = YES;
        _badgetTag = tempView.tag;
        
        if ( _badgetImage == nil ) {
            _badgetImage = [UIImage imageNamed:@"redCircle"];
        }
        
        if ( _badgetLabel == nil ) {
            _badgetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                     _badgetImage.size.width,
                                                                     _badgetImage.size.height)];
            [_badgetLabel setText:@"0"];
            [_badgetLabel setBackgroundColor:[UIColor clearColor]];
            [_badgetLabel setTextColor:[UIColor whiteColor]];
            [_badgetLabel setFont:K_PlacemntItemTools_Badget_Small];
            [_badgetLabel setTextAlignment:(NSTextAlignmentCenter)];
        }
        
        [self setFrame:CGRectMake(tempView.frame.size.width - _badgetImage.size.width,
                                  _badgetImage.size.height*-0.5,
                                  _badgetImage.size.width,
                                  _badgetImage.size.height)];
        [self setImage:_badgetImage];
        [self addSubview:_badgetLabel];
    }
    return self;
}

-(void)setBadgetNumber:(NSUInteger)tempBadgetNumber{
    
    if ( tempBadgetNumber >= NSIntegerMax ) {
        NSLog(@"Set badget number error!!");
        return;
    }
    
    NSString *showBadgetString = @"0";
    if ( tempBadgetNumber > K_PlacemntItemTools_Badget_MaxCount ) {
        showBadgetString = @"N";
    }
    else{
        showBadgetString = [NSString stringWithFormat:@"%lu" , (unsigned long)tempBadgetNumber];
    }
    
    [_badgetLabel setText:showBadgetString];
    
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:K_PlacemntItemTools_Badget_AnimationDuration 
                     animations:^{
                         __strong __typeof(weakSelf) strongSelf = weakSelf;
                         [strongSelf setFrame:CGRectMake(strongSelf.frame.origin.x-2,
                                                         strongSelf.frame.origin.y-4,
                                                         strongSelf.frame.size.width+4,
                                                         strongSelf.frame.size.height+4)];
                         [strongSelf.badgetLabel setFont:K_PlacemntItemTools_Badget_Big];
                         [strongSelf.badgetLabel setFrame:CGRectMake(self.badgetLabel.frame.origin.x + 2,
                                                                     self.badgetLabel.frame.origin.y + 2,
                                                                     self.badgetLabel.frame.size.width,
                                                                     self.badgetLabel.frame.size.height)];
                         
                     } completion:^(BOOL finished) {
                         __strong __typeof(weakSelf) strongSelf = weakSelf;
                         [strongSelf endAnimation];
                     }];
}

-(void)endAnimation{
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:K_PlacemntItemTools_Badget_AnimationDuration 
                     animations:^{
                         __strong __typeof(weakSelf) strongSelf = weakSelf;
                         [strongSelf setFrame:CGRectMake(strongSelf.frame.origin.x+2,
                                                         strongSelf.frame.origin.y+4,
                                                         strongSelf.frame.size.width-4,
                                                         strongSelf.frame.size.height-4)];
                         [strongSelf.badgetLabel setFont:K_PlacemntItemTools_Badget_Small];
                         [strongSelf.badgetLabel setFrame:CGRectMake(self.badgetLabel.frame.origin.x - 2,
                                                                     self.badgetLabel.frame.origin.y - 2,
                                                                     self.badgetLabel.frame.size.width,
                                                                     self.badgetLabel.frame.size.height)];
                     }];
}

-(NSUInteger)getBadgetNumber{
    NSUInteger showBadgetNumber = (NSUInteger)[self.badgetLabel.text integerValue];
    return showBadgetNumber;
}

-(void)clean{
    _badgetTag = 0;
    _showBadget = NO;
    _badgetImage = nil;
    [_badgetLabel removeFromSuperview];
    _badgetLabel = nil;
}

-(void)setShowBadget:(BOOL)showBadget{
    _showBadget = showBadget;
    [self setHidden:!_showBadget];
}

@end


#pragma mark - Category
@implementation PlacementItemTools (Badget)

// 內部
Category_Property_Get_Set_RetainNonatomic_Macro(NSMutableDictionary*, badgetDic, setBadgetDic:)

-(void)createBadgetWithAppendedView:(UIView *)tempView{
    if ( self.badgetDic == nil ) {
        self.badgetDic = [[NSMutableDictionary alloc] init];
    }
    if ( [self.badgetDic objectForKey:@(tempView.tag)] ) {
        // 有 badget 的話就不處理
    }
    else{
        // 沒有 badget 建立一個，並且加入
        BadgetView *badgetView = [[BadgetView alloc] initWithAppendedView:tempView];
        [self.badgetDic setObject:badgetView forKey:@(tempView.tag)];
        [tempView addSubview:badgetView];
        [tempView bringSubviewToFront:badgetView];
    }
}

-(void)setBadgetNumber:(NSUInteger)tempBadgetNumber withTag:(NSUInteger)tempTag{
    
    BadgetView *badgetView = [self.badgetDic objectForKey:@(tempTag)];
    
    if ( badgetView == nil ) {
        NSLog(@"Set badget number error!!");
        return;
    }    
    [badgetView setBadgetNumber:tempBadgetNumber];
}

-(NSUInteger)getBadgetNumberWithTag:(NSUInteger)tempTag{
    BadgetView *badgetView = [self.badgetDic objectForKey:@(tempTag)];
    NSUInteger number = 0;
    if ( badgetView != nil ) {
        number = [badgetView getBadgetNumber];
    }
    return number;
}

-(void)cleanAllBudgets{
    for ( BadgetView *unit in [self.badgetDic allValues] ) {
        [unit clean];
    }
}


-(void)cleanBadgetWithTag:(NSUInteger)tempTag{
    BadgetView *badgetView = [self.badgetDic objectForKey:@(tempTag)];
    if ( badgetView == nil ) {
        
    }
    else{
        [badgetView clean];
    }
}

-(void)setShowBadget:(BOOL)isShow withTag:(NSUInteger)tempTag{
    BadgetView *badgetView = [self.badgetDic objectForKey:@(tempTag)];
    badgetView.showBadget = isShow;
}

@end
