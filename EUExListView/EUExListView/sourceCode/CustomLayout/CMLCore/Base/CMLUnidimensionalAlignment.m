//
//  CMLUnidimensionalAlignment.m
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/20.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import "CMLUnidimensionalAlignment.h"

@interface CMLUnidimensionalAlignment()
@property (nonatomic,strong)RACSignal *aligmentDidChangeSignal;
@end

@implementation CMLUnidimensionalAlignment
-(instancetype)initWithType:(CMLAlignmentType)type offset:(CGFloat)offset{
    self=[super init];
    if(self){
        self.type=type;
        self.offset=offset;
        
    }
    return self;
}




-(RACSignal *)aligmentDidChangeSignal{
    if(!_aligmentDidChangeSignal){
        @weakify(self);
        _aligmentDidChangeSignal= [[RACSignal combineLatest:@[[RACObserve(self, type) distinctUntilChanged],[RACObserve(self, offset) distinctUntilChanged]]]flattenMap:^RACStream *(id value) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                [subscriber sendNext:self];
                return nil;
            }];
        }];

    }
    return _aligmentDidChangeSignal;
}
@end
