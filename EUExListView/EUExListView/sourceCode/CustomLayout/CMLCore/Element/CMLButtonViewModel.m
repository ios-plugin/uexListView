//
//  CMLButtonViewModel.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLButtonViewModel.h"

@implementation CMLButtonViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type=CMLViewModelButtonViewModel;
        self.maxLines=1;
        self.textColor=[UIColor blackColor];
        self.textSize=0;
        self.text=@"";
    }
    return self;
}


-(BOOL)updateValues:(id)values{
    if(![super updateValues:values]){
        return NO;
    }
    if(values[CMLPropertyText]){
        self.text=values[CMLPropertyText];
    }
    if(values[CMLPropertyTextSize]){
        self.textSize=[values[CMLPropertyTextSize] floatValue];
    }
    if(values[CMLPropertyTextColor]){
        self.textColor=[UIColor CML_ColorFromHtmlString:values[CMLPropertyTextColor]];
    }
    if(values[CMLPropertyMaxLines]){
        self.maxLines=[values[CMLPropertyMaxLines] integerValue];
    }
    return YES;
}
@end
