//
//  CMLImageViewModel.h
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLBaseViewModel.h"
typedef NS_ENUM(NSInteger,CMLImageScaleType ) {
    CMLImageScaleUndefined,
    CMLImageScaleFitXY,
    CMLImageScaleCenter,
    CMLImageScaleCenterCrop,
    CMLImageScaleCenterInside
};

typedef NS_OPTIONS(NSInteger,CMLImageWebCacheOptions) {
    CMLImageWebCacheRefreshCached               = 1 << 0,
    CMLImageWebCacheOnlyMemory                  = 1 << 1,
    CMLImageWebCacheAllowInvalidSSLCertificates = 1 << 2,
    
};
@interface CMLImageViewModel : CMLBaseViewModel
@property (nonatomic,copy  ) NSString                *imageSrc;
@property (nonatomic,copy  ) NSString                *placeholderPath;
@property (nonatomic,assign) CMLImageScaleType       scaleType;
@property (nonatomic,assign) CMLImageWebCacheOptions webCacheOptions;
@end
