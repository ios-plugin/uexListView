//
//  CMLTextViewModel.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLTextViewModel.h"

@implementation CMLTextViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type=CMLViewModelTextViewModel;
        self.maxLines=1;
        self.textColor=[UIColor blackColor];
        self.textSize=0;
        self.text=@"";
    }
    return self;
}

-(BOOL)setupWithXMLData:(ONOXMLElement *)XMLData{
    if(![super setupWithXMLData:XMLData]){
        return NO;
    }
    if(XMLData[CMLPropertyText]){
        self.text=XMLData[CMLPropertyText];
    }
    if(XMLData[CMLPropertyTextSize]){
        self.textSize=[XMLData[CMLPropertyTextSize] floatValue];
    }
    if(XMLData[CMLPropertyTextColor]){
        self.textColor=[UIColor CML_ColorFromHtmlString:XMLData[CMLPropertyTextColor]];
    }
    if(XMLData[CMLPropertyMaxLines]){
        self.maxLines=[XMLData[CMLPropertyMaxLines] integerValue];
    }
    return YES;
}

@end
