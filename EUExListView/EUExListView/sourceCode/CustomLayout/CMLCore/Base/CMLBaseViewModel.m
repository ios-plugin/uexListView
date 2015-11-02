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



-(BOOL)updateValues:(id)values{
    if(!values){
        return NO;
    }
    if(![values isKindOfClass:[ONOXMLElement class]] && ![values isKindOfClass:[NSDictionary class]]){
        return NO;
    }
    
    if(values[CMLPropertyWidth]){
        self.width=[values[CMLPropertyWidth] floatValue];
    }
    if(values[CMLPropertyHeight]){
        self.height=[values[CMLPropertyHeight] floatValue];
    }
    if(values[CMLPropertyWeight]){
        self.weight=[values[CMLPropertyWeight] floatValue];
    }
    if(values[CMLPropertyBackground]){
        self.bgString=values[CMLPropertyBackground];
    }
    if(values[CMLPropertyPadding]){
        [self.padding updateValueWithAttributes:[[values[CMLPropertyPadding] CML_CLSTR] componentsSeparatedByString:@" "]];
    }
    if(values[CMLPropertyMargin]){
        [self.margin updateValueWithAttributes:[[values[CMLPropertyMargin] CML_CLSTR] componentsSeparatedByString:@" "]];
    }
    if(values[CMLPropertyGravity]){
        [self.gravityInfo updateWithAttributes:[[values[CMLPropertyGravity] CML_CLSTR]componentsSeparatedByString:@"|"]];
    }
    if(values[CMLPropertyFloat]){
        [self.floatInfo updateWithAttributes:[[values[CMLPropertyFloat] CML_CLSTR]componentsSeparatedByString:@"|"]];
    }
    
    if(values[CMLPropertyRelation]){
        NSArray *relations=[[values[CMLPropertyRelation] CML_CLSTR] componentsSeparatedByString:@";"];
        [self.relations removeAllObjects];
        for(int i=0;i<[relations count];i++){
            CMLElementRelation *aRelation=[[CMLElementRelation alloc]initWithDataString:relations[i]];
            if(aRelation){
                [self.relations addObject:aRelation];
            }
        }
    }
    if(values[CMLPropertyId]){
        self.identifier=[[values[CMLPropertyId] CML_toString] CML_CLSTR];
    }
    if(values[CMLPropertyOnClick]){
        self.onSingleClickInfo=[values[CMLPropertyOnClick] CML_CLSTR];
    }
    return YES;

}
@end
