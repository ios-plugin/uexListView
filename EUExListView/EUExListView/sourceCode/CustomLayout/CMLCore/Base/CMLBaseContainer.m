//
//  CMLBaseContainer.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLBaseContainer.h"

@interface CMLBaseContainer()

@end


@implementation CMLBaseContainer


- (instancetype)initWithModel:(CMLBaseViewModel *)model father:(CMLBaseContainer *)father
{
    self = [super initWithModel:model father:father];
    if (self) {
        self.isRootViewController=NO;
        CMLContainerModel *containerModel=self.model;
        if([containerModel.childrenModels count]>0){
            self.childrenViewControllers=[NSMutableArray array];
            for(CMLBaseViewModel *model in containerModel.childrenModels){
                CMLBaseViewController * aViewController =[CMLBaseViewController CMLViewControllerWithModel:model father:self];
                if(aViewController){
                    [self.childrenViewControllers addObject:aViewController];
                }
            }
        }

    }
    return self;
}


-(void)becomeRoot{
    self.isRootViewController=YES;
    [self.model becomeRoot];
    self.namedViewControllers=[NSMutableDictionary dictionary];
}

-(void)addAChange{
    if(self != [self getRoot]){
        
        [super addAChange];
        
    }else if(self.isRootViewController){
        CMLContainerModel *rootModel=self.model;
        rootModel.changeCount++;
    }
}

-(void)finishAChange{
    if(self != [self getRoot]){
        
        [super addAChange];
        
    }else if(self.isRootViewController){
        CMLContainerModel *rootModel=self.model;
        
        rootModel.changeCount--;
        if(rootModel.changeCount <=0){
            rootModel.changeCount=0;
            if(self.delegate && [self.delegate respondsToSelector:@selector(CMLRootViewControllerDidChangeUI:)]){
                [self.delegate CMLRootViewControllerDidChangeUI:self];
            }
        }
    }
}
@end
