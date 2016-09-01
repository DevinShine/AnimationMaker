//
//  ViewController.m
//  AnimationMaker
//
//  Created by DevinShine on 16/8/23.
//  Copyright © 2016年 DevinShine. All rights reserved.
//

#import "ViewController.h"
#import "AnimationDemoController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AnimationDemoController *vc = [AnimationDemoController new];
    [self pushViewController:vc animated:NO];
    
}
@end
