//
//  CMLTableViewCell.h
//  EUExListView
//
//  Created by CeriNo on 15/10/23.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLTableViewCellData.h"
@class CMLTableViewCell;
@protocol  CMLTableViewCellDelegate<NSObject>

@optional
-(void)CMLTableViewCellDidChangeUI:(CMLTableViewCell *)cell;
-(void)CMLTableViewCell:(CMLTableViewCell *)cell didTriggerSingleClickEventFromCMLViewController:(__kindof CMLBaseViewController *)controller;
@end



@interface CMLTableViewCell : UITableViewCell
@property id<CMLTableViewCellDelegate> delegate;


-(void)modifyWithTableView:(__kindof UITableView *)tableView
                      data:(CMLTableViewCellData *)data
                  delegate:(id<CMLTableViewCellDelegate>)delegate;


-(void)hideSlidersAnimated:(BOOL)animated;
@end
