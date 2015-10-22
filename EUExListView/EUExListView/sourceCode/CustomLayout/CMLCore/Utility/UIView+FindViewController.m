//
//  UIView+FindViewController.m
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/12.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import "UIView+FindViewController.h"

@implementation UIView (FindViewController)
-(UIViewController *)CML_ViewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
