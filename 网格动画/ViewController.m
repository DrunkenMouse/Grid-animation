//
//  ViewController.m
//  网格动画
//
//  Created by 王奥东 on 16/12/6.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ViewController.h"
#import "ADGridViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    ADGridViewController * _flipGrid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _flipGrid = [[ADGridViewController alloc] initWithImage:[UIImage imageNamed:@"1"] gridCount:CGSizeMake(20, 6)];
    
    [self.view addSubview:_flipGrid.view];
    
    CGRect originalFrame = _flipGrid.view.frame;
    originalFrame.origin.y = 150;
    
    
    _flipGrid.view.frame = originalFrame;
}




@end
