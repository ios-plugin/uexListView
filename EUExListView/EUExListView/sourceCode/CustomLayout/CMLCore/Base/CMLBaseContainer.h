//
//  CMLBaseContainer.h
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLBaseViewController.h"
#import "CMLContainerModel.h"
@class CMLBaseContainer;
@protocol CeriXMLLayoutDelegate <NSObject>

@optional

-(void)CMLRootViewControllerDidChangeUI:(CMLBaseContainer*)rootViewController;

@end




@interface CMLBaseContainer : CMLBaseViewController

@property (nonatomic,strong) NSMutableArray<__kindof CMLBaseViewController *>        *childrenViewControllers;

//properties only for root view controller
@property (nonatomic,strong) NSDictionary          *infoDict;
@property (nonatomic,assign) BOOL                  isRootViewController;
@property (nonatomic,strong) NSMutableDictionary   *namedViewControllers;
@property (nonatomic,weak  ) id<CeriXMLLayoutDelegate> delegate;




@end
