//
//  CMLImageViewModel.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLImageViewModel.h"

@implementation CMLImageViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type=CMLViewModelImageViewModel;
        self.scaleType=CMLImageScaleUndefined;
        self.webCacheOptions=1;
    }
    return self;
}
-(BOOL)setupWithXMLData:(ONOXMLElement *)XMLData{
    if(![super setupWithXMLData:XMLData]){
        return NO;
    }
    if(XMLData[CMLPropertySrc]){
        self.imageSrc=[XMLData[CMLPropertySrc] CML_CLSTR];
    }
    if(XMLData[CMLPropertyPlaceholder]){
        self.placeholderPath=[XMLData[CMLPropertyPlaceholder] CML_CLSTR];
    }
    if(XMLData[CMLPropertyScaleType]){
        NSString *scaleTypeString=[[XMLData[CMLPropertyScaleType] CML_CLSTR]lowercaseString];
        self.scaleType =
        ([scaleTypeString isEqualToString:@"fitxy"])        ?CMLImageScaleFitXY:
        ([scaleTypeString isEqualToString:@"centercrop"])   ?CMLImageScaleCenterCrop:
        ([scaleTypeString isEqualToString:@"centerinside"]) ?CMLImageScaleCenterInside:CMLImageScaleCenter;
        
    }
    if(XMLData[CMLPropertyWebCacheOption]){
        self.webCacheOptions=[XMLData[CMLPropertyWebCacheOption] integerValue];
    }
    return YES;
}
@end
