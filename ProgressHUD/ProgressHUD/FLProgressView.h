//
//  FLProgressView.h
//  ProgressHUD
//
//  Created by fenglin on 6/30/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger , FLProgressViewMode) {
    
    /** 默认模式,使用系统自带的指示器 ,不能显示进度,只能不停地转呀转*/
    FLProgressHUDModeIndeterminate,
    /** 用饼图显示进度 */
    FLProgressHUDModeDeterminate,
    /** 进度条 */
    FLProgressHUDModeDeterminateHorizontalBar,
    /** 圆环 */
    FLProgressHUDModeAnnularDeterminate,
    /** 自定义视图 */
    FLProgressHUDModeCustomView,
    /** 只显示文字 */
    FLProgressHUDModeText
};


typedef NS_ENUM(NSInteger, FLProgressHUDAnimation) {
    /** Opacity animation */
    FLProgressHUDAnimationFade,  ///< 默认效果,只有透明度变化的动画效果
    /** Opacity + scale animation  透明度变化+形变效果  */
    FLProgressHUDAnimationZoom,
    FLProgressHUDAnimationZoomOut = FLProgressHUDAnimationZoom,
    FLProgressHUDAnimationZoomIn
};

typedef void (^FLProgressViewCompletionBlcok)();


@protocol FLProgressHUDDelegate ;


@interface FLProgressView : UIView

// 文本框和其相关属性
@property (copy) NSString *labelText;
@property (strong) UIFont* labelFont;
@property (strong) UIColor* labelColor;

//详情文本框和其相关属性
@property (copy) NSString *detailsLabelText;
@property (strong) UIFont* detailsLabelFont;
@property (strong) UIColor* detailsLabelColor;


// 背景框的透明度，默认值是0.8
@property (assign) float opacity;
// 背景框的颜色, 如果设置了这个属性，则opacity属性会失效，即不会有半透明效果
@property (strong) UIColor *color;
// 背景框的圆角半径。默认值是10.0
@property (assign) float cornerRadius;
// 菊花的颜色，默认是白色
@property (strong) UIColor *activityIndicatorColor;



@property (assign) FLProgressHUDAnimation animationType;

@property (assign) FLProgressViewMode mode;

// 隐藏的时候是否 删除
@property (assign) BOOL removeFromSuperViewOnHide;

@property (copy) FLProgressViewCompletionBlcok completionBlcok;

@property (weak) id<FLProgressHUDDelegate> delegate;



+ (instancetype)showHUDAddtoView:(UIView *)view animated:(BOOL)animated;

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

+ (NSUInteger)hideAllHUDFromView:(UIView *)view animated:(BOOL)animated;

+ (instancetype)initHUDForView:(UIView *)view;

+ (NSArray *)allHUDsForView:(UIView *)view;


- (instancetype)initWithView:(UIView *)view;

- (instancetype)initWithWindow:(UIWindow *)window;



- (void)show:(BOOL)animates;

- (void)hide:(BOOL)animated;

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end



@protocol FLProgressHUDDelegate <NSObject>

- (void)hudWasHidden:(FLProgressView *)hud;

@end
