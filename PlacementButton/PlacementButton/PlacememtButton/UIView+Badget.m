//
//  PlacementItemTools+Badget.m
//  App
//
//  Created by Coody on 2016/4/1.
//  Copyright © 2016年 SGT. All rights reserved.
//

// for Append Function
#import "UIView+Badget.h"
#include <objc/runtime.h>

static CGFloat const K_Badget_AnimationDuration = 0.1f;
static NSUInteger const K_Badget_MaxCount = 99;
static CGFloat const K_Badget_AnimationScaleMargin = 4;

#define K_Badget_Small [UIFont boldSystemFontOfSize:13]
#define K_Badget_Big [UIFont boldSystemFontOfSize:16]


#pragma mark - BadgetObject
@interface BadgetView : UIImageView
{
    NSUInteger _badgetTag;
}
@property (nonatomic , assign) BOOL showBadget;
@property (nonatomic , assign) BOOL hasBadgetAnimation;
@property (nonatomic , strong) UIImage *badgetImage;
@property (nonatomic , strong) UILabel *badgetLabel;
@end

@implementation BadgetView

-(instancetype)initWithAppendedView:(UIView *)tempView{
    self = [super init];
    if ( self ) {
        _showBadget = YES;
        _badgetTag = tempView.tag;
        _hasBadgetAnimation = YES;
        [self setAlpha:0.9f];
        
        if ( _badgetImage == nil ) {
            _badgetImage = [UIImage imageNamed:@"redCircle.png"];
        }
        
        if ( _badgetLabel == nil ) {
            _badgetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                     _badgetImage.size.width,
                                                                     _badgetImage.size.height)];
            [_badgetLabel setBackgroundColor:[UIColor clearColor]];
            [_badgetLabel setTextColor:[UIColor whiteColor]];
            [_badgetLabel setFont:K_Badget_Small];
            [_badgetLabel setTextAlignment:(NSTextAlignmentCenter)];
            [_badgetLabel setText:@"0"];
        }
        
        [self setFrame:CGRectMake(tempView.frame.size.width - _badgetImage.size.width*0.5,
                                  _badgetImage.size.width*-0.5,
                                  _badgetImage.size.width,
                                  _badgetImage.size.height)];
        [self setImage:_badgetImage];
        [self addSubview:_badgetLabel];
        
        [self.layer addSublayer:_badgetLabel.layer];
    }
    return self;
}

-(void)setBadgetNumber:(NSUInteger)tempBadgetNumber{
    
    [self setBadgetNumberWithoutAnimation:tempBadgetNumber];
    
    if ( _hasBadgetAnimation ) {
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:K_Badget_AnimationDuration 
                         animations:^{
                             __strong __typeof(weakSelf) strongSelf = weakSelf;
                             [strongSelf setFrame:CGRectMake(strongSelf.frame.origin.x-K_Badget_AnimationScaleMargin,
                                                             strongSelf.frame.origin.y-K_Badget_AnimationScaleMargin*2,
                                                             strongSelf.frame.size.width+K_Badget_AnimationScaleMargin*2,
                                                             strongSelf.frame.size.height+K_Badget_AnimationScaleMargin*2)];
                             [strongSelf.badgetLabel setFont:K_Badget_Big];
                             [strongSelf.badgetLabel setFrame:CGRectMake(strongSelf.badgetLabel.frame.origin.x + K_Badget_AnimationScaleMargin,
                                                                         strongSelf.badgetLabel.frame.origin.y + K_Badget_AnimationScaleMargin,
                                                                         strongSelf.badgetLabel.frame.size.width,
                                                                         strongSelf.badgetLabel.frame.size.height)];
                             
                         } completion:^(BOOL finished) {
                             __strong __typeof(weakSelf) strongSelf = weakSelf;
                             [strongSelf endAnimation];
                         }];
    }
    
}

-(void)setBadgetNumberWithoutAnimation:(NSUInteger)tempBadgetNumber{
    if ( tempBadgetNumber >= NSIntegerMax ) {
        NSLog(@"Set badget number error!!");
        return;
    }
    
    NSString *showBadgetString = @"0";
    if ( tempBadgetNumber > K_Badget_MaxCount ) {
        showBadgetString = @"N";
    }
    else{
        showBadgetString = [NSString stringWithFormat:@"%lu" , (unsigned long)tempBadgetNumber];
    }
    
    [_badgetLabel setText:showBadgetString];
}


-(void)endAnimation{
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:K_Badget_AnimationDuration 
                     animations:^{
                         __strong __typeof(weakSelf) strongSelf = weakSelf;
                         [strongSelf setFrame:CGRectMake(strongSelf.frame.origin.x+K_Badget_AnimationScaleMargin,
                                                         strongSelf.frame.origin.y+K_Badget_AnimationScaleMargin*2,
                                                         strongSelf.frame.size.width-K_Badget_AnimationScaleMargin*2,
                                                         strongSelf.frame.size.height-K_Badget_AnimationScaleMargin*2)];
                         [strongSelf.badgetLabel setFont:K_Badget_Small];
                         [strongSelf.badgetLabel setFrame:CGRectMake(strongSelf.badgetLabel.frame.origin.x - K_Badget_AnimationScaleMargin,
                                                                     strongSelf.badgetLabel.frame.origin.y - K_Badget_AnimationScaleMargin,
                                                                     strongSelf.badgetLabel.frame.size.width,
                                                                     strongSelf.badgetLabel.frame.size.height)];
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
@implementation UIView (Badget)

// runtime dynamic property
- (BadgetView *)badgetView 
{
    return objc_getAssociatedObject(self, @selector(badgetView));
}

- (void) setBadgetView:(BadgetView *)badgetView
{
    objc_setAssociatedObject(self, @selector(badgetView), badgetView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//Category_Property_Get_Set_RetainNonatomic_Macro(BadgetView*, badgetView, setBadgetView:)

-(void)createBadget{
    if ( self.badgetView == nil ) {
        self.badgetView = [[BadgetView alloc] initWithAppendedView:self];
        [self addSubview:self.badgetView];
    }
    else{
        NSLog(@"UIVIew's badget is Already exists !!");
    }
}

-(void)setBadgetPosition:(CGPoint)tempPoint{
    [self.badgetView setFrame:CGRectMake(tempPoint.x,
                                         tempPoint.y,
                                         self.badgetView.frame.size.width,
                                         self.badgetView.frame.size.height)];
}

-(void)setBadgetAnimation:(BOOL)isNeedAnimation{
    self.badgetView.hasBadgetAnimation = isNeedAnimation;
}

-(void)setBadgetNumber:(NSUInteger)tempBadgetNumber{
    
    if ( self.badgetView == nil ) {
        NSLog(@"Set badget number error!!(Because badget view isn't exist.)");
    }    
    else{
        [self.badgetView setBadgetNumber:tempBadgetNumber];
    }
}

-(void)setBadgetNumberWithoutAnimation:(NSUInteger)tempBadgetNumber{
    if ( self.badgetView == nil ) {
        NSLog(@"Set badget number error!!(Because badget view isn't exist.)");
    }    
    else{
        [self.badgetView setBadgetNumberWithoutAnimation:tempBadgetNumber];
    }
}

-(NSUInteger)getBadgetNumber{
    NSUInteger number = 0;
    if ( self.badgetView != nil ) {
        number = [self.badgetView getBadgetNumber];
    }
    return number;
}

-(void)cleanBadget{
    if ( self.badgetView == nil ) {
        
    }
    else{
        [self.badgetView clean];
    }
}

-(void)setShowBadget:(BOOL)isShow{
    self.badgetView.showBadget = isShow;
}

@end
