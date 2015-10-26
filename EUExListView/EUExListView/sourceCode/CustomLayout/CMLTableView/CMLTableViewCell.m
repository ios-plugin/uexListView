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

@property (nonatomic,strong)__kindof CMLBaseContainer *leftSliderViewController,*rightSliderViewController;
@property (nonatomic,strong)UIView *leftContentView,*rightContentView;
@property (nonatomic,strong)CMLCellScrollView *contentScrollView;
@property (nonatomic,strong)UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic,strong)CMLCellLongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic,assign)BOOL layoutUpdating;


@end



@implementation CMLTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){


    }
    return self;
}


-(void)modifyWithTableView:(__kindof UITableView *)tableView data:(CMLTableViewCellData *)data{
    self.cellData=data;
    

    [self setupContentScrollView];
    [self setupTapGesture];
    [self setupLongPressGesture];
    [self setupLeftSlider];
    [self setupRightSlider];
    [self setTableView:tableView];
    
    



}

-(void)setTableView:(__kindof UITableView *)tableView{
    self.tableView=tableView;
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
        make.right.equalTo(self.contentScrollView.mas_left);
        make.top.equalTo(self.contentScrollView.mas_top);
        make.bottom.equalTo(self.contentScrollView.mas_bottom);
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
        make.left.equalTo(self.contentScrollView.mas_right);
        make.top.equalTo(self.contentScrollView.mas_top);
        make.bottom.equalTo(self.contentScrollView.mas_bottom);
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
}

-(void)setupContentScrollView{
    self.contentScrollView = [[CMLCellScrollView alloc] init];
    self.contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentScrollView.delegate = self;
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
    [_contentScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self);
    }];

}
-(void)setupTapGesture{
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [[[self.tapGestureRecognizer rac_gestureSignal]
     takeUntil:self.rac_prepareForReuseSignal]
subscribeNext:^(id x) {
        
    }];
    self.tapGestureRecognizer.cancelsTouchesInView = NO;
    self.tapGestureRecognizer.delegate = self;
    [self.contentScrollView addGestureRecognizer:self.tapGestureRecognizer];
    
}

-(void)setupLongPressGesture{

        self.longPressGestureRecognizer = [[CMLCellLongPressGestureRecognizer alloc]init];
        [[[self.longPressGestureRecognizer rac_gestureSignal]
          takeUntil:self.rac_prepareForReuseSignal ]
         subscribeNext:^(id x) {
            
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
        
        self.leftUtilityClipConstraint.constant = MAX(0, CGRectGetMinX(frame) - CGRectGetMinX(self.frame));
        self.rightUtilityClipConstraint.constant = MIN(0, CGRectGetMaxX(frame) - CGRectGetMaxX(self.frame));
        
        if (self.isEditing) {
            self.leftUtilityClipConstraint.constant = 0;
            self.cellScrollView.contentOffset = CGPointMake([self leftUtilityButtonsWidth], 0);
            _cellState = kCellStateCenter;
        }
        
        self.leftUtilityClipView.hidden = (self.leftUtilityClipConstraint.constant == 0);
        self.rightUtilityClipView.hidden = (self.rightUtilityClipConstraint.constant == 0);
        
        if (self.accessoryType != UITableViewCellAccessoryNone && !self.editing) {
            UIView *accessory = [self.cellScrollView.superview.subviews lastObject];
            
            CGRect accessoryFrame = accessory.frame;
            accessoryFrame.origin.x = CGRectGetWidth(frame) - CGRectGetWidth(accessoryFrame) - kAccessoryTrailingSpace + CGRectGetMinX(frame);
            accessory.frame = accessoryFrame;
        }
        
        // Enable or disable the gesture recognizers according to the current mode.
        if (!self.cellScrollView.isDragging && !self.cellScrollView.isDecelerating)
        {
            self.tapGestureRecognizer.enabled = YES;
            self.longPressGestureRecognizer.enabled = (_cellState == kCellStateCenter);
        }
        else
        {
            self.tapGestureRecognizer.enabled = NO;
            self.longPressGestureRecognizer.enabled = NO;
        }
        
        self.cellScrollView.scrollEnabled = !self.isEditing;
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
