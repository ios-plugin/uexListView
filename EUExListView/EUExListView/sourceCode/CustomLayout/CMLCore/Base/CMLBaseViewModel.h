//
//  CMLBaseViewModel.h
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/20.
//  Copyright © 2015年 Vheissu. All rights reserved.
//


#import "CMLAlignmentInfo.h"
#import "CMLEdgeDifference.h"
#import "CMLElementRelation.h"
#import "ONOXMLDocument.h"

typedef NS_ENUM(NSInteger,CMLViewModelType) {
    CMLViewModelUndefined,
    //container
    CMLViewModelLinearContainerModel,
    CMLViewModelRelativeContainerModel,
    //Element
    CMLViewModelImageViewModel,
    CMLViewModelButtonViewModel,
    CMLViewModelTextViewModel,
};




@interface CMLBaseViewModel : NSObject

@property (nonatomic,assign) CMLViewModelType  type;

@property (nonatomic,copy  ) NSString          *identifier;
@property (nonatomic,assign) CGFloat           width;
@property (nonatomic,assign) CGFloat           height;
@property (nonatomic,assign) CGFloat           weight;
@property (nonatomic,copy  ) NSString          *bgString;
@property (nonatomic,strong) CMLAlignmentInfo  *gravityInfo;
@property (nonatomic,strong) CMLAlignmentInfo  *floatInfo;
@property (nonatomic,strong) CMLEdgeDifference *margin;
@property (nonatomic,strong) CMLEdgeDifference *padding;
@property (nonatomic,strong) KVOMutableArray   *relations;


@property (nonatomic,strong) NSString *onSingleClickInfo;






-(BOOL)updateValues:(id)values;

@end
