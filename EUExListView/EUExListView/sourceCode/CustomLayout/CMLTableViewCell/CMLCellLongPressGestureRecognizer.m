//
//  CMLCellLongPressGestureRecognizer.m
//  EUExListView
//
//  Created by CeriNo on 15/10/26.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLCellLongPressGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
@implementation CMLCellLongPressGestureRecognizer
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
}
@end
