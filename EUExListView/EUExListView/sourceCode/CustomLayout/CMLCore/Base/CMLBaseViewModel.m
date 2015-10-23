//
//  CMLBaseViewModel.m
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/20.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import "CMLBaseViewModel.h"
#import "CMLLinearContainerModel.h"
#import "CMLRelativeContainerModel.h"
#import "CMLTextViewModel.h"
#import "CMLImageViewModel.h"
#import "CMLButtonViewModel.h"
@implementation CMLBaseViewModel




- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type=CMLViewModelUndefined;
        self.identifier = @"";
        self.width  = -2;
        self.height = -2;
        self.weight = 0;
        self.bgString = @"#00000000";
        self.margin = [[CMLEdgeDifference alloc] initWithLeft:0 top:0 right:0 bottom:0];
        self.padding = [[CMLEdgeDifference alloc] initWithLeft:0 top:0 right:0 bottom:0];

        self.relations = [KVOMutableArray new];
        self.gravityInfo=[[CMLAlignmentInfo alloc]init];
        self.floatInfo=[[CMLAlignmentInfo alloc]init];
        
        self.onSingleClickInfo=@"";
        

    }
    return self;
}

-(BOOL)setupWithXMLData:(ONOXMLElement *)XMLData{
    if(!XMLData){
        return NO;
    }
    if(XMLData[CMLPropertyWidth]){
        self.width=[XMLData[CMLPropertyWidth] floatValue];
    }
    if(XMLData[CMLPropertyHeight]){
        self.height=[XMLData[CMLPropertyHeight] floatValue];
    }
    if(XMLData[CMLPropertyWeight]){
        self.weight=[XMLData[CMLPropertyWeight] floatValue];
    }
    if(XMLData[CMLPropertyBackground]){
        self.bgString=XMLData[CMLPropertyBackground];
    }
    if(XMLData[CMLPropertyPadding]){
        [self.padding updateValueWithAttributes:[[XMLData[CMLPropertyPadding] CML_CLSTR] componentsSeparatedByString:@" "]];
    }
    if(XMLData[CMLPropertyMargin]){
        [self.margin updateValueWithAttributes:[[XMLData[CMLPropertyMargin] CML_CLSTR] componentsSeparatedByString:@" "]];
    }
    if(XMLData[CMLPropertyGravity]){
        [self.gravityInfo updateWithAttributes:[[XMLData[CMLPropertyGravity] CML_CLSTR]componentsSeparatedByString:@"|"]];
    }
    if(XMLData[CMLPropertyFloat]){
        [self.floatInfo updateWithAttributes:[[XMLData[CMLPropertyFloat] CML_CLSTR]componentsSeparatedByString:@"|"]];
    }

    if(XMLData[CMLPropertyRelation]){
        NSArray *relations=[[XMLData[CMLPropertyRelation] CML_CLSTR] componentsSeparatedByString:@";"];
        [self.relations removeAllObjects];
        for(int i=0;i<[relations count];i++){
            CMLElementRelation *aRelation=[[CMLElementRelation alloc]initWithDataString:relations[i]];
            if(aRelation){
                [self.relations addObject:aRelation];
            }
        }
    }
    if(XMLData[CMLPropertyId]){
        self.identifier=[[XMLData[CMLPropertyId] CML_toString] CML_CLSTR];
    }
    if(XMLData[CMLPropertyOnClick]){
        self.onSingleClickInfo=[XMLData[CMLPropertyOnClick] CML_CLSTR];
    }
    return YES;



    
}
@end
