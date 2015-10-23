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
-(BOOL)setupWithXMLData:(ONOXMLElement *)XMLData{
    if(![super setupWithXMLData:XMLData]){
        return NO;
    }
    if(XMLData[CMLPropertyOrientation]){
        NSString *orientationInfo =[[XMLData[CMLPropertyOrientation] CML_CLSTR]lowercaseString];
        if([orientationInfo isEqual:@"horizontal"]){
            self.orientation=CMLLinearContainerOrientationHorizental;
        }else if([orientationInfo isEqual:@"vertical"]){
            self.orientation=CMLLinearContainerOrientationVertical;

        }
    }
    return YES;
}
@end
