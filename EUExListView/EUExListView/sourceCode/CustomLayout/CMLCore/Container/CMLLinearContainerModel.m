//
//  CMLLinearContainerModel.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLLinearContainerModel.h"

@implementation CMLLinearContainerModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.orientation=CMLLinearContainerOrientationVertical;
    }
    return self;
}
@end
