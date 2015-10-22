//
//  CMLEdgeDifference.h
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/21.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMLEdgeDifference : NSObject
@property (nonatomic,assign)CGFloat left;
@property (nonatomic,assign)CGFloat top;
@property (nonatomic,assign)CGFloat right;
@property (nonatomic,assign)CGFloat bottom;
-(instancetype)initWithLeft:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom;

-(void)updateValueWithAttributes:(NSArray *)attributes;
-(RACSignal *)edgeDifferenceDidChangeSignal;
@end
