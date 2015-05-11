//
//  EUExListView.m
//  EUExListView
//
//  Created by liguofu on 14/12/4.
//  Copyright (c) 2014年 AppCan.can. All rights reserved.
//

#import "EUExListView.h"
#import "EUtility.h"
#import "PullTableView.h"
#import "SDImageCache.h"
@implementation EUExListView{
    
    int row;
    int statusFooterListener;
}
-(id)initWithBrwView:(EBrowserView *)eInBrwView {
    if (self = [super initWithBrwView:eInBrwView]) {
        currentStatus = NO;
    }
    return self;
}

- (void)open:(NSMutableArray *) inArguments {
    
    if (currentStatus) {
        // NSLog(@"currentStatus====%d",currentStatus);
        
        return;
    }
    currentStatus = YES;
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        
        jsonStr = [inArguments objectAtIndex:0];
        self.frameDict = [jsonStr JSONValue];
        
    }else{
        return;
    }
    
    float x = [[self.frameDict objectForKey:@"x"] floatValue];
    float y = [[self.frameDict objectForKey:@"y"] floatValue];
    float w = [[self.frameDict objectForKey:@"w"] floatValue];
    float h = [[self.frameDict objectForKey:@"h"] floatValue];
    if (w <= 0||w>[EUtility screenWidth]) {
        w = [EUtility screenWidth];
    }
    if (h <= 0||h>[EUtility screenHeight]) {
        h = [EUtility screenHeight];
    }
    
    self.tableView = [[[PullTableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStylePlain] autorelease];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(ontPullRefreshHeaderListener:)
                                                name:@"ontPullRefreshHeaderListener"
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(ontPullRefreshFooterListener:)
                                                name:@"ontPullRefreshFooterListener"
                                              object:nil];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    self.tableView.pullDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
     [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    ///头部
    NSString *arrowStr = [self.setPullRefreshHeaderDict objectForKey:@"arrowImage"];
    NSString *arrowHeaderPath =[self absPath:arrowStr];
    NSData *arrowData = [NSData dataWithContentsOfFile:arrowHeaderPath];
    
    NSString *backGroundColor = [self.setPullRefreshHeaderDict objectForKey:@"backGroundColor"];
    NSString *textColor = [self.setPullRefreshHeaderDict objectForKey:@"textColor"];
    //float textFontSize = [[self.setPullRefreshHeaderDict objectForKey:@"textFontSize"]floatValue];
    NSString *pullRefreshNormalText = [self.setPullRefreshHeaderDict objectForKey:@"pullRefreshNormalText"];
    NSString *pullRefreshPullingText = [self.setPullRefreshHeaderDict objectForKey:@"pullRefreshPullingText"];
    NSString *pullRefreshLoadingText = [self.setPullRefreshHeaderDict objectForKey:@"pullRefreshLoadingText"];
    float isShowDate =[[self.setPullRefreshHeaderDict objectForKey:@"isShowUpdateDate"] floatValue];
    // NSString * isShowUpdateDate = [self.setPullRefreshHeaderDict objectForKey:@"isShowUpdateDate"];
    NSString * isShowUpdateDate = [NSString stringWithFormat:@"%f",isShowDate];
    
    self.tableView.pullArrowImage = [UIImage imageWithData:arrowData];
    if (backGroundColor) {
        self.tableView.pullBackgroundColor = [EUtility ColorFromString:backGroundColor];
    }else{
        self.tableView.pullBackgroundColor = [UIColor whiteColor];
    }
    if (textColor) {
        self.tableView.pullTextColor = [EUtility ColorFromString:textColor];
    }else{
        self.tableView.pullTextColor = [UIColor blackColor];
    }
    
    self.tableView.isShowUpdateDate = isShowUpdateDate;
    self.tableView.pullingText = pullRefreshPullingText;
    self.tableView.loadingText = pullRefreshLoadingText;
    self.tableView.normalText = pullRefreshNormalText;
    
    ///底部
    NSString *arrowStrFooter = [self.setPullRefreshHeaderDict objectForKey:@"arrowImage"];
    NSString *arrowHeaderPathFooter =[self absPath:arrowStrFooter];
    NSData *arrowDataFooter = [NSData dataWithContentsOfFile:arrowHeaderPathFooter];
    
    
    NSString *backGroundColorFooter = [self.setPullRefreshFooterDict objectForKey:@"backGroundColor"];
    NSString *textColorFooter = [self.setPullRefreshFooterDict objectForKey:@"textColor"];
    // float textFontSize = [[self.setPullRefreshHeaderDict objectForKey:@"textFontSize"]floatValue];
    NSString *pullRefreshNormalTextFooter = [self.setPullRefreshFooterDict objectForKey:@"pullRefreshNormalText"];
    NSString *pullRefreshPullingTextFooter = [self.setPullRefreshFooterDict objectForKey:@"pullRefreshPullingText"];
    NSString *pullRefreshLoadingTextFooter = [self.setPullRefreshFooterDict objectForKey:@"pullRefreshLoadingText"];
    //int isShowUpdateDate = [[self.setPullRefreshHeaderDict objectForKey:@"isShowUpdateDate"] intValue];
    if (backGroundColorFooter) {
        self.tableView.pullBackgroundColorLoadMore = [EUtility ColorFromString:backGroundColorFooter];
    }else{
        self.tableView.pullBackgroundColorLoadMore = [UIColor whiteColor];
    }
    if (textColorFooter) {
        self.tableView.pullTextColorLoadMore = [EUtility ColorFromString:textColorFooter];
    }else{
        self.tableView.pullTextColorLoadMore = [UIColor blackColor];
    }
    
    self.tableView.pullArrowImageLoadMore = [UIImage imageWithData:arrowDataFooter];
    self.tableView.normalTextLoadMore = pullRefreshNormalTextFooter;
    self.tableView.pullingTextLoadMore = pullRefreshPullingTextFooter;
    self.tableView.loadingTextLoadMore = pullRefreshLoadingTextFooter;
    
    [EUtility brwView:meBrwView addSubview:self.tableView];
}

-(void)close:(NSMutableArray *) inArguments {
    
    self.tableView.pullDelegate = nil;
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    currentStatus = NO;
}

-(void)setItems:(NSMutableArray *) inArguments {
    NSString *jsonStr = nil;
    if ([inArguments count] > 0) {
        jsonStr = [inArguments objectAtIndex:0];
    }
    self.setItemsDict = [jsonStr JSONValue];
    self.dataItemsArr = [self.setItemsDict objectForKey:@"listItems"];
    
    self.rightSwipeOptionItemDict = [self.setItemsDict objectForKey:@"rightSwipeOptionItem"];
    self.rightOptionBtnArr = [self.rightSwipeOptionItemDict objectForKey:@"optionBtn"];
    
    self.leftSwipeOptionItemDict = [self.setItemsDict objectForKey:@"leftSwipeOptionItem"];
    self.leftOptionBtnArr = [self.leftSwipeOptionItemDict objectForKey:@"optionBtn"];
}
-(void)setPullRefreshHeader:(NSMutableArray *) inArguments {
    // [[EGORefreshTableHeaderView alloc] initWithEuexObj:self];
    
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        jsonStr = [inArguments objectAtIndex:0];
    }else{
        return;
    }
    
    self.setPullRefreshHeaderDict = [[jsonStr JSONValue] objectForKey:@"PullRefreshHeaderStyle"];
}
-(void)setPullRefreshFooter:(NSMutableArray *) inArguments {
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        
        jsonStr = [inArguments objectAtIndex:0];
        
    }else{
        return;
    }
    
    self.setPullRefreshFooterDict = [[jsonStr JSONValue] objectForKey:@"PullRefreshFooterStyle"];
}


-(void)setItemSwipeType:(NSMutableArray *) inArguments {
    
    self.setItemSwipeEnabled = 0;
    
    if (inArguments.count > 0&&[inArguments isKindOfClass:[NSMutableArray class]]) {
        
        self.setItemSwipeEnabled = [[inArguments objectAtIndex:0] intValue];
        
    }
    else{
        return;
    }
}

//加载
-(void)appendItems:(NSMutableArray *) inArguments {
    
    NSString *loadMoreStr = nil;
    
    if (inArguments.count > 0) {
        
        loadMoreStr = [inArguments objectAtIndex:0];
        
    }else{
        return;
    }
    self.loadMoreItemsArr = [[loadMoreStr JSONValue] objectForKey:@"listItems"];
    
    for (NSArray *loadMoreObj in self.loadMoreItemsArr) {
        [self.dataItemsArr insertObject:loadMoreObj atIndex:self.dataItemsArr.count];
    }
    [self.tableView reloadData];
    
}
//删除
-(void)deleteItemsAt:(NSMutableArray *) inArguments {
    
    NSString *jsonStr = nil;
    if (inArguments.count  > 0) {
        jsonStr = [inArguments objectAtIndex:0];
    }
    self.deleteItemsArr = [[jsonStr JSONValue] objectForKey:@"itemIndex"];
    self.deleteItemsArr = [self.deleteItemsArr sortedArrayUsingSelector:@selector(compare:)];
    for (int i=(int)self.deleteItemsArr.count-1; i >= 0; i--) {
        //删除index
        int l =[self.deleteItemsArr[i] intValue];
        int m =(int)self.dataItemsArr.count-1;
        if (l> m) {
            return;
        }
        [self.dataItemsArr removeObjectAtIndex:[self.deleteItemsArr[i] intValue]];
    }
    int m =(int)self.dataItemsArr.count;
    if (m==0) {
        [self close:nil];
    }
    [self.tableView reloadData];
}

//插入
-(void)insertItemAt:(NSMutableArray *) inArguments {
    
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        jsonStr = [inArguments objectAtIndex:0];
    }
    else{
        return;
    }
    self.insertItemsDict = [jsonStr JSONValue];
    
    NSInteger insertRow = [[self.insertItemsDict objectForKey:@"itemIndex"] integerValue];
    self.insertItemsArr = [self.insertItemsDict objectForKey:@"listItem"];
    int dataItemsCount = (int)self.dataItemsArr.count-1;
    
    if( insertRow > dataItemsCount){
        
        return;
    }
    [self.dataItemsArr insertObject:self.insertItemsArr atIndex:insertRow];
    
    [self.tableView reloadData];
}
//重新加载
-(void)reloadItems:(NSMutableArray *) inArguments {
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        jsonStr = [inArguments objectAtIndex:0];
    }
    else{
        
        return;
    }
    [self.dataItemsArr removeAllObjects];
    self.dataItemsArr = [[jsonStr JSONValue] objectForKey:@"listItems"];
    // NSLog(@"---------->>>>>>%@",self.dataItemsArr);
    [self.tableView reloadData];
}
//移动
-(void)moveRowAtIndexPath:(NSMutableArray *) inArguments {
    
    NSInteger fromRow = [[inArguments objectAtIndex:0] integerValue];
    //    获取移动某处的位置
    NSInteger toRow = [[inArguments objectAtIndex:1] integerValue];
    //    从数组中读取需要移动行的数据
    self.moveItemsStr = [self.dataItemsArr objectAtIndex:fromRow];
    //    在数组中移动需要移动的行的数据
    [self.dataItemsArr removeObjectAtIndex:fromRow];
    //    把需要移动的单元格数据在数组中，移动到想要移动的数据前面
    [self.dataItemsArr insertObject:self.moveItemsStr atIndex:toRow];
    [self.tableView reloadData];
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#pragma mark - Refresh and load more methods
- (void) refreshTable
{
    /*
     
     Code to actually refresh goes .here.
     
     */
    
    self.tableView.pullLastRefreshDate = [NSDate date];
    [self jsSuccessWithName:@"uexListView.ontPullRefreshHeaderListener" opId:1 dataType:1 intData:1];
    self.tableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    [self jsSuccessWithName:@"uexListView.ontPullRefreshFooterListener" opId:1 dataType:1 intData:1];
    self.tableView.pullTableIsLoadingMore = NO;
    
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataItemsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dataItemDict = [self.dataItemsArr objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"Cell";
    SWTableViewCell * cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        for (int i = (int)self.leftOptionBtnArr.count-1; i >= 0; i--) {
            
            NSString *colorStr = [[self.leftOptionBtnArr objectAtIndex:i]objectForKey:@"textColor"];
            NSString *bgColorStr = [[self.leftOptionBtnArr objectAtIndex:i]objectForKey:@"bgColor"];
            NSString *title = [[self.leftOptionBtnArr objectAtIndex:i]objectForKey:@"text"];
            float titleSize = [[[self.leftOptionBtnArr objectAtIndex:i]objectForKey:@"textSize"] floatValue];
            
            [leftUtilityButtons addUtilityButtonWithColor:[EUtility ColorFromString:colorStr] title:title titleSize:[UIFont fontWithName:nil size:titleSize] bgColor:[EUtility ColorFromString:bgColorStr]];
        }
        
        for (int i = (int)self.rightOptionBtnArr.count-1; i >= 0; i--) {
            
            NSString *colorStr = [[self.rightOptionBtnArr objectAtIndex:i]objectForKey:@"textColor"];
            NSString *bgColorStr = [[self.rightOptionBtnArr objectAtIndex:i]objectForKey:@"bgColor"];
            NSString *title = [[self.rightOptionBtnArr objectAtIndex:i]objectForKey:@"text"];
            float titleSize = [[[self.rightOptionBtnArr objectAtIndex:i]objectForKey:@"textSize"] floatValue];
            
            [rightUtilityButtons addUtilityButtonWithColor:[EUtility ColorFromString:colorStr] title:title titleSize:[UIFont fontWithName:nil size:titleSize] bgColor:[EUtility ColorFromString:bgColorStr]];
        }
        if (self.setItemSwipeEnabled == 1) {
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:self.tableView
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:rightUtilityButtons];
            
        }
        else if (self.setItemSwipeEnabled ==2) {
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:self.tableView                                         leftUtilityButtons:leftUtilityButtons
                                      rightUtilityButtons:rightUtilityButtons];
        }
        else if (self.setItemSwipeEnabled == 3) {
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:self.tableView
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:nil] ;
        }
        else{
            
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:self.tableView
                                       leftUtilityButtons:leftUtilityButtons
                                      rightUtilityButtons:nil];

            
        }
        cell.delegate = self;
        UIView *view = [[UIView alloc] initWithFrame:cell.contentView.frame];
        NSString *selectedBackgroundColor = [dataItemDict objectForKey:@"selectedBackgroundColor"];
        [view setBackgroundColor:[EUtility ColorFromString:selectedBackgroundColor]];
        cell.selectedBackgroundView = view;
        [view release];
    }
    NSString *imageViewPath = [dataItemDict objectForKey:@"image"];
    NSString *placeholderImgPath = [dataItemDict objectForKey:@"placeholderImg"];
    
    imageViewPath = [self absPath:imageViewPath];
    placeholderImgPath = [self absPath:placeholderImgPath];
    
    NSString *title = [dataItemDict objectForKey:@"title"];
    NSString *subtitle = [dataItemDict objectForKey:@"subtitle"];
    
    NSString *titleColor = [dataItemDict objectForKey:@"titleColor"];
    NSString *subtitleColor = [dataItemDict objectForKey:@"subtitleColor"];
    
    float titleSize = [[dataItemDict objectForKey:@"titleSize"] floatValue];
    float subtitleSize = [[dataItemDict objectForKey:@"subtitleSize"] floatValue];
    
    
    NSString *backgroundColor = [dataItemDict objectForKey:@"backgroundColor"];
    UIImage *placeholderImageView = [UIImage imageWithData:[self getImageDataByPath:placeholderImgPath]];
    
    if (!placeholderImageView) {
        placeholderImageView = [UIImage imageNamed:@"uexListView/icon.png"];
    }
    
    if([imageViewPath hasPrefix:@"http://"]) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageViewPath] placeholderImage:placeholderImageView];
        
    } else {
        UIImage *imageview = [UIImage imageWithData:[self getImageDataByPath:imageViewPath]];
        if (imageview) {
            [cell.imageView setImage:imageview];
        } else {
            [cell.imageView setImage:placeholderImageView];
        }
    }
    cell.textLabel.text = title;
    cell.textLabel.numberOfLines = -1;
    cell.detailTextLabel.text = subtitle;
    cell.detailTextLabel.numberOfLines = -1;
    [cell.textLabel setTextColor:[EUtility ColorFromString:titleColor]];
    [cell.detailTextLabel setTextColor:[EUtility ColorFromString:subtitleColor]];
    [cell.textLabel.text sizeWithFont:[UIFont fontWithName:nil size:titleSize]];
    [cell.detailTextLabel.text sizeWithFont:[UIFont fontWithName:nil size:subtitleSize]];
    [cell SWSetBackgroundColor:[EUtility ColorFromString:backgroundColor]];
    self.tableView.backgroundColor = [EUtility ColorFromString:backgroundColor];
    return cell;
}

-(NSData *)getImageDataByPath:(NSString *)imagePath {
    
    NSData *imageData = nil;
    if ([imagePath hasPrefix:@"http://"]) {
        NSURL *imagePathURL = [NSURL URLWithString:imagePath];
        imageData = [NSData dataWithContentsOfURL:imagePathURL];
        
    } else {
        
        imageData = [NSData dataWithContentsOfFile:imagePath];
    }
    return imageData;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cell" object:self];
    row =(int)indexPath.row;
    [self performSelector:@selector(onClickItem) withObject:self afterDelay:0.1];
}

-(void)onClickItem{
    
    //[self jsSuccessWithName:@"uexListView.onItemClick" opId:0 dataType:2 intData:row];
    
    NSString *jsString = [NSString stringWithFormat:@"uexListView.onItemClick(\"%d\");",row];
    [self.meBrwView stringByEvaluatingJavaScriptFromString:jsString];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float  heightForRow = [[[self.dataItemsArr objectAtIndex:indexPath.row] objectForKey:@"height"] floatValue];
    
    self.tableView.rowHeight = heightForRow;
    return heightForRow;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want white
}

#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSString *jsString = [NSString stringWithFormat:@"uexListView.onLeftOptionButtonInItem(\"%d\",\"%d\");",cellIndexPath.row,index];
    
    [self.meBrwView stringByEvaluatingJavaScriptFromString:jsString];
    
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSString *jsString = [NSString stringWithFormat:@"uexListView.onRightOptionButtonInItem(\"%d\",\"%d\");",cellIndexPath.row,index];
    
    [self.meBrwView stringByEvaluatingJavaScriptFromString:jsString];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:2.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:2.0f];
}

-(void)ontPullRefreshHeaderListener:(NSNotification*)notification{
    
    EGORefreshTableHeaderView *headerview = notification.object;
    int status = headerview.status;
    [self jsSuccessWithName:@"uexListView.ontPullRefreshHeaderListener" opId:status dataType:status intData:status];
}
-(void)ontPullRefreshFooterListener:(NSNotification *)notification {
    
    LoadMoreTableFooterView *footerview = notification.object;
    statusFooterListener = footerview.status;
    [self jsSuccessWithName:@"uexListView.ontPullRefreshFooterListener" opId:statusFooterListener dataType:statusFooterListener intData:statusFooterListener];
    
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ontPullRefreshHeaderListener" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ontPullRefreshFooterListener" object:nil];
    [super dealloc];
}

-(void)clean {
    self.tableView.pullDelegate = nil;
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
     currentStatus = NO;
}

@end
