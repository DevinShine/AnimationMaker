//
//  CheckSwitch.m
//
//  Code generated using QuartzCode 1.40.0 on 16/9/1.
//  www.quartzcodeapp.com
//

#import "CheckSwitch.h"
#import "QCMethod.h"

@interface CheckSwitch ()

@property (nonatomic, strong) NSMutableDictionary * layers;
@property (nonatomic, strong) NSMapTable * completionBlocks;
@property (nonatomic, assign) BOOL  updateLayerValueForCompletedAnimation;

@property (nonatomic) BOOL animating;
@property (nonatomic) BOOL isOpen;

@end

@implementation CheckSwitch

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupProperties];
        [self setupLayers];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupProperties];
        [self setupLayers];
    }
    return self;
}

-(void)tapped:(UITapGestureRecognizer *)tapped{
    __weak typeof(self)weakself = self;
    
    if (self.animating == YES) {
        return;
    }
    
    if (self.isOpen) {
        // open->close
        [self addCloseAnimationAnimationCompletionBlock:^(BOOL finished) {
            weakself.animating = NO;
            weakself.isOpen = NO;
        }];
    }else{
        // close->open
        [self addOpenAnimationAnimationCompletionBlock:^(BOOL finished) {
            weakself.animating = NO;
            weakself.isOpen = YES;
        }];
    }
    
    self.animating = YES;
    
    
}



- (void)setupProperties{
    self.completionBlocks = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory valueOptions:NSPointerFunctionsStrongMemory];;
    self.layers = [NSMutableDictionary dictionary];
    
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGes];
}

- (void)setupLayers{
    
    CAShapeLayer * roundedRect = [CAShapeLayer layer];
    roundedRect.frame = CGRectMake(5, 4, 190, 90);
    roundedRect.path = [self roundedRectPath].CGPath;
    [self.layer addSublayer:roundedRect];
    self.layers[@"roundedRect"] = roundedRect;
    
    CAShapeLayer * bg = [CAShapeLayer layer];
    bg.frame = CGRectMake(11, 9, 80, 80);
    bg.path = [self bgPath].CGPath;
    [self.layer addSublayer:bg];
    self.layers[@"bg"] = bg;
    
    CAShapeLayer * left = [CAShapeLayer layer];
    left.frame = CGRectMake(30.73, 31.04, 37.63, 37.63);
    left.path = [self leftPath].CGPath;
    [self.layer addSublayer:left];
    self.layers[@"left"] = left;
    
    CAShapeLayer * right = [CAShapeLayer layer];
    right.frame = CGRectMake(32.19, 30.19, 37.63, 37.63);
    right.path = [self rightPath].CGPath;
    [self.layer addSublayer:right];
    self.layers[@"right"] = right;
    
    CAShapeLayer * leftSmall = [CAShapeLayer layer];
    leftSmall.frame = CGRectMake(16.69, 55.31, 14, 14);
    leftSmall.path = [self leftSmallPath].CGPath;
    [self.layer addSublayer:leftSmall];
    self.layers[@"leftSmall"] = leftSmall;
    
    [self resetLayerPropertiesForLayerIdentifiers:nil];
}

- (void)resetLayerPropertiesForLayerIdentifiers:(NSArray *)layerIds{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if(!layerIds || [layerIds containsObject:@"roundedRect"]){
        CAShapeLayer * roundedRect = self.layers[@"roundedRect"];
        roundedRect.fillColor = [UIColor whiteColor].CGColor;
        roundedRect.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"bg"]){
        CAShapeLayer * bg = self.layers[@"bg"];
        bg.fillColor = [UIColor colorWithRed:0.949 green: 0.89 blue:0.827 alpha:1].CGColor;
        bg.lineWidth = 0;
    }
    if(!layerIds || [layerIds containsObject:@"left"]){
        CAShapeLayer * left = self.layers[@"left"];
        left.anchorPoint = CGPointMake(0, 0);
        left.frame       = CGRectMake(30.73, 31.04, 37.63, 37.63);
        left.lineCap     = kCALineCapRound;
        left.fillColor   = nil;
        left.strokeColor = [UIColor whiteColor].CGColor;
        left.lineWidth   = 3;
    }
    if(!layerIds || [layerIds containsObject:@"right"]){
        CAShapeLayer * right = self.layers[@"right"];
        [right setValue:@(-90 * M_PI/180) forKeyPath:@"transform.rotation"];
        right.lineCap     = kCALineCapRound;
        right.fillColor   = nil;
        right.strokeColor = [UIColor whiteColor].CGColor;
        right.lineWidth   = 3;
    }
    if(!layerIds || [layerIds containsObject:@"leftSmall"]){
        CAShapeLayer * leftSmall = self.layers[@"leftSmall"];
        leftSmall.hidden      = YES;
        leftSmall.lineCap     = kCALineCapRound;
        leftSmall.fillColor   = nil;
        leftSmall.strokeColor = [UIColor whiteColor].CGColor;
        leftSmall.lineWidth   = 3;
    }
    
    [CATransaction commit];
}

#pragma mark - Animation Setup

- (void)addCloseAnimationAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock{
    if (completionBlock){
        CABasicAnimation * completionAnim = [CABasicAnimation animationWithKeyPath:@"completionAnim"];;
        completionAnim.duration = 0.3;
        completionAnim.delegate = self;
        [completionAnim setValue:@"CheckAnimation" forKey:@"animId"];
        [completionAnim setValue:@(NO) forKey:@"needEndAnim"];
        [self.layer addAnimation:completionAnim forKey:@"CheckAnimation"];
        [self.completionBlocks setObject:completionBlock forKey:[self.layer animationForKey:@"CheckAnimation"]];
    }
    
    NSString * fillMode = kCAFillModeForwards;
    
    ////Bg animation
    CAKeyframeAnimation * bgFillColorAnim = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
    bgFillColorAnim.values                = @[(id)[UIColor colorWithRed:0.494 green: 0.525 blue:0.98 alpha:1].CGColor,
                                              (id)[UIColor colorWithRed:0.949 green: 0.89 blue:0.827 alpha:1].CGColor];
    bgFillColorAnim.keyTimes              = @[@0, @1];
    bgFillColorAnim.duration              = 0.3;
    bgFillColorAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * bgPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    bgPositionAnim.values                = @[[NSValue valueWithCGPoint:CGPointMake(151, 49)], [NSValue valueWithCGPoint:CGPointMake(51, 49)]];
    bgPositionAnim.keyTimes              = @[@0, @1];
    bgPositionAnim.duration              = 0.3;
    bgPositionAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup * bgCheckAnimationAnim = [QCMethod groupAnimations:@[bgFillColorAnim, bgPositionAnim] fillMode:fillMode];
    [self.layers[@"bg"] addAnimation:bgCheckAnimationAnim forKey:@"bgCheckAnimationAnim"];
    
    ////Left animation
    CAKeyframeAnimation * leftPathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    leftPathAnim.values                = @[(id)[QCMethod alignToBottomPath:[self leftSmallPath] layer:self.layers[@"left"]].CGPath, (id)[QCMethod alignToBottomPath:[self leftPath] layer:self.layers[@"left"]].CGPath];
    leftPathAnim.keyTimes              = @[@0, @1];
    leftPathAnim.duration              = 0.3;
    leftPathAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * leftPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    leftPositionAnim.values                = @[[NSValue valueWithCGPoint:CGPointMake(140, 92)], [NSValue valueWithCGPoint:CGPointMake(30.725, 31.039)]];
    leftPositionAnim.keyTimes              = @[@0, @1];
    leftPositionAnim.duration              = 0.3;
    leftPositionAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * leftTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    leftTransformAnim.values         = @[@(-180 * M_PI/180),
                                         @(0)];
    leftTransformAnim.keyTimes       = @[@0, @1];
    leftTransformAnim.duration       = 0.3;
    leftTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup * leftCheckAnimationAnim = [QCMethod groupAnimations:@[leftPathAnim, leftPositionAnim, leftTransformAnim] fillMode:fillMode];
    [self.layers[@"left"] addAnimation:leftCheckAnimationAnim forKey:@"leftCheckAnimationAnim"];
    
    ////Right animation
    CAKeyframeAnimation * rightTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rightTransformAnim.values         = @[@(-270 * M_PI/180),
                                          @(-90 * M_PI/180)];
    rightTransformAnim.keyTimes       = @[@0, @1];
    rightTransformAnim.duration       = 0.3;
    rightTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * rightPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    rightPositionAnim.values         = @[[NSValue valueWithCGPoint:CGPointMake(159, 50)], [NSValue valueWithCGPoint:CGPointMake(51, 49)]];
    rightPositionAnim.keyTimes       = @[@0, @1];
    rightPositionAnim.duration       = 0.3;
    rightPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup * rightCheckAnimationAnim = [QCMethod groupAnimations:@[rightTransformAnim, rightPositionAnim] fillMode:fillMode];
    [self.layers[@"right"] addAnimation:rightCheckAnimationAnim forKey:@"rightCheckAnimationAnim"];
}

- (void)addOpenAnimationAnimation{
    [self addOpenAnimationAnimationCompletionBlock:nil];
}

- (void)addOpenAnimationAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock{
    if (completionBlock){
        CABasicAnimation * completionAnim = [CABasicAnimation animationWithKeyPath:@"completionAnim"];;
        completionAnim.duration = 0.3;
        completionAnim.delegate = self;
        [completionAnim setValue:@"CheckAnimation" forKey:@"animId"];
        [completionAnim setValue:@(NO) forKey:@"needEndAnim"];
        [self.layer addAnimation:completionAnim forKey:@"CheckAnimation"];
        [self.completionBlocks setObject:completionBlock forKey:[self.layer animationForKey:@"CheckAnimation"]];
    }
    
    NSString * fillMode = kCAFillModeForwards;
    
    ////Bg animation
    CAKeyframeAnimation * bgFillColorAnim = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
    bgFillColorAnim.values                = @[(id)[UIColor colorWithRed:0.949 green: 0.89 blue:0.827 alpha:1].CGColor,
                                              (id)[UIColor colorWithRed:0.494 green: 0.525 blue:0.98 alpha:1].CGColor];
    bgFillColorAnim.keyTimes              = @[@0, @1];
    bgFillColorAnim.duration              = 0.3;
    bgFillColorAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * bgPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    bgPositionAnim.values                = @[[NSValue valueWithCGPoint:CGPointMake(51, 49)], [NSValue valueWithCGPoint:CGPointMake(151, 49)]];
    bgPositionAnim.keyTimes              = @[@0, @1];
    bgPositionAnim.duration              = 0.3;
    bgPositionAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup * bgCheckAnimationAnim = [QCMethod groupAnimations:@[bgFillColorAnim, bgPositionAnim] fillMode:fillMode];
    [self.layers[@"bg"] addAnimation:bgCheckAnimationAnim forKey:@"bgCheckAnimationAnim"];
    
    ////Left animation
    CAKeyframeAnimation * leftPathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    leftPathAnim.values                = @[(id)[QCMethod alignToBottomPath:[self leftPath] layer:self.layers[@"left"]].CGPath, (id)[QCMethod alignToBottomPath:[self leftSmallPath] layer:self.layers[@"left"]].CGPath];
    leftPathAnim.keyTimes              = @[@0, @1];
    leftPathAnim.duration              = 0.3;
    leftPathAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * leftPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    leftPositionAnim.values                = @[[NSValue valueWithCGPoint:CGPointMake(30.725, 31.039)], [NSValue valueWithCGPoint:CGPointMake(140, 92)]];
    leftPositionAnim.keyTimes              = @[@0, @1];
    leftPositionAnim.duration              = 0.3;
    leftPositionAnim.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * leftTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    leftTransformAnim.values         = @[@(0),
                                         @(-180 * M_PI/180)];
    leftTransformAnim.keyTimes       = @[@0, @1];
    leftTransformAnim.duration       = 0.3;
    leftTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup * leftCheckAnimationAnim = [QCMethod groupAnimations:@[leftPathAnim, leftPositionAnim, leftTransformAnim] fillMode:fillMode];
    [self.layers[@"left"] addAnimation:leftCheckAnimationAnim forKey:@"leftCheckAnimationAnim"];
    
    ////Right animation
    CAKeyframeAnimation * rightTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rightTransformAnim.values         = @[@(-90 * M_PI/180),
                                          @(-270 * M_PI/180)];
    rightTransformAnim.keyTimes       = @[@0, @1];
    rightTransformAnim.duration       = 0.3;
    rightTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation * rightPositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    rightPositionAnim.values         = @[[NSValue valueWithCGPoint:CGPointMake(51, 49)], [NSValue valueWithCGPoint:CGPointMake(159, 50)]];
    rightPositionAnim.keyTimes       = @[@0, @1];
    rightPositionAnim.duration       = 0.3;
    rightPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup * rightCheckAnimationAnim = [QCMethod groupAnimations:@[rightTransformAnim, rightPositionAnim] fillMode:fillMode];
    [self.layers[@"right"] addAnimation:rightCheckAnimationAnim forKey:@"rightCheckAnimationAnim"];
}

#pragma mark - Animation Cleanup

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    void (^completionBlock)(BOOL) = [self.completionBlocks objectForKey:anim];;
    if (completionBlock){
        [self.completionBlocks removeObjectForKey:anim];
        if ((flag && self.updateLayerValueForCompletedAnimation) || [[anim valueForKey:@"needEndAnim"] boolValue]){
            [self updateLayerValuesForAnimationId:[anim valueForKey:@"animId"]];
            [self removeAnimationsForAnimationId:[anim valueForKey:@"animId"]];
        }
        completionBlock(flag);
    }
}

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
    if([identifier isEqualToString:@"CheckAnimation"]){
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"bg"] animationForKey:@"bgCheckAnimationAnim"] theLayer:self.layers[@"bg"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"left"] animationForKey:@"leftCheckAnimationAnim"] theLayer:self.layers[@"left"]];
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"right"] animationForKey:@"rightCheckAnimationAnim"] theLayer:self.layers[@"right"]];
    }
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
    if([identifier isEqualToString:@"CheckAnimation"]){
        [self.layers[@"bg"] removeAnimationForKey:@"bgCheckAnimationAnim"];
        [self.layers[@"left"] removeAnimationForKey:@"leftCheckAnimationAnim"];
        [self.layers[@"right"] removeAnimationForKey:@"rightCheckAnimationAnim"];
    }
}

- (void)removeAllAnimations{
    [self.layers enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
        [layer removeAllAnimations];
    }];
}

#pragma mark - Bezier Path

- (UIBezierPath*)roundedRectPath{
    UIBezierPath * roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 190, 90) cornerRadius:45];
    return roundedRectPath;
}

- (UIBezierPath*)bgPath{
    UIBezierPath * bgPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 80, 80)];
    return bgPath;
}

- (UIBezierPath*)leftPath{
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(0, 0)];
    [leftPath addLineToPoint:CGPointMake(37.626, 37.626)];
    
    return leftPath;
}

- (UIBezierPath*)rightPath{
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    [rightPath moveToPoint:CGPointMake(0, 0)];
    [rightPath addLineToPoint:CGPointMake(37.626, 37.626)];
    
    return rightPath;
}

- (UIBezierPath*)leftSmallPath{
    UIBezierPath *leftSmallPath = [UIBezierPath bezierPath];
    [leftSmallPath moveToPoint:CGPointMake(0, 0)];
    [leftSmallPath addLineToPoint:CGPointMake(14, 14)];
    
    return leftSmallPath;
}


@end
