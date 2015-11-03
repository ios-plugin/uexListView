//
//  CMLTableViewCell.m
//  EUExListView
//
//  Created by CeriNo on 15/10/23.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLTableViewCell.h"
#import "CeriXMLLayout.h"
#import "CMLCellScrollView.h"
#import "CMLCellLongPressGestureRecognizer.h"


#define kCMLTableViewCellSliderWidthDefaultOffset   -90



@interface CMLTableViewCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate,CeriXMLLayoutDelegate>
@property (nonatomic,weak)__kindof UITableView *tableView;

@property (nonatomic,strong)CMLTableViewCellData *cellData;

@property (nonatomic,strong)__kindof CMLBaseContainer *leftSliderViewController,*rightSliderViewController,*centerViewController;
@property (nonatomic,strong)UIView *leftContentView,*rightContentView;
@property (nonatomic,strong)CMLCellScrollView *contentScrollView;
@property (nonatomic,strong)UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic,strong)CMLCellLongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic,assign)BOOL layoutUpdating;


@end



@implementation CMLTableViewCell







-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){


    }
    return self;
}

-(void)modifyWithTableView:(__kindof UITableView *)tableView data:(CMLTableViewCellData *)data delegate:(id<CMLTableViewCellDelegate>)delegate{
    self.cellData=data;
    self.delegate=delegate;

    [self setupContentScrollView];
    [self setupTapGesture];
    [self setupLongPressGesture];
    [self setupLeftSlider];
    [self setupRightSlider];
    [self setTableView:tableView];
    
    
    



}

-(void)setTableView:(__kindof UITableView *)tableView{
    _tableView=tableView;
    if(_tableView){
        _tableView.directionalLockEnabled=YES;
        [self.tapGestureRecognizer requireGestureRecognizerToFail:_tableView.panGestureRecognizer];
        @weakify(self);
        [[RACObserve(_tableView.panGestureRecognizer, state)
          takeUntil:self.rac_prepareForReuseSignal]
         subscribeNext:^(id x) {
            @strongify(self);
             if(_tableView.panGestureRecognizer.state == UIGestureRecognizerStateBegan){
                  CGPoint locationInTableView = [_tableView.panGestureRecognizer locationInView:_contentScrollView];
                 if(!CGRectContainsPoint(self.frame, locationInTableView)&&self.cellData.state!=CMLTableViewCellStateCenter){
                     
                 }
             }
        }];
    }
}

-(void)setupLeftSlider{
    if(!self.cellData.leftSliderModel){
        return;
    }
    self.leftContentView=[[UIView alloc]init];
    [self addSubview:self.leftContentView];
    @weakify(self);
    [self.leftContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.contentScrollView.mas_left).with.offset(self.cellData.leftSliderOffset);
        make.top.equalTo(self.contentScrollView.mas_top);
        make.bottom.equalTo(self.contentScrollView.mas_bottom);
        if(self.cellData.leftSliderWidth >0){
            make.height.equalTo(@(self.cellData.leftSliderWidth));
        }
    }];
    self.leftSliderViewController=[CeriXMLLayout CMLRootViewControllerWithModel:self.cellData.leftSliderModel delegate:self];
    [self.leftContentView addSubview:self.leftSliderViewController.view];
    [self.leftSliderViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.leftContentView.mas_right);
        make.top.equalTo(self.leftContentView.mas_top);
        make.bottom.equalTo(self.leftContentView.mas_bottom);
        make.width.lessThanOrEqualTo(self.contentScrollView.mas_width).with.offset(kCMLTableViewCellSliderWidthDefaultOffset);
    }];
    [self.leftSliderViewController updateValuesByInfoArray:self.cellData.leftDefaultSettings];
}

-(void)setupRightSlider{
    if(!self.cellData.rightSliderModel){
        return;
    }
    self.rightContentView=[[UIView alloc]init];
    [self addSubview:self.rightContentView];
    @weakify(self);
    [self.rightContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentScrollView.mas_right).with.offset(self.cellData.rightSliderOffset);
        make.top.equalTo(self.contentScrollView.mas_top);
        make.bottom.equalTo(self.contentScrollView.mas_bottom);
        if(self.cellData.rightSliderWidth >0){
            make.height.equalTo(@(self.cellData.rightSliderWidth));
        }
    }];
    self.rightSliderViewController=[CeriXMLLayout CMLRootViewControllerWithModel:self.cellData.rightSliderModel delegate:self];
    [self.rightContentView addSubview:self.rightSliderViewController.view];
    [self.rightSliderViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.rightContentView.mas_left);
        make.top.equalTo(self.rightContentView.mas_top);
        make.bottom.equalTo(self.rightContentView.mas_bottom);
        make.width.lessThanOrEqualTo(self.contentScrollView.mas_width).with.offset(kCMLTableViewCellSliderWidthDefaultOffset);
    }];
    [self.rightSliderViewController updateValuesByInfoArray:self.cellData.rightDefaultSettings];
}

-(void)setupContentScrollView{
    self.translatesAutoresizingMaskIntoConstraints=NO;
    
    self.contentScrollView = [[CMLCellScrollView alloc] init];
    self.contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.scrollsToTop = NO;
    self.contentScrollView.scrollEnabled = YES;
    UIView *contentViewParent = [self.subviews objectAtIndex:0];

    NSArray *cellSubviews = [contentViewParent subviews];
    [self insertSubview:self.contentScrollView atIndex:0];
    for (UIView *subview in cellSubviews)
    {
        [_contentScrollView addSubview:subview];
    }
    @weakify(self);

    [self setupScrollViewDelegate];
    self.contentScrollView.delegate = nil;//这一行不能删！
    self.contentScrollView.delegate = self;
    self.centerViewController=[CeriXMLLayout CMLRootViewControllerWithModel:self.cellData.centerViewModel delegate:self];
    [self.contentScrollView addSubview:self.centerViewController.view];
    [_contentScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self);
        make.edges.equalTo(self.centerViewController.view);
    }];
    

    
}

-(void)setupScrollViewDelegate{
    @weakify(self);
    RACSignal *scrollViewDidEndDeceleratingSignal=[self rac_signalForSelector:@selector(scrollViewDidEndDecelerating:) fromProtocol:@protocol(UIScrollViewDelegate)];
    RACSignal *scrollViewDidEndScrollingAnimationSignal=[self rac_signalForSelector:@selector(scrollViewDidEndScrollingAnimation:) fromProtocol:@protocol(UIScrollViewDelegate)];
    [[RACSignal merge:@[scrollViewDidEndDeceleratingSignal,scrollViewDidEndScrollingAnimationSignal]]subscribeNext:^(id x) {
        @strongify(self);
        [self updateCellState];
    }];
    
    [[[self rac_signalForSelector:@selector(scrollViewDidEndDragging:willDecelerate:) fromProtocol:@protocol(UIScrollViewDelegate)]
     filter:^BOOL(RACTuple * tuple) {
         return ![tuple.second boolValue];
    }]
     subscribeNext:^(id x) {
        @strongify(self);
        self.tapGestureRecognizer.enabled=YES;
    }];
    
    [[self rac_signalForSelector:@selector(scrollViewDidScroll:) fromProtocol:@protocol(UIScrollViewDelegate)]
     subscribeNext:^(RACTuple * tuple) {
        @strongify(self);
        UIScrollView *scrollView=tuple.first;
        if(scrollView.contentOffset.x>[self leftSliderViewWidth] && [self rightSliderViewWidth]==0){
            
                [scrollView setContentOffset:CGPointMake([self leftSliderViewWidth], 0) animated:YES];
                self.tapGestureRecognizer.enabled = YES;

        }
        if(scrollView.contentOffset.x==0 && [self leftSliderViewWidth] == 0){
            [scrollView setContentOffset:CGPointMake(0, 0)];
            self.tapGestureRecognizer.enabled = YES;
        }
        [self updateCellState];
    }];
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.x >= 0.5f)
    {
        if (_cellData.state == CMLTableViewCellStateLeft || !self.rightContentView || [self rightSliderViewWidth] == 0.0)
        {
            _cellData.state = CMLTableViewCellStateCenter;
        }
        else
        {
            _cellData.state = CMLTableViewCellStateRight;
        }
    }
    else if (velocity.x <= -0.5f)
    {
        if (_cellData.state == CMLTableViewCellStateRight || !self.leftContentView || self.leftSliderViewWidth == 0.0)
        {
            _cellData.state = CMLTableViewCellStateCenter;
        }
        else
        {
            _cellData.state = CMLTableViewCellStateLeft;
        }
    }
    else
    {
        CGFloat leftThreshold = [self contentOffsetForCellState:CMLTableViewCellStateLeft].x + (self.leftSliderViewWidth / 2);
        CGFloat rightThreshold = [self contentOffsetForCellState:CMLTableViewCellStateRight].x - (self.rightSliderViewWidth / 2);
        
        if (targetContentOffset->x > rightThreshold)
        {
            _cellData.state = CMLTableViewCellStateRight;
        }
        else if (targetContentOffset->x < leftThreshold)
        {
            _cellData.state = CMLTableViewCellStateLeft;
        }
        else
        {
            _cellData.state = CMLTableViewCellStateCenter;
        }
    }
    

    
    if (_cellData.state != CMLTableViewCellStateCenter)
    {
        if (self.cellData.cellShouldHideSliderOnSwipe)
        {
            for (CMLTableViewCell *cell in [self.tableView visibleCells]) {
                if (cell != self && [cell isKindOfClass:[CMLTableViewCell class]]) {
                    [cell hideSlidersAnimated:YES];
                }
            }
        }
    }
    
    *targetContentOffset = [self contentOffsetForCellState:_cellData.state];
}


-(void)hideSlidersAnimated:(BOOL)animated{
    if(self.cellData.state !=CMLTableViewCellStateCenter){
        [self.contentScrollView setContentOffset:[self contentOffsetForCellState:CMLTableViewCellStateCenter] animated:animated];
    }
}

-(void)setupTapGesture{
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [[[self.tapGestureRecognizer rac_gestureSignal]
     takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id x) {
         [self scrollViewTapped];
              }];
    self.tapGestureRecognizer.cancelsTouchesInView = NO;
    self.tapGestureRecognizer.delegate = self;
    [self.contentScrollView addGestureRecognizer:self.tapGestureRecognizer];
    
}

-(void)scrollViewTapped{
    if (_cellData.state == CMLTableViewCellStateCenter){
        if (self.isSelected){
            [self deselectCell];
        }else if (self.shouldHighlight){
            [self selectCell];
        }
    }else{
        
        [self hideSlidersAnimated:YES];
    }

}

-(void)setupLongPressGesture{

        self.longPressGestureRecognizer = [[CMLCellLongPressGestureRecognizer alloc]init];
        [[[self.longPressGestureRecognizer rac_gestureSignal]
          takeUntil:self.rac_prepareForReuseSignal ]
         subscribeNext:^(UIGestureRecognizer *gestureRecognizer) {
             if (gestureRecognizer.state == UIGestureRecognizerStateBegan && !self.isHighlighted && self.shouldHighlight)
             {
                 [self setHighlighted:YES animated:NO];
             }
             
             else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
             {
                 // Cell is already highlighted; clearing it temporarily seems to address visual anomaly.
                 [self setHighlighted:NO animated:NO];
                 [self scrollViewTapped];
             }
             
             else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled)
             {
                 [self setHighlighted:NO animated:NO];
             }

        }];
        self.longPressGestureRecognizer.cancelsTouchesInView = NO;
        self.longPressGestureRecognizer.minimumPressDuration = 0.2;
        self.longPressGestureRecognizer.delegate = self;
        [self.contentScrollView addGestureRecognizer:self.longPressGestureRecognizer];

}

#pragma mark - slider view utility

-(CGFloat)leftSliderViewWidth{
    if(!self.leftSliderViewController){
        return 0;
    }
    return CGRectGetWidth(self.leftSliderViewController.view.frame);

}


-(CGFloat)rightSliderViewWidth{
    if(!self.rightSliderViewController){
        return 0;
    }
    return CGRectGetWidth(self.rightSliderViewController.view.frame);

}

-(CGFloat)totalSlidersOffsetX{
    return [self leftSliderViewWidth]+[self rightSliderViewWidth];
}

- (CGPoint)contentOffsetForCellState:(CMLTableViewCellState)state
{
    CGPoint scrollPt = CGPointZero;
    
    switch (_cellData.state)
    {
        case CMLTableViewCellStateLeft: {
            scrollPt.x = 0;
            break;
        }
        case CMLTableViewCellStateCenter: {
            scrollPt.x = [self leftSliderViewWidth];
            break;
        }
        case CMLTableViewCellStateRight: {
            scrollPt.x = [self totalSlidersOffsetX];
            break;
        }
    }
    
    return scrollPt;
}

- (void)updateCellState
{
    if(!self.layoutUpdating)
    {
        // Update the cell state according to the current scroll view contentOffset.
        for (NSNumber *numState in @[
                                     @(CMLTableViewCellStateCenter),
                                     @(CMLTableViewCellStateLeft),
                                     @(CMLTableViewCellStateRight),
                                     ])
        {
            CMLTableViewCellState cellState = numState.integerValue;
            
            if (CGPointEqualToPoint(self.contentScrollView.contentOffset, [self contentOffsetForCellState:cellState]))
            {
                self.cellData.state = cellState;
                break;
            }
        }
        
        // Update the clipping on the utility button views according to the current position.
        CGRect frame = [self.contentView.superview convertRect:self.contentView.frame toView:self];
        frame.size.width = CGRectGetWidth(self.frame);
        @weakify(self);
        [self.leftContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.contentScrollView.mas_left);
        }];

        self.cellData.leftSliderOffset = MAX(0, CGRectGetMinX(frame) - CGRectGetMinX(self.frame));
        self.cellData.rightSliderOffset = MIN(0, CGRectGetMaxX(frame) - CGRectGetMaxX(self.frame));
        
        if (self.isEditing) {
            self.cellData.leftSliderOffset = 0;
            self.contentScrollView.contentOffset = CGPointMake([self leftSliderViewWidth], 0);
            self.cellData.state = CMLTableViewCellStateCenter;
        }
        
        self.leftContentView.hidden = (self.cellData.leftSliderOffset == 0);
        self.rightContentView.hidden = (self.cellData.rightSliderOffset == 0);
        
        if (self.accessoryType != UITableViewCellAccessoryNone && !self.editing) {
            UIView *accessory = [self.contentScrollView.superview.subviews lastObject];
            
            CGRect accessoryFrame = accessory.frame;
            accessoryFrame.origin.x = CGRectGetWidth(frame) - CGRectGetWidth(accessoryFrame) - 15 + CGRectGetMinX(frame);
            accessory.frame = accessoryFrame;
        }
        
        // Enable or disable the gesture recognizers according to the current mode.
        if (!self.contentScrollView.isDragging && !self.contentScrollView.isDecelerating)
        {
            self.tapGestureRecognizer.enabled = YES;
            self.longPressGestureRecognizer.enabled = (self.cellData.state = CMLTableViewCellStateCenter);
        }
        else
        {
            self.tapGestureRecognizer.enabled = NO;
            self.longPressGestureRecognizer.enabled = NO;
        }
        
        self.contentScrollView.scrollEnabled = !self.isEditing;
    }
}
#pragma mark - UITableViewCell overrides

- (void)didMoveToSuperview
{
    self.tableView = nil;
    UIView *view = self.superview;
    
    do {
        if ([view isKindOfClass:[UITableView class]])
        {
            self.tableView = (UITableView *)view;
            break;
        }
    } while ((view = view.superview));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Offset the contentView origin so that it appears correctly w/rt the enclosing scroll view (to which we moved it).
    CGRect frame = self.contentView.frame;
    frame.origin.x = [self leftSliderViewWidth];
    _contentScrollView.frame = frame;
    
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) + [self totalSlidersOffsetX], CGRectGetHeight(self.frame));
    
    if (!self.contentScrollView.isTracking && !self.contentScrollView.isDecelerating)
    {
        self.contentScrollView.contentOffset = [self contentOffsetForCellState:_cellData.state];
    }
    
    [self updateCellState];
}

- (void)setFrame:(CGRect)frame
{
    self.layoutUpdating = YES;
    // Fix for new screen sizes
    // Initially, the cell is still 320 points wide
    // We need to layout our subviews again when this changes so our constraints clip to the right width
    BOOL widthChanged = (self.frame.size.width != frame.size.width);
    
    [super setFrame:frame];
    
    if (widthChanged)
    {
        [self layoutIfNeeded];
    }
    self.layoutUpdating = NO;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self hideSlidersAnimated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    
    [super setSelected:selected animated:animated];

}
- (BOOL)shouldHighlight
{
    BOOL shouldHighlight = YES;
    
    if ([self.tableView.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)])
    {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:self];
        
        shouldHighlight = [self.tableView.delegate tableView:self.tableView shouldHighlightRowAtIndexPath:cellIndexPath];
    }
    
    return shouldHighlight;
}

- (void)selectCell
{
    if (_cellData.state == CMLTableViewCellStateCenter)
    {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:self];
        
        if ([self.tableView.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
        {
            cellIndexPath = [self.tableView.delegate tableView:self.tableView willSelectRowAtIndexPath:cellIndexPath];
        }
        
        if (cellIndexPath)
        {
            [self.tableView selectRowAtIndexPath:cellIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
            {
                [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:cellIndexPath];
            }
        }
    }
}

- (void)deselectCell
{
    if (_cellData.state == CMLTableViewCellStateCenter)
    {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:self];
        
        if ([self.tableView.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
        {
            cellIndexPath = [self.tableView.delegate tableView:self.tableView willDeselectRowAtIndexPath:cellIndexPath];
        }
        
        if (cellIndexPath)
        {
            [self.tableView deselectRowAtIndexPath:cellIndexPath animated:NO];
            
            if ([self.tableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
            {
                [self.tableView.delegate tableView:self.tableView didDeselectRowAtIndexPath:cellIndexPath];
            }
        }
    }
}




- (void)didTransitionToState:(UITableViewCellStateMask)state {
    [super didTransitionToState:state];
    
    if (state == UITableViewCellStateDefaultMask) {
        [self layoutSubviews];
    }
}
#pragma mark - CMLDelegate
-(void)CMLRootViewControllerDidChangeUI:(__kindof CMLBaseContainer*)rootViewController{
    if([self.delegate respondsToSelector:@selector(CMLTableViewCellDidChangeUI:)]){
        [self.delegate CMLTableViewCellDidChangeUI:self];
    }
    
}
-(void)CMLViewControllerDidTriggerSingleClickEvent:(__kindof CMLBaseViewController *)viewController{
    if([self.delegate respondsToSelector:@selector(CMLTableViewCell:didTriggerSingleClickEventFromCMLViewController:)]){
        [self.delegate CMLTableViewCell:self didTriggerSingleClickEventFromCMLViewController:viewController];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ((gestureRecognizer == self.tableView.panGestureRecognizer && otherGestureRecognizer == self.longPressGestureRecognizer)
        || (gestureRecognizer == self.longPressGestureRecognizer && otherGestureRecognizer == self.tableView.panGestureRecognizer))
    {
        // Return YES so the pan gesture of the containing table view is not cancelled by the long press recognizer
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![touch.view isKindOfClass:[UIControl class]];
}
@end
