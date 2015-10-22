//
//  CMLElementRelation.m
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/21.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import "CMLElementRelation.h"

@implementation CMLElementRelation






- (instancetype)initWithDataString:(NSString *)dataStr
{
    self = [super init];
    if (self) {
        NSArray *data=[[[dataStr CML_CLSTR]lowercaseString]componentsSeparatedByString:@","];
        if([data count]<2){
            return nil;
        }
        NSArray *relationArray=@[@"above",@"leftof",@"below",@"rightof"];
        if(![relationArray containsObject:[[data[0] CML_CLSTR]lowercaseString]]){
            return nil;
        }
        self.type=(CMLElementRelationType)[relationArray indexOfObject:[[data[0] CML_CLSTR]lowercaseString]];
        self.targetId=[data[1] CML_toString];
        self.offset=0;
        if([data count]>2){
            self.offset=[data[2] floatValue];
        }
        
    }
    return self;
}
@end
