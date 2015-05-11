//
//  EUExListView.h
//  EUExListView
//
//  Created by liguofu on 14/12/4.
//  Copyright (c) 2014年 AppCan.can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUExBaseDefine.h"
#import "EUExBase.h"
#import "EUtility.h"
#import "JSON.h"
#import "SWTableViewCell.h"
#import "PullTableView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"

@interface EUExListView : EUExBase<UITableViewDataSource,UITableViewDelegate ,SWTableViewCellDelegate,PullTableViewDelegate>{
    
    BOOL currentStatus ;
}


@property (nonatomic, retain) PullTableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataItemsArr;
@property (nonatomic, retain) NSMutableArray *swipeOptionItemArr;

@property (nonatomic, retain) NSMutableDictionary *rightSwipeOptionItemDict;
@property (nonatomic, retain) NSMutableDictionary *leftSwipeOptionItemDict;
@property (nonatomic, retain) NSMutableArray *rightOptionBtnArr;
@property (nonatomic, retain) NSMutableArray *leftOptionBtnArr;

@property (nonatomic, retain) NSMutableDictionary *frameDict;
@property (nonatomic, retain) NSMutableDictionary *setItemsDict;
@property (nonatomic, retain) NSMutableDictionary *jsonDict;

@property (nonatomic, retain) SWTableViewCell *SWTcell;
@property (nonatomic, retain) NSString *moveItemsStr;
@property (nonatomic, retain) NSArray *insertItemsArr;
@property (nonatomic, retain) NSMutableDictionary *insertItemsDict;

@property (nonatomic, retain) NSArray *loadMoreItemsArr;
@property (nonatomic, retain) NSMutableDictionary *loadMoreItemsDict;

@property (nonatomic, assign) int setItemSwipeEnabled;
@property (nonatomic, retain) NSArray *deleteItemsArr;

@property (nonatomic, retain) NSMutableDictionary *setPullRefreshHeaderDict;
@property (nonatomic, retain) NSMutableDictionary *setPullRefreshFooterDict;
@property (nonatomic, retain) SWTableViewCell *cell;
@end
