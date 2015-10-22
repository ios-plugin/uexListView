//
//  CMLConstant.h
//  CeriXMLLayout
//
//  Created by CeriNo on 15/9/20.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import <Foundation/Foundation.h>


//tag keys
extern NSString *const CMLTagRelativeLayout;
extern NSString *const CMLTagLinearLayout;
extern NSString *const CMLTagImg;
extern NSString *const CMLTagText;
extern NSString *const CMLTagButton;


//property name keys
extern NSString *const CMLPropertyId;
extern NSString *const CMLPropertyWidth;
extern NSString *const CMLPropertyHeight;
extern NSString *const CMLPropertyPadding;
extern NSString *const CMLPropertyMargin;
extern NSString *const CMLPropertyGravity;
extern NSString *const CMLPropertyBackground;
extern NSString *const CMLPropertyFloat;
extern NSString *const CMLPropertyRelation;
extern NSString *const CMLPropertySrc;
extern NSString *const CMLPropertyWebCacheOption;
extern NSString *const CMLPropertyPlaceholder;
extern NSString *const CMLPropertyScaleType;
extern NSString *const CMLPropertyText;
extern NSString *const CMLPropertyTextSize;
extern NSString *const CMLPropertyTextColor;
extern NSString *const CMLPropertyMaxLines;
extern NSString *const CMLPropertyOrientation;
extern NSString *const CMLPropertyWeight;
extern NSString *const CMLPropertyOnClick;

//property mapping keys
typedef id (^CMLPropertyMappingBlock)(id);


extern NSString *const  CMLMappingFilePathKey;
