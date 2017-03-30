//
//  ADGridViewController.m
//  网格动画
//
//  Created by 王奥东 on 16/12/6.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADGridViewController.h"

@interface ADGridViewController ()

@property(nonatomic, strong)UIImage *image;//图片
@property(nonatomic, strong)NSMutableArray *imageGridArr;//图片薄片数组
@property(nonatomic, assign)CGSize gridCount;//网格个数

@end

@implementation ADGridViewController


-(instancetype)initWithImage:(UIImage *)image gridCount:(CGSize)count {
    self.image = [image copy];
    self.gridCount = count;
    if (self = [super init]) {
        self.view.frame = CGRectMake(0, 0, image.size.width, image.size.height);
     [self generateImageGrid];   
    }
    return self;
}

//生成网格
-(void)generateImageGrid {
    
    float gridSizeX = self.view.frame.size.width / self.gridCount.width;
    float gridSizeY = self.view.frame.size.height / self.gridCount.height;
    
    self.imageGridArr = [NSMutableArray array];
    
    
    
    for (int yer = 0; yer < self.gridCount.height; yer++) {
        for (int xer = 0; xer < self.gridCount.width; xer++) {
            //创建图片薄片，就是按设置的比例分割后的一个个图片
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(xer * gridSizeX, yer * gridSizeY, gridSizeX, gridSizeY)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            
            //计算网格图像的frame
            //y 宽按像素比例相乘，高度与x值是薄片2倍
            //若不处理则图片会显示不完整，因为自身的大小是图片的大小
            CGRect imgFrame = CGRectMake(xer*gridSizeX*2, yer*gridSizeY*[[UIScreen mainScreen] scale], gridSizeX*[[UIScreen mainScreen] scale], gridSizeY*2 );
            //将图片切割成网格
            CGImageRef imageRef = CGImageCreateWithImageInRect([self.image CGImage], imgFrame);
            UIImage *subImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            //添加切好的图片到图片薄片
            [imgView setImage:subImage];
            //添加到自身View
            [self.view addSubview:imgView];
            //并存到数组中
            [self.imageGridArr addObject:imgView];
            
           
        }
    }
    [self doFlipAnimation];
}

//翻转动画实现
-(void)doFlipAnimation {
    
    float delayDelta = 0.12f;//用于计算每个网格的动画开始时间
    float rowDelay = 0.06f;//用于计算网格之间的等待时间
 
    float duration = 0.5f;//动画的持续时间
    
    float totalRowDelay = 0.0f;//网格之间的等待时间，默认为0因为第一个不需要等待
    //每一个网格都有一个动画旋转动画
    for (int yer = 0; yer < self.gridCount.height; yer++) {
        for (int xer = 0; xer < self.gridCount.width; xer++) {
            
            UIImageView *imgView = [self.imageGridArr objectAtIndex:yer * self.gridCount.width + xer];
            float calculateDelay = xer *delayDelta + totalRowDelay;//计算动画开始时间
            //旋转动画
            CAKeyframeAnimation *rotationAnimation;
            rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.y"];
            
            
            //因为时间应于Values对应
            //所以从0到0.5，从0.50001到1.0
            //若去掉其中一个值会出现图片消失的情况
            rotationAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.50001],[NSNumber numberWithFloat:1.0], nil];
            
            //一个数组，提供了一组关键帧的值
            rotationAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:M_PI/2],[NSNumber numberWithFloat:-M_PI/2],[NSNumber numberWithFloat:0], nil];
            
            rotationAnimation.duration = duration;//动画持续时间
            rotationAnimation.beginTime = CACurrentMediaTime() + calculateDelay;//指定了开始播放动画的时间
            rotationAnimation.fillMode = kCAFillModeForwards;
            rotationAnimation.removedOnCompletion = NO;
            rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];//线性起博
            [imgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation1"];
            //不透明动画
            CAKeyframeAnimation *opactiyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            opactiyAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.50001],[NSNumber numberWithFloat:1.0], nil];
            //一个数组，提供了一组关键帧的值
            opactiyAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:1.0], nil];
            opactiyAnimation.duration = duration;
            opactiyAnimation.beginTime = CACurrentMediaTime() + calculateDelay;
            opactiyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [imgView.layer addAnimation:opactiyAnimation forKey:@"opacity"];
        }
        totalRowDelay += rowDelay;
    }
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(doFlipAnimation) userInfo:nil repeats:NO];
}



@end
