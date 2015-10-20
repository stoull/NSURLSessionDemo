//
//  CCIndicatorView.m
//  
//
//  Created by 杜强海 on 10/17/15.
//
//

#import "CCIndicatorView.h"

@implementation CCIndicatorView

- (void)setProgress:(double)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *downloadProgressPath = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = MIN(self.bounds.size.width/2, self.bounds.size.height/2);
    [downloadProgressPath addArcWithCenter:center radius:radius-5 startAngle:3*M_PI/2 endAngle:3*M_PI/2 + self.progress*2*M_PI clockwise:YES];
    downloadProgressPath.lineWidth = 4;
    if (!self.indicatorColor) {
        [[UIColor colorWithRed:0.3 green:0.5 blue:0.9 alpha:1.0] setStroke];
    }else {
        [self.indicatorColor setStroke];
    }
    [downloadProgressPath stroke];
}


@end
