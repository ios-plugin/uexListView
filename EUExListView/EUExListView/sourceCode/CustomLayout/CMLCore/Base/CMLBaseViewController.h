//
//  CMLBaseViewController.h
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMLBaseViewModel.h"









@class CMLBaseContainer;


@interface CMLBaseViewController : UIViewController

@property (nonatomic,weak)__kindof CMLBaseContainer *father;




-(instancetype)initWithModel:(__kindof CMLBaseViewModel *)model father:(__kindof CMLBaseContainer *)father;

-(CMLBaseContainer *)getRoot;


@property (nonatomic,strong) __kindof UIView * innerView;
@property (nonatomic,strong) __kindof CMLBaseViewModel *model;

-(void)addAChange;
-(void)finishAChange;
-(__kindof UIView*)makeInnerView;
@end
