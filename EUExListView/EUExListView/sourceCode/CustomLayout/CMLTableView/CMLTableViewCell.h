//
//  CMLTableViewCell.h
//  EUExListView
//
//  Created by CeriNo on 15/10/23.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLTableViewCellData.h"





@interface CMLTableViewCell : UITableViewCell



-(void)modifyWithTableView:(__kindof UITableView *)tableView
                      data:(CMLTableViewCellData *)data;
@end
