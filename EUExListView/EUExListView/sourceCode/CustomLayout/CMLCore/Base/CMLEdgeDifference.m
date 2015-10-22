//
//  CMLEdgeDifference.m
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/21.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import "CMLEdgeDifference.h"


#define setAttributes(l,t,r,b); {\
self.left=[attributes[l] floatValue];\
self.top=[attributes[t] floatValue];\
self.right=[attributes[r] floatValue];\
self.bottom=[attributes[b] floatValue];\
}


@interface CMLEdgeDifference()
@property (nonatomic,strong)RACSignal *edgeDifferenceDidChangeSignal;
@end
@implementation CMLEdgeDifference
- (instancetype)initWithLeft:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    self = [super init];
    if (self) {
        self.left=left;
        self.top=top;
        self.right=right;
        self.bottom=bottom;
    }
    return self;
}


-(void)updateValueWithAttributes:(NSArray *)attributes{
    if([attributes count]>3){
        setAttributes(0, 1, 2, 3)
    }else if([attributes count]>1){
        setAttributes(0, 1, 0, 1);
    }else if([attributes count]==1){
        setAttributes(0, 0, 0, 0);
    }
}



-(RACSignal *)edgeDifferenceDidChangeSignal{
    if(_edgeDifferenceDidChangeSignal){
        @weakify(self);
        _edgeDifferenceDidChangeSignal=[[RACSignal combineLatest:@[[RACObserve(self, left) distinctUntilChanged],[RACObserve(self, top) distinctUntilChanged],[RACObserve(self, right) distinctUntilChanged],[RACObserve(self, bottom) distinctUntilChanged]]]flattenMap:^RACStream *(id value) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                [subscriber sendNext:self];
                return nil;
            }];
        }];
    }
    return _edgeDifferenceDidChangeSignal;
}
@end
