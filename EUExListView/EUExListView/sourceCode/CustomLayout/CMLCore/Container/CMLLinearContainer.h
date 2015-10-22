//
//  CMLLinearContainer.h
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLBaseContainer.h"
#import "CMLLinearContainerModel.h"
@interface CMLLinearContainer : CMLBaseContainer
@property (nonatomic,strong)NSMutableArray<__kindof CMLBaseViewController*> *weightedChildrenViewControllers;
@end
