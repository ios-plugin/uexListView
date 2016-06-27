//
//  EUExListView.m
//  EUExListView
//
//  Created by liguofu on 14/12/4.
//  Copyright (c) 2014年 AppCan.can. All rights reserved.
//

#import "EUExListView.h"

#import "PullTableView.h"
#import <YYWebImage/YYWebImage.h>
@interface EUExListView()<UITableViewDataSource,UITableViewDelegate ,SWTableViewCellDelegate,PullTableViewDelegate>


@property (nonatomic, strong) PullTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataItemsArr;
@property (nonatomic, strong) NSArray *swipeOptionItemArr;
@property (nonatomic, strong) NSDictionary *rightSwipeOptionItemDict;
@property (nonatomic, strong) NSDictionary *leftSwipeOptionItemDict;
@property (nonatomic, strong) NSArray *rightOptionBtnArr;
@property (nonatomic, strong) NSArray *leftOptionBtnArr;
@property (nonatomic, strong) NSDictionary *setItemsDict;
@property (nonatomic, assign) NSInteger itemSwipeMode;
@property (nonatomic, strong) NSDictionary *setPullRefreshHeaderDict;
@property (nonatomic, strong) NSDictionary *setPullRefreshFooterDict;


@end


@implementation EUExListView



- (instancetype)initWithWebViewEngine:(id<AppCanWebViewEngineObject>)engine
{
    self = [super initWithWebViewEngine:engine];
    if (self) {
        _itemSwipeMode = 0;
    }
    return self;
}




- (void)open:(NSMutableArray *) inArguments {
    
    if (self.tableView) {
        return;
    }
    
    ACArgsUnpack(NSDictionary *info) = inArguments;
    if (!info) {
        return;
    }
    
    CGFloat x = [info[@"x"] floatValue];
    CGFloat y = [info[@"y"] floatValue];
    CGFloat w = [info[@"w"] floatValue];
    CGFloat h = [info[@"h"] floatValue];
    if (w <= 0) {
        w = [UIScreen mainScreen].applicationFrame.size.width;
    }
    if (h <= 0) {
        h = [UIScreen mainScreen].applicationFrame.size.height;
    }
    

    self.tableView = [[PullTableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStylePlain];
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
    NSString *pullRefreshNormalText = [self.setPullRefreshHeaderDict objectForKey:@"pullRefreshNormalText"];
    NSString *pullRefreshPullingText = [self.setPullRefreshHeaderDict objectForKey:@"pullRefreshPullingText"];
    NSString *pullRefreshLoadingText = [self.setPullRefreshHeaderDict objectForKey:@"pullRefreshLoadingText"];
    float isShowDate =[[self.setPullRefreshHeaderDict objectForKey:@"isShowUpdateDate"] floatValue];

    NSString * isShowUpdateDate = [NSString stringWithFormat:@"%f",isShowDate];
    
    self.tableView.pullArrowImage = [UIImage imageWithData:arrowData];
    if (backGroundColor) {
        self.tableView.pullBackgroundColor = [UIColor ac_ColorWithHTMLColorString:backGroundColor];
    }else{
        self.tableView.pullBackgroundColor = [UIColor whiteColor];
    }
    if (textColor) {
        self.tableView.pullTextColor = [UIColor ac_ColorWithHTMLColorString:textColor];
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

    NSString *pullRefreshNormalTextFooter = [self.setPullRefreshFooterDict objectForKey:@"pullRefreshNormalText"];
    NSString *pullRefreshPullingTextFooter = [self.setPullRefreshFooterDict objectForKey:@"pullRefreshPullingText"];
    NSString *pullRefreshLoadingTextFooter = [self.setPullRefreshFooterDict objectForKey:@"pullRefreshLoadingText"];

    if (backGroundColorFooter) {
        self.tableView.pullBackgroundColorLoadMore = [UIColor ac_ColorWithHTMLColorString:backGroundColorFooter];
    }else{
        self.tableView.pullBackgroundColorLoadMore = [UIColor whiteColor];
    }
    if (textColorFooter) {
        self.tableView.pullTextColorLoadMore = [UIColor ac_ColorWithHTMLColorString:textColorFooter];
    }else{
        self.tableView.pullTextColorLoadMore = [UIColor blackColor];
    }
    
    self.tableView.pullArrowImageLoadMore = [UIImage imageWithData:arrowDataFooter];
    self.tableView.normalTextLoadMore = pullRefreshNormalTextFooter;
    self.tableView.pullingTextLoadMore = pullRefreshPullingTextFooter;
    self.tableView.loadingTextLoadMore = pullRefreshLoadingTextFooter;
    
    [[self.webViewEngine webView] addSubview:self.tableView];

}

- (void)close:(NSMutableArray *)inArguments {
    [self clean];


}

- (void)setItems:(NSMutableArray *)inArguments {
    ACArgsUnpack(NSDictionary *info) = inArguments;
    if (!info) {
        return;
    }
    self.setItemsDict = info;
    self.dataItemsArr = [[self.setItemsDict objectForKey:@"listItems"] mutableCopy];
    
    self.rightSwipeOptionItemDict = [self.setItemsDict objectForKey:@"rightSwipeOptionItem"];
    self.rightOptionBtnArr = [self.rightSwipeOptionItemDict objectForKey:@"optionBtn"];
    
    self.leftSwipeOptionItemDict = [self.setItemsDict objectForKey:@"leftSwipeOptionItem"];
    self.leftOptionBtnArr = [self.leftSwipeOptionItemDict objectForKey:@"optionBtn"];
}
- (void)setPullRefreshHeader:(NSMutableArray *) inArguments {


    ACArgsUnpack(NSDictionary *info) = inArguments;
    if (!info) {
        return;
    }
    self.setPullRefreshHeaderDict = [info objectForKey:@"PullRefreshHeaderStyle"];
}
- (void)setPullRefreshFooter:(NSMutableArray *) inArguments {
    ACArgsUnpack(NSDictionary *info) = inArguments;
    if (!info) {
        return;
    }
    self.setPullRefreshFooterDict = [info objectForKey:@"PullRefreshFooterStyle"];
}


- (void)setItemSwipeType:(NSMutableArray *) inArguments {
    ACArgsUnpack(NSNumber *swipeNum) = inArguments;
    self.itemSwipeMode = [swipeNum integerValue];

}

//加载
- (void)appendItems:(NSMutableArray *) inArguments {
    
    ACArgsUnpack(NSDictionary *info) = inArguments;
    if (!info) {
        return;
    }
    NSArray *items = arrayArg(info[@"listItems"]);
    
    for (NSArray *loadMoreObj in items) {
        [self.dataItemsArr insertObject:loadMoreObj atIndex:self.dataItemsArr.count];
    }
    [self.tableView reloadData];
    
}
//删除
- (void)deleteItemsAt:(NSMutableArray *) inArguments {
    
    ACArgsUnpack(NSDictionary *info) = inArguments;

    
    NSArray *tmpArr = arrayArg(info[@"itemIndex"]);
    if (!tmpArr) {
        return;
    }
    
    NSMutableArray<NSNumber *> *indexes = [NSMutableArray array];
    [tmpArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *num = numberArg(obj);
        if (num) {
            [indexes addObject:num];
        }
    }];
    [indexes sortUsingComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    [indexes enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger line = [obj integerValue];
        if (line >= 0 && line < self.dataItemsArr.count) {
            [self.dataItemsArr removeObjectAtIndex:line];
        }
    }];
    if (self.dataItemsArr.count == 0) {
        [self clean];
    }else{
        [self.tableView reloadData];
    }

}

//插入
- (void)insertItemAt:(NSMutableArray *) inArguments {
    
    ACArgsUnpack(NSDictionary *info) = inArguments;
    if (!info) {
        return;
    }
    
    NSInteger insertRow = [info[@"itemIndex"] integerValue];
    NSDictionary *item = dictionaryArg(info[@"listItem"]);
    if (insertRow < 0) {
        insertRow = 0;
    }
    if (insertRow >= self.dataItemsArr.count || !item) {
        return;
    }
    [self.dataItemsArr insertObject:item atIndex:insertRow];
    [self.tableView reloadData];
}
//重新加载
- (void)reloadItems:(NSMutableArray *) inArguments {
    ACArgsUnpack(NSDictionary *info) = inArguments;
    if (!info) {
        return;
    }
    [self.dataItemsArr removeAllObjects];
    self.dataItemsArr = [[info objectForKey:@"listItems"] mutableCopy];
    [self.tableView reloadData];
}
//移动
- (void)moveRowAtIndexPath:(NSMutableArray *) inArguments {
    ACArgsUnpack(NSNumber *from,NSNumber *to) = inArguments;
    if (!from || !to) {
        return;
    }
    [self.dataItemsArr exchangeObjectAtIndex:from.integerValue withObjectAtIndex:to.integerValue];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#pragma mark - Refresh and load more methods
- (void) refreshTable{

    self.tableView.pullLastRefreshDate = [NSDate date];
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexListView.ontPullRefreshHeaderListener" arguments:ACArgsPack(@1,@1,@1)];

    self.tableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable{
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexListView.ontPullRefreshFooterListener" arguments:ACArgsPack(@1,@1,@1)];
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
            
            [leftUtilityButtons addUtilityButtonWithColor:[UIColor ac_ColorWithHTMLColorString:colorStr] title:title titleSize:[UIFont systemFontOfSize:titleSize] bgColor:[UIColor ac_ColorWithHTMLColorString:bgColorStr]];
        }
        
        for (int i = (int)self.rightOptionBtnArr.count-1; i >= 0; i--) {
            
            NSString *colorStr = [[self.rightOptionBtnArr objectAtIndex:i]objectForKey:@"textColor"];
            NSString *bgColorStr = [[self.rightOptionBtnArr objectAtIndex:i]objectForKey:@"bgColor"];
            NSString *title = [[self.rightOptionBtnArr objectAtIndex:i]objectForKey:@"text"];
            float titleSize = [[[self.rightOptionBtnArr objectAtIndex:i]objectForKey:@"textSize"] floatValue];
            
            [rightUtilityButtons addUtilityButtonWithColor:[UIColor ac_ColorWithHTMLColorString:colorStr] title:title titleSize:[UIFont systemFontOfSize:titleSize] bgColor:[UIColor ac_ColorWithHTMLColorString:bgColorStr]];
        }
        if (self.itemSwipeMode == 1) {
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:self.tableView
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:rightUtilityButtons];
            
        }
        else if (self.itemSwipeMode ==2) {
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:self.tableView
                                       leftUtilityButtons:leftUtilityButtons
                                      rightUtilityButtons:rightUtilityButtons];
        }
        else if (self.itemSwipeMode == 3) {
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:self.tableView
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:nil] ;
        }else{
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:self.tableView
                                       leftUtilityButtons:leftUtilityButtons
                                      rightUtilityButtons:nil];
        }
        cell.delegate = self;
        UIView *view = [[UIView alloc] initWithFrame:cell.contentView.frame];
        NSString *selectedBackgroundColor = [dataItemDict objectForKey:@"selectedBackgroundColor"];
        [view setBackgroundColor:[UIColor ac_ColorWithHTMLColorString:selectedBackgroundColor]];
        cell.selectedBackgroundView = view;

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
    UIImage *placeholderImage = [UIImage imageWithData:[self getImageDataByPath:placeholderImgPath]];
    

    
    if([imageViewPath hasPrefix:@"http://"]) {
        [cell.imageView yy_setImageWithURL:[NSURL URLWithString:imageViewPath] placeholder:placeholderImage];


        
    } else {
        UIImage *imageview = [UIImage imageWithData:[self getImageDataByPath:imageViewPath]];
        if (imageview) {
            [cell.imageView setImage:imageview];
        }
    }
    cell.textLabel.text = title;
    cell.textLabel.numberOfLines = -1;
    cell.detailTextLabel.text = subtitle;
    cell.detailTextLabel.numberOfLines = -1;
    [cell.textLabel setTextColor:[UIColor ac_ColorWithHTMLColorString:titleColor]];
    [cell.detailTextLabel setTextColor:[UIColor ac_ColorWithHTMLColorString:subtitleColor]];
    [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:titleSize]];

    [cell.detailTextLabel.text sizeWithFont:[UIFont systemFontOfSize:subtitleSize]];
    [cell SWSetBackgroundColor:[UIColor ac_ColorWithHTMLColorString:backgroundColor]];
    self.tableView.backgroundColor = [UIColor ac_ColorWithHTMLColorString:backgroundColor];
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
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexListView.onItemClick" arguments:ACArgsPack(@(indexPath.row))];

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
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexListView.onLeftOptionButtonInItem" arguments:ACArgsPack(@(cellIndexPath.row),@(index))];
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexListView.onRightOptionButtonInItem" arguments:ACArgsPack(@(cellIndexPath.row),@(index))];
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

- (void)ontPullRefreshHeaderListener:(NSNotification*)notification{
    
    EGORefreshTableHeaderView *headerview = notification.object;
    int status = headerview.status;
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexListView.ontPullRefreshHeaderListener" arguments:ACArgsPack(@(status),@(status),@(status))];
    

}
- (void)ontPullRefreshFooterListener:(NSNotification *)notification {
    
    LoadMoreTableFooterView *footerview = notification.object;
    int status = footerview.status;
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexListView.ontPullRefreshFooterListener" arguments:ACArgsPack(@(status),@(status),@(status))];

    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)clean {
    if (self.tableView) {
        self.tableView.pullDelegate = nil;
        self.tableView.dataSource = nil;
        self.tableView.delegate = nil;
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    self.dataItemsArr = nil;
    self.swipeOptionItemArr = nil;
    self.rightSwipeOptionItemDict = nil;
    self.leftSwipeOptionItemDict = nil;
    self.rightOptionBtnArr = nil;
    self.leftOptionBtnArr = nil;
    self.setItemsDict = nil;
    self.setPullRefreshHeaderDict = nil;
    self.setPullRefreshFooterDict = nil;
}

@end
