//
//  KVOMutableArray+ReactiveCocoaSupport.h
//  Pods
//
//  Created by Lono on 2015/6/1.
//
//

#import "KVOMutableArray.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface KVOMutableArray (ReactiveCocoaSupport)
- (RACSignal*)changeSignal;
@end
