//
//  uexListViewCustomLayoutModel.h
//  EUExListView
//
//  Created by CeriNo on 15/10/29.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CMLTableViewCell.h"



@class EUExListView;

#define uexLVCL_check_if_not_dictionary(x)   ( (!x) || (![x isKindOfClass:[NSDictionary class]]))

@interface uexListViewCustomLayoutModel : NSObject






typedef NS_ENUM(NSInteger,uexListViewCustomLayoutRefreshMode) {
    uexListViewCustomLayoutRefreshNone=0,
    uexListViewCustomLayoutRefreshTop,
    uexListViewCustomLayoutRefreshBottom,
    uexListViewCustomLayoutRefreshBothTopAndBottom,
};
typedef NS_ENUM(NSInteger,uexListViewCustomLayoutSwipeType) {
    uexListViewCustomLayoutSwipeTypeOnlyRight=0,
    uexListViewCustomLayoutSwipeTypeOnlyLeft,
    uexListViewCustomLayoutSwipeTypeNone,
    uexListViewCustomLayoutSwipeTypeBothLeftAndRight,
};
 


@property (nonatomic,weak)EUExListView *euexObj;

@property (nonatomic,strong,readonly)NSMutableDictionary *leftXMLDictionary;
@property (nonatomic,strong,readonly)NSMutableDictionary *centerXMLDictionary;
@property (nonatomic,strong,readonly)NSMutableDictionary *rightXMLDictionary;
@property (nonatomic,assign,readonly)uexListViewCustomLayoutRefreshMode refreshMode;
@property (nonatomic,assign,readonly)uexListViewCustomLayoutSwipeType swipeType;

@property (nonatomic,strong,readonly)NSMutableArray<CMLTableViewCellData *> *cellDataSource;

@property (nonatomic,assign)CGFloat leftSliderLimit,rightSliderLimit;

- (instancetype)initWithEUExListView:(EUExListView *)euexObj;

-(BOOL)parseXMLData:(NSDictionary *)info;
-(BOOL)parseRefreshMode:(NSDictionary *)info;
-(BOOL)parseSwipeType:(NSDictionary *)info;
-(BOOL)parseSliderWidth:(NSDictionary *)info;


-(void)resetCellDataSource:(NSArray *)dataArray;


-(void)addCellData:(NSDictionary *)dataInfo;
-(void)reset;

@end
