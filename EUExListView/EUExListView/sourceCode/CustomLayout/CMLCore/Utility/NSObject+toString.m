//
//  NSObject+toString.m
//  CeriXMLLayout
//
//  Created by CeriNo on 15/9/20.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import "NSObject+toString.h"

@implementation NSObject (toString)
-(NSString *)CML_toString{
    if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self stringValue];
    }
    if([self isKindOfClass:[NSString class]]){
        return (NSString *)self;
    }
    return nil;
}
@end
