//
//  CMLAlignmentInfo.h
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/20.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMLUnidimensionalAlignment.h"


@interface CMLAlignmentInfo : NSObject
@property (nonatomic,strong)CMLUnidimensionalAlignment *xAlign;
@property (nonatomic,strong)CMLUnidimensionalAlignment *yAlign;

-(void)updateWithAttributes:(NSArray *)attributes;
@end
