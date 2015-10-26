//
//  JYFoldingView.m
//  JYFoldingView
//
//  Created by joyann on 15/10/26.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYFoldingView.h"

@interface JYFoldingView ()
@property (nonatomic, weak) UIImageView *topImageView;
@property (nonatomic, weak) UIView *gestureView;
@property (nonatomic, weak) UIImageView *bottomImageView;
@property (nonatomic, weak) CAGradientLayer *gradientLayer;
@end

@implementation JYFoldingView

#pragma mark - Getter Methods

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        // 增加阴影
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bottomImageView.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor, (id)[UIColor blackColor].CGColor];
        gradientLayer.opacity = 0.0;
        [self.bottomImageView.layer addSublayer:gradientLayer];
        
        _gradientLayer = gradientLayer;
    }
    return _gradientLayer;
}

#pragma mark - Init Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpWithFrame: frame];
    }
    return self;
}

#pragma mark - Set Up

- (void)setUpWithFrame: (CGRect)frame
{
    
    UIImage *image = [UIImage imageNamed:@"知道错了"];
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
    // 下半部分图片
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 0.5)];
    bottomImageView.layer.anchorPoint = CGPointMake(0.5, 0.0);
    bottomImageView.layer.position = center;
    CGRect bottomRect = CGRectMake(0, image.size.height * 0.5, image.size.width, image.size.height * 0.5);
    UIImage *bottomImage = [self getImageFromImage:image withRect:bottomRect];
    bottomImageView.image = bottomImage;
    [self addSubview:bottomImageView];
    self.bottomImageView = bottomImageView;
    
    // 上半部分图片
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 0.5)];
    topImageView.layer.anchorPoint = CGPointMake(0.5, 1.0);
    topImageView.layer.position = center;
    CGRect topRect = CGRectMake(0, 0, image.size.width, image.size.height * 0.5);
    UIImage *topImage = [self getImageFromImage:image withRect:topRect];
    topImageView.image = topImage;
    [self addSubview:topImageView];
    self.topImageView = topImageView;
    
    // 添加空白view用于添加手势
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self addSubview:view];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [view addGestureRecognizer:pan];
    self.gestureView = view;
}

#pragma makr - Handle Pan

- (void)handlePan: (UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self.gestureView];
    CGFloat angle = -M_PI * translation.y / self.gestureView.frame.size.height;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1 / 300.0;
    self.topImageView.layer.transform = CATransform3DRotate(transform, angle, 1, 0, 0);
    
    CGFloat opacity = -angle / M_PI;
    self.gradientLayer.opacity = opacity;
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self.gradientLayer removeFromSuperlayer];
        
        [UIView animateWithDuration:1.5 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.topImageView.layer.transform = CATransform3DIdentity;
        } completion:nil];
    }
}

#pragma mark - Helper Methdos

- (UIImage *)getImageFromImage:(UIImage *)image withRect: (CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    return [UIImage imageWithCGImage:imageRef];
}

@end
