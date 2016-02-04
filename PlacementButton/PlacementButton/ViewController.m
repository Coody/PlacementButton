//
//  ViewController.m
//  PlacementButton
//
//  Created by Coody on 2016/2/4.
//  Copyright © 2016年 Coody. All rights reserved.
//

#import "ViewController.h"

#import "PlacementItemTools.h"

@interface ViewController ()
@property (nonatomic , strong) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[PlacementItemTools sharedInstance] createButtonWithPressedBlock:^(UIButton *responseButton) {
        NSLog(@"按下！");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
