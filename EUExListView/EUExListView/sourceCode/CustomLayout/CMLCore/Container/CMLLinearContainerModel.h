//
//  CMLLinearContainerModel.h
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLContainerModel.h"

typedef NS_ENUM(NSInteger,CMLLinearContainerOrientation) {
    CMLLinearContainerOrientationVertical,
    CMLLinearContainerOrientationHorizental
};


@interface CMLLinearContainerModel : CMLContainerModel
@property (nonatomic,assign)CMLLinearContainerOrientation orientation;
@end
