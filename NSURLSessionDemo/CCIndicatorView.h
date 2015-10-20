//
//  CCIndicatorView.h
//  
//
//  Created by 杜强海 on 10/17/15.
//
//

#import <UIKit/UIKit.h>

@interface CCIndicatorView : UIView

/**
 *显示进度
 */
@property (nonatomic,assign) double progress;

/**
 *设置进度条颜色
 */
@property (nonatomic,strong) UIColor *indicatorColor;

@end
