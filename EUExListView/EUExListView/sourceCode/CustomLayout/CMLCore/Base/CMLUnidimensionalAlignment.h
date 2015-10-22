//
//  CMLUnidimensionalAlignment.h
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/20.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,CMLAlignmentType) {
    CMLAlignmentIgnored,
    CMLAlignmentHead,
    CMLAlignmentMiddle,
    CMLAlignmentTail,
};

@interface CMLUnidimensionalAlignment : NSObject
@property (nonatomic,assign)CMLAlignmentType type;
@property (nonatomic,assign)CGFloat offset;

-(RACSignal *)aligmentDidChangeSignal;
-(instancetype)initWithType:(CMLAlignmentType)type offset:(CGFloat)offset;


@end
