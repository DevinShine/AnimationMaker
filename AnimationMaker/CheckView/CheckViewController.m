//
//  CheckViewController.m
//  AnimationMaker
//
//  Created by DevinShine on 16/9/1.
//  Copyright © 2016年 DevinShine. All rights reserved.
//

#import "CheckViewController.h"
#import "CheckView.h"

@interface CheckViewController ()
@property (weak, nonatomic) IBOutlet CheckView *checkView;

@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startAction:(id)sender {
    [self.checkView addCheckAnimationAnimation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
