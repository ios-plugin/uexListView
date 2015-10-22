//
//  CMLAlignmentInfo.m
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/20.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import "CMLAlignmentInfo.h"
@interface CMLAlignmentInfo()

@end



@implementation CMLAlignmentInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.xAlign=[[CMLUnidimensionalAlignment alloc]initWithType:CMLAlignmentIgnored offset:0];
        self.yAlign=[[CMLUnidimensionalAlignment alloc]initWithType:CMLAlignmentIgnored offset:0];
    }
    return self;
}

-(void)updateWithAttributes:(NSArray *)attributes{
    if(!attributes){
        return;
    }
    [attributes enumerateObjectsUsingBlock:^(NSString *  _Nonnull attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        if([[[attribute CML_CLSTR]lowercaseString] isEqual:@"left"]){
            self.xAlign.type=CMLAlignmentHead;
        }
        if([[[attribute CML_CLSTR]lowercaseString] isEqual:@"centerx"]){
            self.xAlign.type=CMLAlignmentMiddle;
        }
        if([[[attribute CML_CLSTR]lowercaseString] isEqual:@"right"]){
            self.xAlign.type=CMLAlignmentTail;
        }
        if([[[attribute CML_CLSTR]lowercaseString] isEqual:@"top"]){
            self.yAlign.type=CMLAlignmentHead;
        }
        if([[[attribute CML_CLSTR]lowercaseString] isEqual:@"centery"]){
            self.yAlign.type=CMLAlignmentMiddle;
        }
        if([[[attribute CML_CLSTR]lowercaseString] isEqual:@"bottom"]){
            self.yAlign.type=CMLAlignmentTail;
        }
        if([[[attribute CML_CLSTR]lowercaseString] isEqual:@"center"]){
            self.xAlign.type=CMLAlignmentMiddle;
            self.yAlign.type=CMLAlignmentMiddle;
        }
    }];

}
@end
