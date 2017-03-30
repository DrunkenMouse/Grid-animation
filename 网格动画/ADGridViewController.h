//
//  ADGridViewController.h
//  网格动画
//
//  Created by 王奥东 on 16/12/6.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADGridViewController : UIViewController


-(id)initWithImage:(UIImage *)image gridCount:(CGSize)count;
-(void)doFlipAnimation;

@end
