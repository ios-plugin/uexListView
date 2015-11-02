//
//  CeriXMLLayout.h
//  EUExListView
//
//  Created by CeriNo on 15/10/23.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMLImageViewController.h"
#import "CMLImageViewModel.h"
#import "CMLButtonViewController.h"
#import "CMLButtonViewModel.h"
#import "CMLTextViewController.h"
#import "CMLTextViewModel.h"
#import "CMLRelativeContainer.h"
#import "CMLRelativeContainerModel.h"
#import "CMLLinearContainer.h"
#import "CMLLinearContainerModel.h"

@interface CeriXMLLayout : NSObject


+ (__kindof CMLBaseContainer *)CMLRootViewControllerWithModel:(__kindof CMLBaseViewModel*)model delegate:(id<CeriXMLLayoutDelegate>)delegate;
+ (__kindof CMLBaseViewController *)CMLViewControllerWithModel:(__kindof CMLBaseViewModel *)model father:(__kindof CMLBaseContainer *)father;
+ (__kindof CMLBaseViewModel *)modelWithXMLData:(ONOXMLElement *)XMLData;


@end
