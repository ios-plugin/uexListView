//
//  CMLContainerModel.h
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLBaseViewModel.h"
#import "CMLMappingCenter.h"
@interface CMLContainerModel : CMLBaseViewModel

@property (nonatomic,strong)NSMutableArray<__kindof CMLBaseViewModel*> * childrenModels;


-(void)becomeRoot;
@property (nonatomic,strong)CMLMappingCenter *mappingCenter;
@property (nonatomic,assign)BOOL isRootModel;
@property (nonatomic,assign)NSInteger changeCount;
@end
