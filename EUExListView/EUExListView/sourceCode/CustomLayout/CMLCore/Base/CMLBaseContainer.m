//
//  CMLBaseContainer.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLBaseContainer.h"
#import "CeriXMLLayout.h"
@interface CMLBaseContainer()

@end


@implementation CMLBaseContainer

-(void)viewDidLoad{
    [super viewDidLoad];
    if(self.childrenViewControllers){
        for(int i=0;i<[self.childrenViewControllers count];i++){
            [self.innerView addSubview:self.childrenViewControllers[i].view];
            
        }
    }
}

- (instancetype)initWithModel:(CMLBaseViewModel *)model father:(CMLBaseContainer *)father
{
    self = [super initWithModel:model father:father];
    if (self) {
        self.isRootViewController=NO;
        if(!father){
            [self becomeRoot];
        }
        
        CMLContainerModel *containerModel=self.model;
        if([containerModel.childrenModels count]>0){
            self.childrenViewControllers=[NSMutableArray array];
            for(CMLBaseViewModel *model in containerModel.childrenModels){
                __kindof CMLBaseViewController * aViewController =[CeriXMLLayout CMLViewControllerWithModel:model father:self];
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
        NSLog(@"add:%ld",(long)rootModel.changeCount);
    }
}

-(void)finishAChange{
    if(self != [self getRoot]){
        
        [super addAChange];
        
    }else if(self.isRootViewController){
        CMLContainerModel *rootModel=self.model;
        
        rootModel.changeCount--;
        NSLog(@"finish:%ld",(long)rootModel.changeCount);
        if(rootModel.changeCount <=0){
            rootModel.changeCount=0;
            if(self.delegate && [self.delegate respondsToSelector:@selector(CMLRootViewControllerDidChangeUI:)]){
                [self.delegate CMLRootViewControllerDidChangeUI:self];
            }
        }
    }
}
-(void)handleSingleClickEvent:(__kindof CMLBaseViewController *)viewController{
    if (!self.isRootViewController) {
        return;
    }

    if(self.delegate && [self.delegate respondsToSelector:@selector(CMLViewControllerDidTriggerSingleClickEvent:)]){
        [self.delegate CMLViewControllerDidTriggerSingleClickEvent:viewController];
    }
}
-(void)updateValuesByInfoArray:(NSArray *)infoArray{
    for(NSDictionary *info in infoArray){
        
        [self updateValuesWithInfo:info];
    }
}



-(void)updateValuesWithInfo:(NSDictionary *)infoValues{
    if(!self.isRootViewController||!infoValues ||![infoValues isKindOfClass:[NSDictionary class]]){
        return;
    }
    NSMutableDictionary *info=[NSMutableDictionary dictionaryWithDictionary:infoValues];
    if(![info objectForKey:CMLPropertyId]){
        return;
    }
    __kindof CMLBaseViewController *aVC =[self.namedViewControllers objectForKey:[[info objectForKey:CMLPropertyId] CML_toString]];
    if(!aVC){
        return;
    }
    [info removeObjectForKey:CMLPropertyId];
    [aVC.model updateValues:info];
}

-(UIView*)makeInnerView{
    UIView *innerView =[[UIView alloc]init];
    innerView.userInteractionEnabled=YES;

    
    return innerView;
}

@end
