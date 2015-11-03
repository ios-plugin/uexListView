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


@property (nonatomic,strong)__kindof CMLContainerModel *centerViewModel,*leftSliderModel,*rightSliderModel;
@property (nonatomic,assign)CGFloat leftSliderOffset,rightSliderOffset;
@property (nonatomic,assign)CGFloat leftSliderWidth,rightSliderWidth;
@property (nonatomic,assign)CMLTableViewCellState state;
@property (nonatomic,assign)BOOL cellShouldHideSliderOnSwipe;
@property (nonatomic,strong)NSArray *centerDefaultSettings, *leftDefaultSettings,*rightDefaultSettings;


@end
