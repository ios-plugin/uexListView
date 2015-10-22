//
//  NSString+ClearString.m
//  CeriXMLLayout
//
//  Created by CeriNo on 15/9/20.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#import "NSString+ClearString.h"

@implementation NSString (ClearString)


-(NSString *)CML_CLSTR{
    
    if(!self){
        return nil;
    }else{
       return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
}
@end
