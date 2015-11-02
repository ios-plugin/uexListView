//
//  CMLContainerModel.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLContainerModel.h"
#import "CeriXMLLayout.h"
@implementation CMLContainerModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isRootModel=NO;
        self.childrenModels=[NSMutableArray array];
        self.changeCount=0;
        
    }
    return self;
}

-(void)becomeRoot{
    self.isRootModel=YES;
    self.mappingCenter=[[CMLMappingCenter alloc]init];
}

-(BOOL)updateValues:(id)values{
    if(![super updateValues:values]){
        return NO;
    }
    if(![values isKindOfClass:[ONOXMLElement class]]){
        return YES;
    }
    ONOXMLElement *XMLData=values;
    NSArray * xmlChildren =[XMLData children];
    for(int i=0;i<[xmlChildren count];i++){
        if([[xmlChildren objectAtIndex:i] isKindOfClass:[ONOXMLElement class]]){
            if(!self.childrenModels){
                self.childrenModels=[NSMutableArray array];
            }
            __kindof CMLBaseViewModel *model =[CeriXMLLayout modelWithXMLData:xmlChildren[i]];
            if(model){
                [self.childrenModels addObject:model];

                
            }

        }
    }

    return YES;
}
@end
