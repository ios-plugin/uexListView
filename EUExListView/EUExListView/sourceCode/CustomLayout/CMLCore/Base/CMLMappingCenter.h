//
//  CMLMappingCenter.h
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef id(^CMLMappingBlock)(id);

@interface CMLMappingCenter : NSObject


@property (nonatomic,strong)CMLMappingBlock filePathMappingBlock;

-(NSString *)mappingFilePath:(NSString *)filePath;
@end
