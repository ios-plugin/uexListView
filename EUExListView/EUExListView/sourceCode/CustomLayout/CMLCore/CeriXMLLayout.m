//
//  CeriXMLLayout.m
//  EUExListView
//
//  Created by CeriNo on 15/10/23.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CeriXMLLayout.h"


@implementation CeriXMLLayout
+(CMLBaseViewModel *)modelWithXMLData:(ONOXMLElement *)XMLData{
    if(!XMLData){
        return nil;
    }
    NSDictionary *typeParseDict=@{
                                  CMLTagLinearLayout:@(CMLViewModelLinearContainerModel),
                                  CMLTagRelativeLayout:@(CMLViewModelRelativeContainerModel),
                                  CMLTagImg:@(CMLViewModelImageViewModel),
                                  CMLTagButton:@(CMLViewModelButtonViewModel),
                                  CMLTagText:@(CMLViewModelTextViewModel),
                                  };
    NSString *typeStr =[[XMLData.tag CML_CLSTR]lowercaseString];
    if(![[typeParseDict allKeys] containsObject:typeStr]){
        return nil;
    }
    CMLViewModelType type=(CMLViewModelType)[typeParseDict[typeStr] integerValue];
    __kindof CMLBaseViewModel *model=nil;
    switch (type) {
        case CMLViewModelUndefined: {
            break;
        }
        case CMLViewModelLinearContainerModel: {
            model=[[CMLLinearContainerModel alloc]init];
            [model setupWithXMLData:XMLData];
            break;
        }
        case CMLViewModelRelativeContainerModel: {
            model=[[CMLRelativeContainerModel alloc]init];
            [model setupWithXMLData:XMLData];
            break;
        }
        case CMLViewModelImageViewModel: {
            model=[[CMLImageViewModel alloc]init];
            [model setupWithXMLData:XMLData];
            break;
        }
        case CMLViewModelButtonViewModel: {
            model=[[CMLButtonViewModel alloc]init];
            [model setupWithXMLData:XMLData];
            break;
        }
        case CMLViewModelTextViewModel: {
            model=[[CMLTextViewModel alloc]init];
            [model setupWithXMLData:XMLData];
            break;
        }
            
    }
    return model;
}
+(CMLBaseContainer *)CMLRootViewControllerWithModel:(__kindof CMLBaseViewModel *)model delegate:(id<CeriXMLLayoutDelegate>)delegate{
    __kindof CMLBaseViewController *controller=[self CMLViewControllerWithModel:model father:nil];
    if(!controller||![controller isKindOfClass:[CMLBaseContainer class]]){
        return nil;
    }
    CMLBaseContainer *rootViewController=controller;
    rootViewController.delegate=delegate;
    return rootViewController;
}
+(CMLBaseViewController *)CMLViewControllerWithModel:(__kindof CMLBaseViewModel *)model father:(__kindof CMLBaseContainer *)father{
    if(!model){
        return nil;
    }
    switch (model.type) {
        case CMLViewModelUndefined: {
            return nil;
            break;
        }
        case CMLViewModelLinearContainerModel: {
            return [[CMLLinearContainer alloc]initWithModel:model father:father];
            break;
        }
        case CMLViewModelRelativeContainerModel: {
            return [[CMLRelativeContainer alloc]initWithModel:model father:father];
            break;
        }
        case CMLViewModelImageViewModel: {
            return [[CMLImageViewController alloc]initWithModel:model father:father];
            break;
        }
        case CMLViewModelButtonViewModel: {
            return [[CMLBaseViewController alloc]initWithModel:model father:father];
            break;
        }
        case CMLViewModelTextViewModel: {
            return [[CMLTextViewController alloc]initWithModel:model father:father];
            break;
        }
            
    }
    
    
}

@end
