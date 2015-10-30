//
//  uexListViewCustomLayoutModel.h
//  EUExListView
//
//  Created by CeriNo on 15/10/29.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CMLTableViewCell.h"


typedef NS_ENUM(NSInteger,uexListViewCustomLayoutRefreshMode) {
    uexListViewCustomLayoutRefreshNone,
    uexListViewCustomLayoutRefreshTop,
    uexListViewCustomLayoutRefreshBottom,
    uexListViewCustomLayoutRefreshBothTopAndBottom
};
typedef NS_ENUM(NSInteger,uexListViewCustomLayoutSwipeType) {
    uexListViewCustomLayoutSwipeTypeOnlyRight,
    uexListViewCustomLayoutSwipeTypeOnlyLeft,
    uexListViewCustomLayoutSwipeTypeNone,
    uexListViewCustomLayoutSwipeTypeBothLeft
};
@class EUExListView;
@interface uexListViewCustomLayoutModel : NSObject

@property (nonatomic,weak)EUExListView *euexObj;

@property (nonatomic,strong)NSMutableDictionary *leftXMLDictionary;
@property (nonatomic,strong)NSMutableDictionary *centerXMLDictionary;
@property (nonatomic,strong)NSMutableDictionary *rightXMLDictionary;
@property (nonatomic,assign)uexListViewCustomLayoutRefreshMode refreshMode;
@property (nonatomic,assign)uexListViewCustomLayoutSwipeType swipeType;

@property (nonatomic,strong)NSMutableArray<CMLTableViewCellData *> *cellDataSource;

@property (nonatomic,assign)CGFloat leftSliderLimit,rightSliderLimit;

- (instancetype)initWithEUExListView:(EUExListView *)euexObj;

-(BOOL)parseXMLData:(NSDictionary *)info;
-(BOOL)parseRefreshMode:(NSDictionary *)info;
-(BOOL)parseSwipeType:(NSDictionary *)info;
-(BOOL)parseSliderWidth:(NSDictionary *)info;
-(BOOL)parseCellDataSource:(NSArray *)dataArray;

-(void)reset;
@end
