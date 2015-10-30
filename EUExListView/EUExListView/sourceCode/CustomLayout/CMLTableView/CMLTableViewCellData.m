//
//  CMLTableViewCellData.m
//  EUExListView
//
//  Created by CeriNo on 15/10/26.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLTableViewCellData.h"

@implementation CMLTableViewCellData
- (instancetype)initWithCenterModel:(__kindof CMLContainerModel *)centerViewModel
                    leftSliderModel:(__kindof CMLContainerModel *)leftSliderModel
                   rightSliderModel:(__kindof CMLContainerModel *)rightSliderModel
{
    self = [super init];
    if (self) {
        self.leftSliderWidth=-1;
        self.rightSliderWidth=-1;
        self.leftSliderOffset=0;
        self.rightSliderOffset=0;
        self.state=CMLTableViewCellStateCenter;
        self.cellShouldHideSliderOnSwipe=YES;
    }
    return self;
}
@end
