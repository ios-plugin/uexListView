//
//  CMLContainerModel.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLContainerModel.h"

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
@end
