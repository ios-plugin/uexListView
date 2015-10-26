//
//  CMLCellScrollView.m
//  EUExListView
//
//  Created by CeriNo on 15/10/26.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLCellScrollView.h"

@implementation CMLCellScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:gestureRecognizer.view];
        return fabs(translation.y) <= fabs(translation.x);
    } else {
        return YES;
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGFloat yVelocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:gestureRecognizer.view].y;
        return fabs(yVelocity) <= 0.25;
    }
    return YES;
}

@end
