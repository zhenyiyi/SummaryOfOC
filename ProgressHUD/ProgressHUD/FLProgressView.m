//
//  FLProgressView.m
//  ProgressHUD
//
//  Created by fenglin on 6/30/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "FLProgressView.h"


static const CGFloat kPadding = 4.f;
static const CGFloat kLabelFontSize = 16.f;
static const CGFloat kDetailsLabelFontSize = 12.f;



@interface FLProgressView(){
    CGAffineTransform _rotationTransform;
    UILabel *_label;
    UILabel *_detailsLabel;
    BOOL _isFinished; // 动画是否完成。
}
@property (atomic, strong) NSDate *showStarted; //显示的时间。
@property (atomic, strong) UIView *indicator;   // 指示器View。

@end

@implementation FLProgressView

//+ (instancetype)showHUDAddtoView:(UIView *)view animated:(BOOL)animated{
//    
//}
//
//+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated{
//    
//}
//
//+ (NSUInteger)hideAllHUDFromView:(UIView *)view animated:(BOOL)animated{
//    
//}
//
//+ (instancetype)initHUDForView:(UIView *)view{
//    
//}
//
//+ (NSArray *)allHUDsForView:(UIView *)view{
//    
//}






#pragma mark - Lifecycle

- (instancetype)initWithWindow:(UIWindow *)window{
    return [self initWithView:window];
}

- (instancetype)initWithView:(UIView *)view{
    NSAssert(view != nil, @"view must not be nil");
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 显示隐藏时的动画模式
        self.animationType = FLProgressHUDAnimationFade;
        
        // 默认指示器是菊花
        self.mode = FLProgressHUDModeIndeterminate;
        
        // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
        self.opaque = NO;
        
        // 使背景颜色为透明
        self.backgroundColor = [UIColor clearColor];
        
        // 即使用户创建了一个hud,并调用了addSubview方法
        // 没有调用show也是不能显示的.在这之前要使hud隐藏并且不能接受触摸事件
        // 透明度为0(小于等于0.01),相当于hidden,无法响应触摸事件
        self.alpha = 0.0f;
        
        _rotationTransform = CGAffineTransformIdentity;
        
        _isFinished = NO;
        
        // 设置label和detailLabel
        [self setupLabels];
        // 设置指示器
        [self updateIndicators];
        
        [self registerForKVO];
        
        
        [self registerForNotifications];
    }
    return self;
}

- (void)dealloc{
    [self unregisterFromKVO];
}





- (void)setupLabels{
    
    self.labelText = nil;
    self.labelFont = [UIFont boldSystemFontOfSize:kLabelFontSize];
    self.labelColor = [UIColor whiteColor];
    self.detailsLabelText = nil;
    self.detailsLabelFont = [UIFont boldSystemFontOfSize:kDetailsLabelFontSize];
    self.detailsLabelColor = [UIColor whiteColor];
    
    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.adjustsFontSizeToFitWidth = NO;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.opaque = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = self.labelColor;
    _label.font = self.labelFont;
    _label.text = self.labelText;
    [self addSubview:_label];
    
    
    _detailsLabel= [[UILabel alloc] initWithFrame:self.bounds];
    _detailsLabel.adjustsFontSizeToFitWidth = NO;
    _detailsLabel.textAlignment = NSTextAlignmentCenter;
    _detailsLabel.opaque = NO;
    _detailsLabel.backgroundColor = [UIColor clearColor];
    
    _detailsLabel.numberOfLines = 0;
    _detailsLabel.font = self.detailsLabelFont;
    _detailsLabel.textColor = self.detailsLabelColor;
    _detailsLabel.text = self.detailsLabelText;
    [self addSubview:_detailsLabel];
    
   
}

- (void)updateIndicators{
    
    BOOL isActivityIndicator = [_indicator isKindOfClass:[UIActivityIndicatorView class]];
    if (_mode == FLProgressHUDModeIndeterminate) {
        if (!isActivityIndicator) {
            // Update to indeterminate indicator
            [_indicator removeFromSuperview];
            self.indicator = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [(UIActivityIndicatorView *)_indicator startAnimating];
            [self addSubview:_indicator];
        }
        [(UIActivityIndicatorView *)_indicator setColor:self.activityIndicatorColor];

    }
    else if (_mode == FLProgressHUDModeDeterminateHorizontalBar) {
 
    }
    else if (_mode == FLProgressHUDModeIndeterminate || _mode == FLProgressHUDModeIndeterminate) {

    }
    else if (_mode == FLProgressHUDModeCustomView) {
   
    } else if (_mode == FLProgressHUDModeText) {
        [_indicator removeFromSuperview];
        self.indicator = nil;
    }

}

#pragma mark -- Layout
- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    UIView *parent = self.superview;
    if (parent) {
        self.frame = parent.bounds;
    }
    
    CGRect bounds = self.bounds;
    
}


#pragma mark - KVO

- (void)registerForKVO{
    for (NSString * keypath  in [self observerKeypaths]) {
        [self addObserver:self forKeyPath:keypath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)unregisterFromKVO{
    for (NSString * keypath  in [self observerKeypaths]){
        [self removeObserver:self forKeyPath:keypath];
    }
}

- (NSArray *)observerKeypaths{
   return @[@"labelText",@"labelFont",@"labelColor",@"detailsLabelText",@"detailsLabelFont",@"detailsLabelColor",@"opacity",@"color",@"cornerRadius",@"activityIndicatorColor"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    }else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath{
    if ([keyPath isEqualToString:@""] || [keyPath isEqualToString:@""] || [keyPath isEqualToString:@""]) {
        
    } else if ([keyPath isEqualToString:@"labelText"]){
        _label.text =  self.labelText;
    } else if ([keyPath isEqualToString:@"labelFont"]){
        _label.font  = self.labelFont;
    } else if ([keyPath isEqualToString:@"labelColor"]){
        _label.textColor  = self.labelColor;
    } else if ([keyPath isEqualToString:@"detailsLabelText"]){
        _detailsLabel.text =  self.detailsLabelText;
    } else if ([keyPath isEqualToString:@"detailsLabelFont"]){
        _detailsLabel.font  = self.detailsLabelFont;
    } else if ([keyPath isEqualToString:@"detailsLabelColor"]){
        _detailsLabel.textColor  = self.detailsLabelColor;
    }
    //// 如果更改了label的字体,需要重新调用layoutSubviews
    [self  setNeedsLayout];
     // 设置标记,在下一个周期调用drawRect:方法重绘
    [self setNeedsDisplay];
}



#pragma mark -- notifications

- (void)registerForNotifications{
    
}



#pragma mark - Internal show & hide operations
- (void)showUsingAnimation:(BOOL)animated{
    // Cancel any scheduled hideDelayed : calls;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self setNeedsDisplay];
    
    // ZoomIn,ZoomOut分别理解为`拉近镜头`,`拉远镜头`
    // 因此MBProgressHUDAnimationZoomIn先把形变缩小到0.5倍,再恢复到原状,产生放大效果
    // 反之MBProgressHUDAnimationZoomOut先把形变放大到1.5倍,再恢复原状,产生缩小效果
    // 要注意的是,形变的是整个`MBProgressHUD`,而不是中间可视部分
    
    if (animated && _animationType == FLProgressHUDAnimationZoomIn) {
        
        // 在初始化方法中, 已经定义了rotationTransform = CGAffineTransformIdentity.
        // CGAffineTransformIdentity也就是对view不进行变形,对view进行仿射变化总是原样
        
        // CGAffineTransformConcat是两个矩阵相乘,与之等价的设置方式是:
//        self.transform = CGAffineTransformScale(_rotationTransform, 0.5, 0.5);
        self.transform = CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
    } else if (animated && _animationType == FLProgressHUDAnimationZoomOut){
//        self.transform = CGAffineTransformScale(_rotationTransform, 1.5, 1.5);
        self.transform = CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
    }
    
    self.showStarted = [NSDate date];
    
    if (animated) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.alpha = 1.0f;
        if (_animationType == FLProgressHUDAnimationZoomOut || _animationType == FLProgressHUDAnimationZoomIn) {
            self.transform = _rotationTransform;
        }
        [UIView commitAnimations];
    }else{
        self.alpha = 1.0f;
    }
}

// 隐藏HUD
- (void)hideUsingAnimation:(BOOL)animated{
    
    
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        self.alpha = 0.02f;
        if (_animationType == FLProgressHUDAnimationZoomOut || _animationType == FLProgressHUDAnimationZoomIn) {
            self.transform = _rotationTransform;
        }
        [UIView commitAnimations];
    }else{
        [self done];
    }
    self.showStarted = nil;
    
}
- (void)animationFinished:(NSString*)animationID finished:(BOOL)finished context:(void *)context{
    [self done];
}

- (void)done{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.alpha = 0.0f;
    _isFinished = YES;
    if (self.removeFromSuperViewOnHide) {
        [self removeFromSuperview];
    }
    if (self.completionBlcok) {
        self.completionBlcok();
    }
    
    if ([self respondsToSelector:@selector(hudWasHidden:)]) {
        [_delegate hudWasHidden:self];
    }
}



#pragma mark -- show&&hide
- (void)show:(BOOL)animated{
    [self showUsingAnimation:animated];
}

- (void)hide:(BOOL)animated{
    [self hideUsingAnimation:animated];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay{
    [self performSelector:@selector(hideDelay:) withObject:@(animated) afterDelay:delay];
}

- (void)hideDelay:(NSNumber *)delay{
    [self hide:[delay boolValue]];
}








@end
