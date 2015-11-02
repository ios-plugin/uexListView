//
//  uexListViewCustomLayout.h
//  EUExListView
//
//  Created by CeriNo on 15/10/28.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//


@class EUExListView;


@interface uexListViewCustomLayout : NSObject
@property (nonatomic,weak)EUExListView *euexObj;
@property (nonatomic,assign)BOOL usingCustomLayout;



-(instancetype)initWithEuexListView:(EUExListView *)euexObj;
-(void)reset;


#pragma mark - uexAPI
-(void)openCustom:(NSMutableArray *)inArguments;



@end
