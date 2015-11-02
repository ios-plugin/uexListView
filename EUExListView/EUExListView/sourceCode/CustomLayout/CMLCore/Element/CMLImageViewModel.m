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
-(BOOL)updateValues:(id)values{
    if(![super updateValues:values]){
        return NO;
    }
    if(values[CMLPropertySrc]){
        self.imageSrc=[values[CMLPropertySrc] CML_CLSTR];
    }
    if(values[CMLPropertyPlaceholder]){
        self.placeholderPath=[values[CMLPropertyPlaceholder] CML_CLSTR];
    }
    if(values[CMLPropertyScaleType]){
        NSString *scaleTypeString=[[values[CMLPropertyScaleType] CML_CLSTR]lowercaseString];
        self.scaleType =
        ([scaleTypeString isEqualToString:@"fitxy"])        ?CMLImageScaleFitXY:
        ([scaleTypeString isEqualToString:@"centercrop"])   ?CMLImageScaleCenterCrop:
        ([scaleTypeString isEqualToString:@"centerinside"]) ?CMLImageScaleCenterInside:CMLImageScaleCenter;
        
    }
    if(values[CMLPropertyWebCacheOption]){
        self.webCacheOptions=[values[CMLPropertyWebCacheOption] integerValue];
    }
    return YES;
}
@end
