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
        self.scaleType=CMLImageScaleUndefined;
        self.webCacheOptions=1;
    }
    return self;
}
@end
