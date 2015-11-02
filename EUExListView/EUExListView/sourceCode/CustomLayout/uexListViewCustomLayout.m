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

#define fetch_cgfloat_necessarily(x) CGFloat x =([info objectForKey:CML_TO_NSSTRING(x)]?[info[CML_TO_NSSTRING(x)] floatValue]:(isSuccess=NO,1))


typedef NS_ENUM(NSInteger,uexListViewCustomLayoutRefreshStatus) {
    uexListViewCustomLayoutRefreshStatusBegin=0,
    uexListViewCustomLayoutRefreshStatusRefreshing,
    uexListViewCustomLayoutRefreshStatusFinish
};

typedef NS_ENUM(NSInteger,uexListViewCustomLayoutRefreshObject){
    uexListViewCustomLayoutRefreshHeader,
    uexListViewCustomLayoutRefreshFooter
};



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
    if(uexLVCL_check_if_not_dictionary(info)){
        return;
    }

    [self reset];
    if(![self parseListViewFrame:info]||![self.model parseXMLData:info]||![self.model parseSliderWidth:info]||![self.model parseSwipeType:info]||![self.model parseRefreshMode:info]){
        return;
    }
    if([info objectForKey:@"data"] && [info[@"data"] isKindOfClass:[NSArray class]]){
        [self.model resetCellDataSource:info[@"data"]];
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
    [self setRefresh];
    return YES;

}

-(void)setRefresh{

    switch (self.model.refreshMode) {
        case uexListViewCustomLayoutRefreshNone:{
            break;
        }
        case uexListViewCustomLayoutRefreshTop:{
            [self setRefreshHeader];
            break;
        }
        case uexListViewCustomLayoutRefreshBottom:{
            [self setRefreshFooter];
            break;
        }
        case uexListViewCustomLayoutRefreshBothTopAndBottom:{
            [self setRefreshHeader];
            [self setRefreshFooter];
            break;
        }
            
        
    }

    
    
}

-(void)setRefreshHeader{
    MJRefreshHeader *header=[MJRefreshHeader headerWithRefreshingBlock:^{
        
    }];
    [RACObserve(header, state) subscribeNext:^(id x) {
        MJRefreshState headerState =(MJRefreshState)[x integerValue];
        switch (headerState) {
            case MJRefreshStateWillRefresh:{
                [self refreshObject:uexListViewCustomLayoutRefreshHeader callbackRefreshStatus:uexListViewCustomLayoutRefreshStatusRefreshing];
                break;
            }
            case MJRefreshStatePulling:{
                [self refreshObject:uexListViewCustomLayoutRefreshHeader callbackRefreshStatus:uexListViewCustomLayoutRefreshStatusBegin];
                break;
            }
            case MJRefreshStateRefreshing:{
                [self refreshObject:uexListViewCustomLayoutRefreshHeader callbackRefreshStatus:uexListViewCustomLayoutRefreshStatusFinish];
                break;
            }
            default:{
                break;
            }
        }
    }];
    self.tableView.header=header;
}

-(void)setRefreshFooter{
    MJRefreshFooter *footer=[MJRefreshFooter footerWithRefreshingBlock:^{
        
    }];
    [RACObserve(footer, state) subscribeNext:^(id x) {
        MJRefreshState headerState =(MJRefreshState)[x integerValue];
        switch (headerState) {
            case MJRefreshStateWillRefresh:{
                [self refreshObject:uexListViewCustomLayoutRefreshFooter callbackRefreshStatus:uexListViewCustomLayoutRefreshStatusRefreshing];
                break;
            }
            case MJRefreshStatePulling:{
                [self refreshObject:uexListViewCustomLayoutRefreshFooter callbackRefreshStatus:uexListViewCustomLayoutRefreshStatusBegin];
                break;
            }
            case MJRefreshStateRefreshing:{
                [self refreshObject:uexListViewCustomLayoutRefreshFooter callbackRefreshStatus:uexListViewCustomLayoutRefreshStatusFinish];
                break;
            }
            default:{
                break;
            }
        }
    }];
    self.tableView.footer=footer;

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.model.cellDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - UITableViewDelegate






#pragma mark - js callback

- (void)callBackJsonWithName:(NSString *)funcName object:(id)obj{
    static NSString * pluginName=@"uexListView";
    NSString *cbStr=nil;
    if([obj isKindOfClass:[NSString class]]){
        cbStr=obj;
    }else{
        cbStr= [obj JSONFragment];
    }
    NSString *jsStr=[NSString stringWithFormat:@"if(%@.%@ != null){%@.%@('%@');}",pluginName,funcName,pluginName,funcName,cbStr];
    [EUtility brwView:self.euexObj.meBrwView evaluateScript:jsStr];
}


-(void)refreshObject:(uexListViewCustomLayoutRefreshObject)obj callbackRefreshStatus:(uexListViewCustomLayoutRefreshStatus)status{
    if(!self.usingCustomLayout){
        return;
    }
    NSString *method=@"";
    switch (obj) {
        case uexListViewCustomLayoutRefreshFooter:{
            method=@"onCustomPullRefreshFooter";
            break;
        }
        case uexListViewCustomLayoutRefreshHeader:{
            method=@"onCustomPullRefreshHeader";
            break;
        }
    }
    [self callBackJsonWithName:method object:@{@"status":@(status)}];
}

@end
