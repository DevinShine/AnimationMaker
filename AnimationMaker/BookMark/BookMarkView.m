//
//  BookMarkView.m
//  AnimationMaker
//
//  Created by DevinShine on 16/8/24.
//  Copyright © 2016年 DevinShine. All rights reserved.
//

#import "BookMarkView.h"
#import "QCMethod.h"

#define RGBA(c,a)    [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]
#define RGB(c)    RGBA(c,1)
#define NormalColor RGB(0x666A73)
#define NormalColor2 RGB(0xC6C9D0)
#define SelectedColor RGB(0xF6682F)

@interface BookMarkView ()
@property (nonatomic, strong) NSMutableDictionary * layers;
@property (nonatomic, strong) NSMapTable * completionBlocks;
@property (nonatomic, assign) BOOL  updateLayerValueForCompletedAnimation;
@end

@implementation BookMarkView{
    CGRect originframe;
    BOOL animating;
    CAShapeLayer *bigCircleLayer;
    CAShapeLayer *bookMarkLayer;
    CAShapeLayer *selectedBookMarkLayer;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSomething];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpSomething];
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        [self setUpSomething];
    }
    return self;
}

-(void)setUpSomething{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGes];
    
    [self drawBookMarkLayer];
    
    [self setupProperties];
}


-(void)drawBookMarkLayer{
    
    bookMarkLayer = [CAShapeLayer layer];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(33.5, 71)];
    [bezierPath addLineToPoint: CGPointMake(50.19, 57.48)];
    [bezierPath addLineToPoint: CGPointMake(66, 71)];
    [bezierPath addLineToPoint: CGPointMake(66, 28.5)];
    [bezierPath addLineToPoint: CGPointMake(33.5, 28.5)];
    [bezierPath addLineToPoint: CGPointMake(33.5, 71)];
    [bezierPath closePath];
    
    
    bookMarkLayer.path = bezierPath.CGPath;
    bookMarkLayer.fillColor = [UIColor clearColor].CGColor;
    bookMarkLayer.strokeColor = NormalColor.CGColor;
    bookMarkLayer.lineWidth = 10.0;
    bookMarkLayer.frame = self.bounds;
    
    [self.layer addSublayer:bookMarkLayer];
}

-(void)drawSelectedBookMarkLayer{
    
    selectedBookMarkLayer = [CAShapeLayer layer];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(33.5, 71)];
    [bezierPath addLineToPoint: CGPointMake(50.19, 57.48)];
    [bezierPath addLineToPoint: CGPointMake(66, 71)];
    [bezierPath addLineToPoint: CGPointMake(66, 28.5)];
    [bezierPath addLineToPoint: CGPointMake(33.5, 28.5)];
    [bezierPath addLineToPoint: CGPointMake(33.5, 71)];
    [bezierPath closePath];
    
    
    selectedBookMarkLayer.path = bezierPath.CGPath;
    selectedBookMarkLayer.fillColor = SelectedColor.CGColor;
    selectedBookMarkLayer.strokeColor = [UIColor clearColor].CGColor;
    selectedBookMarkLayer.frame = self.bounds;
    
    [self.layer addSublayer:selectedBookMarkLayer];
}

#pragma mark -- UITapGesture

-(void)tapped:(UITapGestureRecognizer *)tapped{
    originframe = self.frame;
    
    if (animating == YES) {
        return;
    }
    
    for (CALayer *subLayer in self.layer.sublayers) {
        [subLayer removeFromSuperlayer];
    }
    
    animating = YES;

    [self drawBookMarkLayer];
    //缩小动画
    CABasicAnimation *scaleBookMarkanimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleBookMarkanimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleBookMarkanimation.toValue = [NSNumber numberWithFloat:0.2];
    scaleBookMarkanimation.removedOnCompletion = NO;
    scaleBookMarkanimation.fillMode = kCAFillModeForwards;
    
    //颜色变化动画
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    colorAnimation.fromValue = (id)NormalColor.CGColor;
    colorAnimation.toValue = (id)NormalColor2.CGColor;
    colorAnimation.removedOnCompletion = NO;
    colorAnimation.fillMode = kCAFillModeForwards;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.3;
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = @[scaleBookMarkanimation, colorAnimation];
    group.delegate = self;
    [bookMarkLayer addAnimation:group forKey:@"bookMarkAnimations"];
    
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //QuartzCode start
    void (^completionBlock)(BOOL) = [self.completionBlocks objectForKey:anim];;
    if (completionBlock){
        [self.completionBlocks removeObjectForKey:anim];
        if ((flag && self.updateLayerValueForCompletedAnimation) || [[anim valueForKey:@"needEndAnim"] boolValue]){
            [self updateLayerValuesForAnimationId:[anim valueForKey:@"animId"]];
            [self removeAnimationsForAnimationId:[anim valueForKey:@"animId"]];
        }
        completionBlock(flag);
    }
    //QuartzCode end
    
    if([anim isEqual:[selectedBookMarkLayer animationForKey:@"scaleSelectAnimation"]]){
        
    }else if ([anim isEqual:[bigCircleLayer animationForKey:@"scaleAnimation"]]) {
        [bigCircleLayer removeFromSuperlayer];//移除
        
        [self setupLayers];
        __weak typeof(self) weakself = self;
        [self addBottomAnimationAnimationCompletionBlock:^(BOOL finished) {
            animating = NO;
            for (NSString* key in weakself.layers) {
                CALayer *layer = [weakself.layers objectForKey:key];
                [layer removeFromSuperlayer];
                // do stuff
            }
        }];
        
    }else if([anim isEqual:[bookMarkLayer animationForKey:@"bookMarkAnimations"]]){
        
        //移除
        [bookMarkLayer performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:0.3f];
        //被选中的显示
        [self drawSelectedBookMarkLayer];
        int force = 1;
        CAKeyframeAnimation *scaleSelectBookMarkAnimation = [[CAKeyframeAnimation alloc]init];
        scaleSelectBookMarkAnimation.keyPath = @"transform.scale";
        scaleSelectBookMarkAnimation.values = @[@0, @(0.2*force), @(-0.2*force), @(0.2*force), @0];
        scaleSelectBookMarkAnimation.keyTimes = @[@0, @0.2, @0.4, @0.6, @0.8, @1];
        scaleSelectBookMarkAnimation.duration = 2;
        scaleSelectBookMarkAnimation.additive = true;
        scaleSelectBookMarkAnimation.repeatCount = 1;
        scaleSelectBookMarkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scaleSelectBookMarkAnimation.removedOnCompletion = NO;
        scaleSelectBookMarkAnimation.fillMode = kCAFillModeForwards;
        
        scaleSelectBookMarkAnimation.delegate = self;
        [selectedBookMarkLayer addAnimation:scaleSelectBookMarkAnimation forKey:@"scaleSelectAnimation"];
        
        //大圆层
        bigCircleLayer = [CAShapeLayer layer];
        UIBezierPath* bigCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(originframe)/2, CGRectGetHeight(originframe)/2) radius:50.0f startAngle:0.0 endAngle:(M_PI * 2) clockwise:YES];
        bigCircleLayer.path = bigCirclePath.CGPath;
        bigCircleLayer.frame = self.bounds;
        bigCircleLayer.fillColor = SelectedColor.CGColor;
        
        //小圆层
        CAShapeLayer *smallCircleLayer = [CAShapeLayer layer];
        UIBezierPath *smallCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(originframe)/2, CGRectGetHeight(originframe)/2) radius:1.0f startAngle:0.0 endAngle:(M_PI * 2) clockwise:YES];
        
        [smallCirclePath appendPath:bigCirclePath];
        smallCircleLayer.path = smallCirclePath.CGPath;
        smallCircleLayer.fillColor = [UIColor blueColor].CGColor;
        smallCircleLayer.fillRule = kCAFillRuleEvenOdd;
        
        bigCircleLayer.mask = smallCircleLayer;
        [self.layer addSublayer:bigCircleLayer];
        
        CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        UIBezierPath *finalSmallCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(originframe)/2, CGRectGetHeight(originframe)/2) radius:50.0f startAngle:0.0 endAngle:(M_PI * 2) clockwise:YES];
        [finalSmallCirclePath appendPath:bigCirclePath];
        
        circleAnimation.duration = 0.2;
        [circleAnimation setBeginTime:CACurrentMediaTime()+0.2];
        circleAnimation.removedOnCompletion = NO;
        circleAnimation.fillMode = kCAFillModeForwards;
        circleAnimation.toValue = (id) finalSmallCirclePath.CGPath;
        circleAnimation.fromValue = (id) smallCirclePath.CGPath;
        circleAnimation.delegate = self;
        
        [smallCircleLayer addAnimation:circleAnimation forKey:@"circleAnimation"];
        
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = 0.4;
        scaleAnimation.repeatCount = 1;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        scaleAnimation.delegate = self;
        [bigCircleLayer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}



//--------------------------QuartzCode Code--------------------------//

- (void)setupProperties{
    self.completionBlocks = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory valueOptions:NSPointerFunctionsStrongMemory];;
    self.layers = [NSMutableDictionary dictionary];
    
}

- (void)setupLayers{
    CAShapeLayer * bottom = [CAShapeLayer layer];
    bottom.frame = CGRectMake(49.56, 57.18, 3.57, 2.82);
    bottom.path = [self bottomPath].CGPath;
    [self.layer addSublayer:bottom];
    self.layers[@"bottom"] = bottom;
    
    CAShapeLayer * left = [CAShapeLayer layer];
    left.frame = CGRectMake(39.56, 47.27, 3, 4);
    left.path = [self leftPath].CGPath;
    [self.layer addSublayer:left];
    self.layers[@"left"] = left;
    
    CAShapeLayer * bottom_ = [CAShapeLayer layer];
    bottom_.frame = CGRectMake(5.24, 4.16, 1.78, 1);
    bottom_.path = [self bottom_Path].CGPath;
//    [self.layer addSublayer:bottom_];
    self.layers[@"bottom_"] = bottom_;
    
    CAShapeLayer * bottom_2 = [CAShapeLayer layer];
    bottom_2.frame = CGRectMake(6.24, 11.5, 1.78, 4);
    bottom_2.path = [self bottom_2Path].CGPath;
//    [self.layer addSublayer:bottom_2];
    self.layers[@"bottom_2"] = bottom_2;
    
    CAShapeLayer * left_ = [CAShapeLayer layer];
    left_.frame = CGRectMake(10.46, 22.16, 4, 2);
    left_.path = [self left_Path].CGPath;
//    [self.layer addSublayer:left_];
    self.layers[@"left_"] = left_;
    
    CAShapeLayer * left_2 = [CAShapeLayer layer];
    left_2.frame = CGRectMake(15.46, 3.16, 1, 2);
    left_2.path = [self left_2Path].CGPath;
//    [self.layer addSublayer:left_2];
    self.layers[@"left_2"] = left_2;
    
    CAShapeLayer * right = [CAShapeLayer layer];
    right.frame = CGRectMake(59.13, 47.27, 3, 4);
    right.path = [self rightPath].CGPath;
    [self.layer addSublayer:right];
    self.layers[@"right"] = right;
    
    CAShapeLayer * top = [CAShapeLayer layer];
    top.frame = CGRectMake(49.56, 39.46, 3.57, 2.82);
    top.path = [self topPath].CGPath;
    [self.layer addSublayer:top];
    self.layers[@"top"] = top;
    
    CAShapeLayer * leftTop = [CAShapeLayer layer];
    leftTop.frame = CGRectMake(39.15, 39.77, 7, 2);
    leftTop.path = [self leftTopPath].CGPath;
    [self.layer addSublayer:leftTop];
    self.layers[@"leftTop"] = leftTop;
    
    CAShapeLayer * leftTop_0 = [CAShapeLayer layer];
    leftTop_0.frame = CGRectMake(22.5, 3.1, 1, 2);
    leftTop_0.path = [self leftTop_0Path].CGPath;
//    [self.layer addSublayer:leftTop_0];
    self.layers[@"leftTop_0"] = leftTop_0;
    
    CAShapeLayer * rightTop = [CAShapeLayer layer];
    rightTop.frame = CGRectMake(55.72, 39.77, 7, 2);
    rightTop.path = [self rightTopPath].CGPath;
    [self.layer addSublayer:rightTop];
    self.layers[@"rightTop"] = rightTop;
    
    CAShapeLayer * leftBottom = [CAShapeLayer layer];
    leftBottom.frame = CGRectMake(39.15, 55.91, 7, 2);
    leftBottom.path = [self leftBottomPath].CGPath;
    [self.layer addSublayer:leftBottom];
    self.layers[@"leftBottom"] = leftBottom;
    
    CAShapeLayer * rightBottom = [CAShapeLayer layer];
    rightBottom.frame = CGRectMake(55.5, 56, 7, 2);
    rightBottom.path = [self rightBottomPath].CGPath;
    [self.layer addSublayer:rightBottom];
    self.layers[@"rightBottom"] = rightBottom;
    
    [self resetLayerPropertiesForLayerIdentifiers:nil];
}

- (void)resetLayerPropertiesForLayerIdentifiers:(NSArray *)layerIds{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if(!layerIds || [layerIds containsObject:@"bottom"]){
        CAShapeLayer * bottom = self.layers[@"bottom"];
        bottom.fillColor = [UIColor colorWithRed:0.847 green: 0.498 blue:0.325 alpha:1].CGColor;
        bottom.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"left"]){
        CAShapeLayer * left = self.layers[@"left"];
        left.fillColor = [UIColor colorWithRed:0.847 green: 0.498 blue:0.325 alpha:1].CGColor;
        left.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"bottom_1"]){
        CAShapeLayer * bottom_1 = self.layers[@"bottom_1"];
        bottom_1.fillColor = [UIColor colorWithRed:0.922 green: 0.922 blue:0.922 alpha:1].CGColor;
        bottom_1.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"bottom_0"]){
        CAShapeLayer * bottom_0 = self.layers[@"bottom_0"];
        bottom_0.fillColor = [UIColor colorWithRed:0.922 green: 0.922 blue:0.922 alpha:1].CGColor;
        bottom_0.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"left_0"]){
        CAShapeLayer * left_0 = self.layers[@"left_0"];
        left_0.fillColor = [UIColor colorWithRed:0.922 green: 0.922 blue:0.922 alpha:1].CGColor;
        left_0.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"left_1"]){
        CAShapeLayer * left_1 = self.layers[@"left_1"];
        left_1.fillColor = [UIColor colorWithRed:0.922 green: 0.922 blue:0.922 alpha:1].CGColor;
        left_1.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"right"]){
        CAShapeLayer * right = self.layers[@"right"];
        right.fillColor = [UIColor colorWithRed:0.847 green: 0.498 blue:0.325 alpha:1].CGColor;
        right.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"top"]){
        CAShapeLayer * top = self.layers[@"top"];
        top.fillColor = [UIColor colorWithRed:0.847 green: 0.498 blue:0.325 alpha:1].CGColor;
        top.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"leftTop"]){
        CAShapeLayer * leftTop = self.layers[@"leftTop"];
        [leftTop setValue:@(45 * M_PI/180) forKeyPath:@"transform.rotation"];
        leftTop.fillColor = [UIColor colorWithRed:0.31 green: 0.788 blue:0.82 alpha:1].CGColor;
        leftTop.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"leftTop_0"]){
        CAShapeLayer * leftTop_0 = self.layers[@"leftTop_0"];
        [leftTop_0 setValue:@(45 * M_PI/180) forKeyPath:@"transform.rotation"];
        leftTop_0.fillColor = [UIColor colorWithRed:0.31 green: 0.788 blue:0.82 alpha:1].CGColor;
        leftTop_0.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"rightTop"]){
        CAShapeLayer * rightTop = self.layers[@"rightTop"];
        [rightTop setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
        rightTop.fillColor = [UIColor colorWithRed:0.31 green: 0.788 blue:0.82 alpha:1].CGColor;
        rightTop.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"leftBottom"]){
        CAShapeLayer * leftBottom = self.layers[@"leftBottom"];
        [leftBottom setValue:@(-45 * M_PI/180) forKeyPath:@"transform.rotation"];
        leftBottom.fillColor = [UIColor colorWithRed:0.31 green: 0.788 blue:0.82 alpha:1].CGColor;
        leftBottom.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"rightBottom"]){
        CAShapeLayer * rightBottom = self.layers[@"rightBottom"];
        [rightBottom setValue:@(-135 * M_PI/180) forKeyPath:@"transform.rotation"];
        rightBottom.fillColor = [UIColor colorWithRed:0.31 green: 0.788 blue:0.82 alpha:1].CGColor;
        rightBottom.lineWidth = 0;
    }
    
    [CATransaction commit];
}

#pragma mark - Animation Setup

- (void)addBottomAnimationAnimation{
    [self addBottomAnimationAnimationCompletionBlock:nil];
}

- (void)addBottomAnimationAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock{
    if (completionBlock){
        CABasicAnimation * completionAnim = [CABasicAnimation animationWithKeyPath:@"completionAnim"];;
        completionAnim.duration = 0.456;
        completionAnim.delegate = self;
        [completionAnim setValue:@"bottomAnimation" forKey:@"animId"];
        [completionAnim setValue:@(NO) forKey:@"needEndAnim"];
        [self.layer addAnimation:completionAnim forKey:@"bottomAnimation"];
        [self.completionBlocks setObject:completionBlock forKey:[self.layer animationForKey:@"bottomAnimation"]];
    }
    
    NSString * fillMode = kCAFillModeForwards;
    
    ////Bottom animation
    CAKeyframeAnimation * bottomTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    bottomTransformAnim.values         = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 30, 0)]];
    bottomTransformAnim.keyTimes       = @[@0, @1];
    bottomTransformAnim.duration       = 0.456;
    bottomTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * bottomPathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    bottomPathAnim.values                = @[(id)[QCMethod alignToBottomPath:[self bottomPath] layer:self.layers[@"bottom"]].CGPath, (id)[QCMethod alignToBottomPath:[self bottom_2Path] layer:self.layers[@"bottom"]].CGPath, (id)[QCMethod alignToBottomPath:[self bottom_Path] layer:self.layers[@"bottom"]].CGPath];
    bottomPathAnim.keyTimes              = @[@0, @0.308, @1];
    bottomPathAnim.duration              = 0.456;
    bottomPathAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * bottomFillColorAnim = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
    bottomFillColorAnim.values         = @[(id)[UIColor colorWithRed:0.847 green: 0.498 blue:0.325 alpha:1].CGColor,
                                           (id)[UIColor colorWithRed:0.224 green: 0.584 blue:0.62 alpha:1].CGColor];
    bottomFillColorAnim.keyTimes       = @[@0, @1];
    bottomFillColorAnim.duration       = 0.456;
    bottomFillColorAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * bottomBottomAnimationAnim = [QCMethod groupAnimations:@[bottomTransformAnim, bottomPathAnim, bottomFillColorAnim] fillMode:fillMode];
    [self.layers[@"bottom"] addAnimation:bottomBottomAnimationAnim forKey:@"bottomBottomAnimationAnim"];
    
    ////Left animation
    CAKeyframeAnimation * leftTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    leftTransformAnim.values         = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-30, 0, 0)]];
    leftTransformAnim.keyTimes       = @[@0, @1];
    leftTransformAnim.duration       = 0.456;
    leftTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * leftPathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    leftPathAnim.values                = @[(id)[QCMethod alignToBottomPath:[self bottomPath] layer:self.layers[@"left"]].CGPath, (id)[QCMethod alignToBottomPath:[self left_Path] layer:self.layers[@"left"]].CGPath, (id)[QCMethod alignToBottomPath:[self left_2Path] layer:self.layers[@"left"]].CGPath];
    leftPathAnim.keyTimes              = @[@0, @0.308, @1];
    leftPathAnim.duration              = 0.456;
    leftPathAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * leftFillColorAnim = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
    leftFillColorAnim.values         = @[(id)[UIColor colorWithRed:0.847 green: 0.498 blue:0.325 alpha:1].CGColor,
                                         (id)[UIColor colorWithRed:0.224 green: 0.584 blue:0.62 alpha:1].CGColor];
    leftFillColorAnim.keyTimes       = @[@0, @1];
    leftFillColorAnim.duration       = 0.456;
    leftFillColorAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * leftBottomAnimationAnim = [QCMethod groupAnimations:@[leftTransformAnim, leftPathAnim, leftFillColorAnim] fillMode:fillMode];
    [self.layers[@"left"] addAnimation:leftBottomAnimationAnim forKey:@"leftBottomAnimationAnim"];
    
    ////Right animation
    CAKeyframeAnimation * rightTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    rightTransformAnim.values         = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                          [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(30, 0, 0)]];
    rightTransformAnim.keyTimes       = @[@0, @1];
    rightTransformAnim.duration       = 0.456;
    rightTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * rightPathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    rightPathAnim.values                = @[(id)[QCMethod alignToBottomPath:[self bottomPath] layer:self.layers[@"right"]].CGPath, (id)[QCMethod alignToBottomPath:[self left_Path] layer:self.layers[@"right"]].CGPath, (id)[QCMethod alignToBottomPath:[self left_2Path] layer:self.layers[@"right"]].CGPath];
    rightPathAnim.keyTimes              = @[@0, @0.308, @1];
    rightPathAnim.duration              = 0.456;
    rightPathAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * rightFillColorAnim = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
    rightFillColorAnim.values         = @[(id)[UIColor colorWithRed:0.847 green: 0.498 blue:0.325 alpha:1].CGColor,
                                          (id)[UIColor colorWithRed:0.224 green: 0.584 blue:0.62 alpha:1].CGColor];
    rightFillColorAnim.keyTimes       = @[@0, @1];
    rightFillColorAnim.duration       = 0.456;
    rightFillColorAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * rightBottomAnimationAnim = [QCMethod groupAnimations:@[rightTransformAnim, rightPathAnim, rightFillColorAnim] fillMode:fillMode];
    [self.layers[@"right"] addAnimation:rightBottomAnimationAnim forKey:@"rightBottomAnimationAnim"];
    
    ////Top animation
    CAKeyframeAnimation * topTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    topTransformAnim.values                = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                               [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -30, 0)]];
    topTransformAnim.keyTimes              = @[@0, @1];
    topTransformAnim.duration              = 0.456;
    topTransformAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * topPathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    topPathAnim.values                = @[(id)[QCMethod alignToBottomPath:[self bottomPath] layer:self.layers[@"top"]].CGPath, (id)[QCMethod alignToBottomPath:[self bottom_2Path] layer:self.layers[@"top"]].CGPath, (id)[QCMethod alignToBottomPath:[self bottom_Path] layer:self.layers[@"top"]].CGPath];
    topPathAnim.keyTimes              = @[@0, @0.308, @1];
    topPathAnim.duration              = 0.456;
    topPathAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * topFillColorAnim = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
    topFillColorAnim.values                = @[(id)[UIColor colorWithRed:0.847 green: 0.498 blue:0.325 alpha:1].CGColor,
                                               (id)[UIColor colorWithRed:0.224 green: 0.584 blue:0.62 alpha:1].CGColor];
    topFillColorAnim.keyTimes              = @[@0, @1];
    topFillColorAnim.duration              = 0.456;
    topFillColorAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * topBottomAnimationAnim = [QCMethod groupAnimations:@[topTransformAnim, topPathAnim, topFillColorAnim] fillMode:fillMode];
    [self.layers[@"top"] addAnimation:topBottomAnimationAnim forKey:@"topBottomAnimationAnim"];
    
    ////LeftTop animation
    CAKeyframeAnimation * leftTopTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    leftTopTransformAnim.values         = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(-45 * M_PI/180, 0, 0, -1)],
                                            [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(-26, 0, 0), CATransform3DMakeRotation(45 * M_PI/180, 0, -0, 1))]];
    leftTopTransformAnim.keyTimes       = @[@0, @1];
    leftTopTransformAnim.duration       = 0.456;
    leftTopTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * leftTopPathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    leftTopPathAnim.values                = @[(id)[QCMethod alignToBottomPath:[self leftTopPath] layer:self.layers[@"leftTop"]].CGPath, (id)[QCMethod alignToBottomPath:[self leftTop_0Path] layer:self.layers[@"leftTop"]].CGPath];
    leftTopPathAnim.keyTimes              = @[@0, @1];
    leftTopPathAnim.duration              = 0.456;
    leftTopPathAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * leftTopBottomAnimationAnim = [QCMethod groupAnimations:@[leftTopTransformAnim, leftTopPathAnim] fillMode:fillMode];
    [self.layers[@"leftTop"] addAnimation:leftTopBottomAnimationAnim forKey:@"leftTopBottomAnimationAnim"];
    
    ////RightTop animation
    CAKeyframeAnimation * rightTopTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    rightTopTransformAnim.values         = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 0, 0, -1)],
                                             [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(26, 0, 0), CATransform3DMakeRotation(-M_PI_4, 0, 0, 1))]];
    rightTopTransformAnim.keyTimes       = @[@0, @1];
    rightTopTransformAnim.duration       = 0.456;
    rightTopTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * rightTopPathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    rightTopPathAnim.values                = @[(id)[QCMethod alignToBottomPath:[self leftTopPath] layer:self.layers[@"rightTop"]].CGPath, (id)[QCMethod alignToBottomPath:[self leftTop_0Path] layer:self.layers[@"rightTop"]].CGPath];
    rightTopPathAnim.keyTimes              = @[@0, @1];
    rightTopPathAnim.duration              = 0.456;
    rightTopPathAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * rightTopBottomAnimationAnim = [QCMethod groupAnimations:@[rightTopTransformAnim, rightTopPathAnim] fillMode:fillMode];
    [self.layers[@"rightTop"] addAnimation:rightTopBottomAnimationAnim forKey:@"rightTopBottomAnimationAnim"];
    
    ////LeftBottom animation
    CAKeyframeAnimation * leftBottomTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    leftBottomTransformAnim.values         = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 0, 0, -1)],
                                               [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(-26, 0, 0), CATransform3DMakeRotation(-M_PI_4, 0, 0, 1))]];
    leftBottomTransformAnim.keyTimes       = @[@0, @1];
    leftBottomTransformAnim.duration       = 0.456;
    leftBottomTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * leftBottomPathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    leftBottomPathAnim.values         = @[(id)[QCMethod alignToBottomPath:[self leftTopPath] layer:self.layers[@"leftBottom"]].CGPath, (id)[QCMethod alignToBottomPath:[self leftTop_0Path] layer:self.layers[@"leftBottom"]].CGPath];
    leftBottomPathAnim.keyTimes       = @[@0, @1];
    leftBottomPathAnim.duration       = 0.456;
    leftBottomPathAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * leftBottomBottomAnimationAnim = [QCMethod groupAnimations:@[leftBottomTransformAnim, leftBottomPathAnim] fillMode:fillMode];
    [self.layers[@"leftBottom"] addAnimation:leftBottomBottomAnimationAnim forKey:@"leftBottomBottomAnimationAnim"];
    
    ////RightBottom animation
    CAKeyframeAnimation * rightBottomTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    rightBottomTransformAnim.values   = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(135 * M_PI/180, 0, 0, -1)],
                                          [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(-26, 0, 0), CATransform3DMakeRotation(-135 * M_PI/180, -0, 0, 1))]];
    rightBottomTransformAnim.keyTimes = @[@0, @1];
    rightBottomTransformAnim.duration = 0.456;
    rightBottomTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * rightBottomPathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    rightBottomPathAnim.values         = @[(id)[QCMethod alignToBottomPath:[self leftTopPath] layer:self.layers[@"rightBottom"]].CGPath, (id)[QCMethod alignToBottomPath:[self leftTop_0Path] layer:self.layers[@"rightBottom"]].CGPath];
    rightBottomPathAnim.keyTimes       = @[@0, @1];
    rightBottomPathAnim.duration       = 0.456;
    rightBottomPathAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * rightBottomBottomAnimationAnim = [QCMethod groupAnimations:@[rightBottomTransformAnim, rightBottomPathAnim] fillMode:fillMode];
    [self.layers[@"rightBottom"] addAnimation:rightBottomBottomAnimationAnim forKey:@"rightBottomBottomAnimationAnim"];
}

#pragma mark - Animation Cleanup

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
    if([identifier isEqualToString:@"bottomAnimation"]){
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"rightBottom"] animationForKey:@"rightBottomBottomAnimationAnim"] theLayer:self.layers[@"rightBottom"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"bottom"] animationForKey:@"bottomBottomAnimationAnim"] theLayer:self.layers[@"bottom"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"left"] animationForKey:@"leftBottomAnimationAnim"] theLayer:self.layers[@"left"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"right"] animationForKey:@"rightBottomAnimationAnim"] theLayer:self.layers[@"right"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"top"] animationForKey:@"topBottomAnimationAnim"] theLayer:self.layers[@"top"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"leftTop"] animationForKey:@"leftTopBottomAnimationAnim"] theLayer:self.layers[@"leftTop"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"rightTop"] animationForKey:@"rightTopBottomAnimationAnim"] theLayer:self.layers[@"rightTop"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"leftBottom"] animationForKey:@"leftBottomBottomAnimationAnim"] theLayer:self.layers[@"leftBottom"]];
    }
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
    if([identifier isEqualToString:@"bottomAnimation"]){
        [self.layers[@"rightBottom"] removeAnimationForKey:@"rightBottomBottomAnimationAnim"];
        [self.layers[@"bottom"] removeAnimationForKey:@"bottomBottomAnimationAnim"];
        [self.layers[@"left"] removeAnimationForKey:@"leftBottomAnimationAnim"];
        [self.layers[@"right"] removeAnimationForKey:@"rightBottomAnimationAnim"];
        [self.layers[@"top"] removeAnimationForKey:@"topBottomAnimationAnim"];
        [self.layers[@"leftTop"] removeAnimationForKey:@"leftTopBottomAnimationAnim"];
        [self.layers[@"rightTop"] removeAnimationForKey:@"rightTopBottomAnimationAnim"];
        [self.layers[@"leftBottom"] removeAnimationForKey:@"leftBottomBottomAnimationAnim"];
    }
}

- (void)removeAllAnimations{
    [self.layers enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
        [layer removeAllAnimations];
    }];
}

#pragma mark - Bezier Path

- (UIBezierPath*)bottomPath{
    UIBezierPath *bottomPath = [UIBezierPath bezierPath];
    [bottomPath moveToPoint:CGPointMake(0, 2.817)];
    [bottomPath addLineToPoint:CGPointMake(3.57, 2.817)];
    [bottomPath addLineToPoint:CGPointMake(3.57, 0)];
    [bottomPath addLineToPoint:CGPointMake(0, 0)];
    [bottomPath closePath];
    [bottomPath moveToPoint:CGPointMake(0, 2.817)];
    
    return bottomPath;
}

- (UIBezierPath*)leftPath{
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(0, 4)];
    [leftPath addLineToPoint:CGPointMake(3, 4)];
    [leftPath addLineToPoint:CGPointMake(3, 0)];
    [leftPath addLineToPoint:CGPointMake(0, 0)];
    [leftPath closePath];
    [leftPath moveToPoint:CGPointMake(0, 4)];
    
    return leftPath;
}

- (UIBezierPath*)bottom_Path{
    UIBezierPath * bottom_Path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 2, 1)];
    return bottom_Path;
}

- (UIBezierPath*)bottom_2Path{
    UIBezierPath * bottom_2Path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 2, 4)];
    return bottom_2Path;
}

- (UIBezierPath*)left_Path{
    UIBezierPath * left_Path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 4, 2)];
    return left_Path;
}

- (UIBezierPath*)left_2Path{
    UIBezierPath * left_2Path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1, 2)];
    return left_2Path;
}

- (UIBezierPath*)rightPath{
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    [rightPath moveToPoint:CGPointMake(0, 4)];
    [rightPath addLineToPoint:CGPointMake(3, 4)];
    [rightPath addLineToPoint:CGPointMake(3, 0)];
    [rightPath addLineToPoint:CGPointMake(0, 0)];
    [rightPath closePath];
    [rightPath moveToPoint:CGPointMake(0, 4)];
    
    return rightPath;
}

- (UIBezierPath*)topPath{
    UIBezierPath *topPath = [UIBezierPath bezierPath];
    [topPath moveToPoint:CGPointMake(0, 2.817)];
    [topPath addLineToPoint:CGPointMake(3.57, 2.817)];
    [topPath addLineToPoint:CGPointMake(3.57, 0)];
    [topPath addLineToPoint:CGPointMake(0, 0)];
    [topPath closePath];
    [topPath moveToPoint:CGPointMake(0, 2.817)];
    
    return topPath;
}

- (UIBezierPath*)leftTopPath{
    UIBezierPath * leftTopPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 7, 2)];
    return leftTopPath;
}

- (UIBezierPath*)leftTop_0Path{
    UIBezierPath * leftTop_0Path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1, 2)];
    return leftTop_0Path;
}

- (UIBezierPath*)rightTopPath{
    UIBezierPath * rightTopPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 7, 2)];
    return rightTopPath;
}

- (UIBezierPath*)leftBottomPath{
    UIBezierPath * leftBottomPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 7, 2)];
    return leftBottomPath;
}

- (UIBezierPath*)rightBottomPath{
    UIBezierPath * rightBottomPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 7, 2)];
    return rightBottomPath;
}

@end
