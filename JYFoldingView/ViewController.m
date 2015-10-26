//
//  ViewController.m
//  JYFoldingView
//
//  Created by joyann on 15/10/26.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "JYFoldingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self addFoldingView];
}

#pragma mark - Add Folding View

- (void)addFoldingView
{
    JYFoldingView *foldingView = [[JYFoldingView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    foldingView.center = self.view.center;
    [self.view addSubview:foldingView];
}


@end
