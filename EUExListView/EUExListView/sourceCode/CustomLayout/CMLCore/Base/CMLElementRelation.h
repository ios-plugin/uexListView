//
//  CMLElementRelation.h
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/21.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CMLElementRelationType) {
    CMLElementRelationAbove=0,
    CMLElementRelationLeftOf=1,
    CMLElementRelationBelow=2,
    CMLElementRelationRightOf=3
};


@interface CMLElementRelation : NSObject
@property (nonatomic,strong)NSString *targetId;
@property (nonatomic,assign)CMLElementRelationType type;
@property (nonatomic,assign)CGFloat offset;

-(instancetype)initWithDataString:(NSString *)dataStr;
@end
