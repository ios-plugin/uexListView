//
//  uexListViewCustomLayout.m
//  EUExListView
//
//  Created by CeriNo on 15/10/28.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//


#import "JSON.h"
#import "uexListViewCustomLayout.h"
#import "EUExListView.h"
#import "EUtility.h"
#import "uexListViewCustomLayoutModel.h"
#import <MJRefresh/MJRefresh.h>

#define to_string(x) #x
#define to_nsstring(x) [NSString stringWithCString:to_string(x) encoding:NSUTF8StringEncoding]
#define fetch_cgfloat_necessarily(x) CGFloat x =([info objectForKey:to_nsstring(x)]?[info[to_nsstring(x)] floatValue]:(isSuccess=NO,1))


NSString  *const customLayoutTableViewCellIdentifier = @"customLayoutTableViewCellIdentifier";

@interface uexListViewCustomLayout()<UITableViewDelegate,UITableViewDataSource,CMLTableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)uexListViewCustomLayoutModel *model;
@end



@implementation uexListViewCustomLayout
- (instancetype)initWithEuexListView:(EUExListView *)euexObj
{
    self = [super init];
    if (self) {
        self.euexObj=euexObj;
        self.usingCustomLayout=NO;
        self.model=[[uexListViewCustomLayoutModel alloc] init];

    }
    return self;
}

-(void)reset{
    self.usingCustomLayout=NO;
    [self.model reset];
    if(self.tableView){
        [self.tableView removeFromSuperview];
        self.tableView=nil;
    }
}
#pragma mark - uex API

-(void)openCustom:(NSMutableArray *)inArguments{
    if([inArguments count] < 1){
        return;
    }
    id info = [inArguments[0] JSONValue];
    if(!info || ![info isKindOfClass:[NSDictionary class]]){
        return;
    }

    [self reset];
    if(![self parseListViewFrame:info]||![self.model parseXMLData:info]||![self.model parseSliderWidth:info]||![self.model parseSwipeType:info]||![self.model parseRefreshMode:info]){
        return;
    }
    if([info objectForKey:@"data"] && [info[@"data"] isKindOfClass:[NSArray class]]){
        [self.model parseCellDataSource:info[@"data"]];
    }
    if([self openListView]){
        self.usingCustomLayout=YES;
    }

    
}

#pragma mark - private method;

-(BOOL)parseListViewFrame:(NSDictionary *)info{
    BOOL isSuccess=YES;
    
    //fetch_cgfloat_necessarily(left);
    //CGFloat x =([info objectForKey:to_nsstring(x)]?[info[to_nsstring(x)] floatValue]:(isSuccess=NO,1));
    fetch_cgfloat_necessarily(left);
    fetch_cgfloat_necessarily(top);
    fetch_cgfloat_necessarily(width);
    fetch_cgfloat_necessarily(height);
    if(!isSuccess){
        return NO;
    }
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(left, top, width, height) style:UITableViewStylePlain];
    
    return YES;
}

-(BOOL)openListView{
    [self.tableView registerClass:[CMLTableViewCell class] forCellReuseIdentifier:customLayoutTableViewCellIdentifier];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    return YES;

}

-(BOOL)setRefresh{
    //header
    MJRefreshHeader *header=[MJRefreshHeader headerWithRefreshingBlock:^{
        
    }];
    [RACObserve(header, state) subscribeNext:^(id x) {
        MJRefreshState headerState =(MJRefreshState)[x integerValue];
        switch (headerState) {
            case MJRefreshStateWillRefresh:{
                
                break;
            }
            case MJRefreshStatePulling:{
                break;
            }
            case MJRefreshStateRefreshing:{
                break;
            }
            default:{
                break;
            }
        }
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.model.cellDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - UITableViewDelegate
@end
