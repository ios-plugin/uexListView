//
//  CMLMappingCenter.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLMappingCenter.h"

@implementation CMLMappingCenter
-(NSString *)mappingFilePath:(NSString *)filePath{
    if(self.filePathMappingBlock){
        return (NSString *)self.filePathMappingBlock(filePath);
    }
    return filePath;
}
@end
