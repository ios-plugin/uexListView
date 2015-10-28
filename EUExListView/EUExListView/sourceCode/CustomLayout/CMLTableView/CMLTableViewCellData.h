//
//  CMLTableViewCellData.h
//  EUExListView
//
//  Created by CeriNo on 15/10/26.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CeriXMLLayout.h"


typedef NS_ENUM(NSInteger,CMLTableViewCellState) {
    CMLTableViewCellStateLeft,
    CMLTableViewCellStateCenter,
    CMLTableViewCellStateRight
};


@interface CMLTableViewCellData : NSObject

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)__kindof CMLContainerModel *leftSliderModel,*rightSliderModel;
@property (nonatomic,assign)CGFloat leftSliderOffset,rightSliderOffset;
@property (nonatomic,assign)CMLTableViewCellState state;
@property (nonatomic,assign)BOOL cellShouldHideSliderOnSwipe;
@end
