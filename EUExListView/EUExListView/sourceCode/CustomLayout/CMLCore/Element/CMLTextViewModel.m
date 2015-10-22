//
//  CMLTextViewModel.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLTextViewModel.h"

@implementation CMLTextViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxLines=1;
        self.textColor=[UIColor blackColor];
        self.textSize=0;
        self.text=@"";
    }
    return self;
}
@end
