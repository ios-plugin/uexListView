//
//  uexListViewCustomLayout.m
//  EUExListView
//
//  Created by CeriNo on 15/10/28.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "uexListViewCustomLayout.h"
#import "CMLTableViewCell.h"
@interface uexListViewCustomLayout()<UITableViewDelegate>
@property (nonatomic,strong)NSMutableDictionary *leftXMLDictionary;
@property (nonatomic,strong)NSMutableDictionary *centerXMLDictionary;
@property (nonatomic,strong)NSMutableDictionary *rightXMLDictionary;
@property (nonatomic,strong)NSMutableArray<CMLTableViewCellData *> *cellDataSource;
@property (nonatomic,strong)UITableView *tableView;
@end
@implementation uexListViewCustomLayout
- (instancetype)initWithEuexListView:(EUExListView *)euexObj
{
    self = [super init];
    if (self) {
        self.euexObj=euexObj;
        self.usingCustomLayout=NO;
        self.leftXMLDictionary=[NSMutableDictionary dictionary];
        self.centerXMLDictionary=[NSMutableDictionary dictionary];
        self.rightXMLDictionary=[NSMutableDictionary dictionary];
        self.cellDataSource=[NSMutableArray array];
        
    }
    return self;
}

-(void)reset{
    self.usingCustomLayout=NO;
    [self.leftXMLDictionary removeAllObjects];
    [self.centerXMLDictionary removeAllObjects];
    [self.rightXMLDictionary removeAllObjects];
    [self.cellDataSource removeAllObjects];
    if(self.tableView){
        [self.tableView removeFromSuperview];
        self.tableView=nil;
    }
}
@end
