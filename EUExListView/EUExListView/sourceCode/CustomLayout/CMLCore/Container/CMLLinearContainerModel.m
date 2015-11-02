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
        self.type=CMLViewModelLinearContainerModel;
        self.orientation=CMLLinearContainerOrientationVertical;
    }
    return self;
}
-(BOOL)updateValues:(id)values{
    if(![super updateValues:values]){
        return NO;
    }
    if(values[CMLPropertyOrientation]){
        NSString *orientationInfo =[[values[CMLPropertyOrientation] CML_CLSTR]lowercaseString];
        if([orientationInfo isEqual:@"horizontal"]){
            self.orientation=CMLLinearContainerOrientationHorizental;
        }else if([orientationInfo isEqual:@"vertical"]){
            self.orientation=CMLLinearContainerOrientationVertical;

        }
    }
    return YES;
}
@end
