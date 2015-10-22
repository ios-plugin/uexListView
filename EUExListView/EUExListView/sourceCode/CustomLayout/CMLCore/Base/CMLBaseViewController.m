//
//  CMLBaseViewController.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLBaseViewController.h"
#import "CMLLinearContainer.h"
#import "CMLRelativeContainer.h"
#import "CMLTextViewController.h"
#import "CMLImageViewController.h"
#import "CMLButtonViewController.h"
#import <KVOMutableArray/KVOMutableArray+ReactiveCocoaSupport.h>
@interface CMLBaseViewController()

@end



@implementation CMLBaseViewController


+(instancetype)CMLViewControllerWithModel:(__kindof CMLBaseViewModel *)model father:(__kindof CMLBaseContainer *)father{
    if(!model){
        return nil;
    }
    switch (model.type) {
        case CMLViewModelUndefined: {
            return nil;
            break;
        }
        case CMLViewModelLinearContainerModel: {
            return [[CMLLinearContainer alloc]initWithModel:model father:father];
            break;
        }
        case CMLViewModelRelativeContainerModel: {
            return [[CMLRelativeContainer alloc]initWithModel:model father:father];
            break;
        }
        case CMLViewModelImageViewModel: {
            return [[CMLImageViewController alloc]initWithModel:model father:father];
            break;
        }
        case CMLViewModelButtonViewModel: {
            return [[CMLBaseViewController alloc]initWithModel:model father:father];
            break;
        }
        case CMLViewModelTextViewModel: {
            return [[CMLTextViewController alloc]initWithModel:model father:father];
            break;
        }

    }


}

-(instancetype)initWithModel:(CMLBaseViewModel *)model father:(CMLBaseContainer *)father{
    self=[super init];
    if(self){
        self.model=model;
        self.father=father;
        self.innerView=[self makeInnerView];
    }
    return self;
}




-(void)loadView{
    UIImageView *view=[[UIImageView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    view.userInteractionEnabled = YES;
    self.view=view;
    
    [self.view addSubview:self.innerView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [[[RACObserve(self.model, identifier) distinctUntilChanged]
      deliverOn:[RACScheduler scheduler]]
     subscribeNext:^(NSString *identifier) {
         @strongify(self);
         [[self getRoot].namedViewControllers setValue:self forKey:identifier];
     }];
    
    [[[[RACObserve(self.model, bgString) distinctUntilChanged]
       filter:^BOOL(NSString *bgString) {
           return ([bgString length]>0);
       }]
      deliverOn:[RACScheduler scheduler]]
     subscribeNext:^(NSString *bgString) {
         @strongify(self);
         [self addAChange];
         __kindof CMLContainerModel *rootModel=[self getRoot].model;
         NSString *imageFilePath=[rootModel.mappingCenter mappingFilePath:bgString];
         
         UIImage *bgImage=[UIImage imageWithContentsOfFile:imageFilePath];
         if(bgImage){
             CML_ASYNC_DO_IN_MAIN_QUEUE(^{
                 [((UIImageView *)self.view) setImage:bgImage];
                 [self finishAChange];
             });
         }else{
             UIColor *bgColor =[UIColor CML_ColorFromHtmlString:bgString];
             CML_ASYNC_DO_IN_MAIN_QUEUE(^{
                 [self.view setBackgroundColor:bgColor];
                 [self finishAChange];
             });
             
         }
     }];
    
    

}

- (void)viewWillAppear:(BOOL)animated{
    @weakify(self);
    [[[self.model.padding.edgeDifferenceDidChangeSignal distinctUntilChanged]
      deliverOn:[RACScheduler scheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self addAChange];
         
         CML_ASYNC_DO_IN_MAIN_QUEUE(^{
             [self layoutPadding];
             [self finishAChange];
         });
         
     }];
    
    
    [[[RACSignal combineLatest:@[RACObserve(self.model, width),RACObserve(self.model, height),RACObserve(self.model, weight)]]
      deliverOn:[RACScheduler scheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self addAChange];
         CML_ASYNC_DO_IN_MAIN_QUEUE(^{
             if(self.father && self.father.model.type == CMLViewModelLinearContainerModel){
                 CMLLinearContainerModel *linearModel=self.father.model;
                 switch (linearModel.orientation) {
                     case CMLLinearContainerOrientationVertical: {
                         [self layoutWidth];
                         [self layoutHeightByWeight];
                         break;
                     }
                     case CMLLinearContainerOrientationHorizental: {
                         [self layoutWidthByWeight];
                         [self layoutHeight];
                         break;
                     }

                 }
             }else{
                 [self layoutWidth];
                 [self layoutHeight];
             }
             [self finishAChange];
             
         });
     }];
    if(!self.father){
        [[self.model.margin.edgeDifferenceDidChangeSignal
          deliverOn:[RACScheduler scheduler]] subscribeNext:^(id x) {
            [self addAChange];
            CML_ASYNC_DO_IN_MAIN_QUEUE(^{
                [self layoutMargin];
                
            });
        }];

        return;
    }
    if(self.father.model.type == CMLViewModelLinearContainerModel){
        [[[RACSignal merge:@[self.model.gravityInfo.xAlign.aligmentDidChangeSignal,self.model.gravityInfo.yAlign.aligmentDidChangeSignal]]
         deliverOn:[RACScheduler scheduler]]
         subscribeNext:^(id x) {
             [self addAChange];
             CML_ASYNC_DO_IN_MAIN_QUEUE(^{
                 [self layoutMarginWithGravityInLinearContainer];
             });
        }];
    }
    if(self.father.model.type ==CMLViewModelRelativeContainerModel){
        [[[RACSignal merge:@[self.model.floatInfo.xAlign.aligmentDidChangeSignal,self.model.floatInfo.yAlign.aligmentDidChangeSignal]]
          deliverOn:[RACScheduler scheduler]]
         subscribeNext:^(id x) {
             [self addAChange];
             CML_ASYNC_DO_IN_MAIN_QUEUE(^{
                 [self layoutMarginWithGravityInLinearContainer];
             });
         }];
        [[self.model.relations.changeSignal filter:^BOOL(id value) {
#warning TODO
            return YES;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self addAChange];
            
            CML_ASYNC_DO_IN_MAIN_QUEUE(^{
                [self layoutRelationInRelativeContainer];

                [self finishAChange];
            });

        }];
    }

}




-(CMLBaseContainer *)getRoot{
    if(self.father){
        return [self.father getRoot];
    }else{
        return (CMLBaseContainer *)self;
    }
}

-(void)addAChange{
    [[self getRoot] addAChange];
}

-(void)finishAChange{
    [[self getRoot] finishAChange];
}
-(UIView*)makeInnerView{
    //子类必须覆写此方法！
    return nil;
}




#pragma mark - layout method


-(void)layoutPadding{
    @weakify(self);
    [self.innerView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(self.model.padding.top, self.model.padding.left, self.model.padding.bottom, self.model.padding.right));
    }];
    
}

-(void)layoutHeight{
    @weakify(self);
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        if(self.model.height == -1){
            make.height.equalTo(self.father.innerView.mas_height);
        }else if (self.model.height>=0){
            make.height.equalTo(@(self.model.height));
        }
    }];
}

-(void)layoutHeightByWeight{
    if(self.model.weight <=0 ||self.father.model.type!=CMLViewModelLinearContainerModel){
        [self layoutHeight];
        return;
    }
    CMLLinearContainer *linearFather=(CMLLinearContainer *)self.father;
    NSUInteger index =[linearFather.weightedChildrenViewControllers indexOfObject:self];
    if(index < [linearFather.weightedChildrenViewControllers count]-1){
        CMLBaseViewController *nextViewController=(CMLBaseViewController *)linearFather.weightedChildrenViewControllers[index+1];
        @weakify(self,nextViewController);
        [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self,nextViewController);
            make.height.equalTo(nextViewController.view.mas_height).multipliedBy(self.model.weight/nextViewController.model.weight).priorityHigh();
        }];
    }
}

-(void)layoutWidth{
    @weakify(self);
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        if(self.model.width == -1){
            make.width.equalTo(self.father.innerView.mas_width);
        }else if (self.model.width>=0){
            make.width.equalTo(@(self.model.width));
        }
    }];
}

-(void)layoutWidthByWeight{
    if(self.model.weight <=0 ||self.father.model.type!=CMLViewModelLinearContainerModel){
        [self layoutHeight];
        return;
    }
    CMLLinearContainer *linearFather=(CMLLinearContainer *)self.father;
    NSUInteger index =[linearFather.weightedChildrenViewControllers indexOfObject:self];
    if(index < [linearFather.weightedChildrenViewControllers count]-1){
        CMLBaseViewController *nextViewController=linearFather.weightedChildrenViewControllers[index+1];
        @weakify(self,nextViewController);
        [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self,nextViewController);
            make.width.equalTo(nextViewController.view.mas_width).multipliedBy(self.model.weight/nextViewController.model.weight).priorityHigh();
        }];
    }
}




-(void)layoutMargin{
    @weakify(self);
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.top.greaterThanOrEqualTo(self.father.innerView.mas_top).with.offset(self.model.margin.top).priorityHigh();
        make.bottom.lessThanOrEqualTo(self.father.innerView.mas_bottom).with.offset(-self.model.margin.bottom).priorityHigh();
        make.left.greaterThanOrEqualTo(self.father.innerView.mas_left).with.offset(self.model.margin.left).priorityHigh();
        make.right.lessThanOrEqualTo(self.father.innerView.mas_right).with.offset(-self.model.margin.right).priorityHigh();
    }];
    
}



-(void)layoutMarginWithGravityInLinearContainer{
    [self layoutMargin];
    if(!self.father||self.father.model.type != CMLViewModelLinearContainerModel){
        return;
    }
    NSUInteger index = [self.father.childViewControllers indexOfObject:self];
    
    CMLLinearContainer *fatherLinearContainer=self.father;
    CMLLinearContainerModel *fatherModel=fatherLinearContainer.model;
    @weakify(self,fatherModel);
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self,fatherModel);
        switch (fatherModel.orientation) {
            case CMLLinearContainerOrientationVertical: {
                if(index == 0){
                    make.top.equalTo(self.father.innerView.mas_top).with.offset(self.model.margin.top);
                }
                if(index < [self.father.childrenViewControllers count]-1){
                    CMLBaseViewController *nextViewController=(CMLBaseViewController *)self.father.childrenViewControllers[index+1];
                    make.bottom.equalTo(nextViewController.view.mas_top).with.offset(-self.model.margin.bottom-nextViewController.model.margin.top);
                }else{
                    make.bottom.equalTo(self.father.innerView.mas_bottom).with.offset(-self.model.margin.bottom);
                }
                
                
                CMLAlignmentInfo *gravityInfo=self.father.model.gravityInfo;
                switch (gravityInfo.xAlign.type) {
                    case CMLAlignmentIgnored:{
                        make.left.equalTo(self.father.innerView.mas_left).with.offset(gravityInfo.xAlign.offset).priority(50);
                        break;
                    }
                    case CMLAlignmentHead:{
                        make.left.equalTo(self.father.innerView.mas_left).with.offset(gravityInfo.xAlign.offset).priorityLow();
                    }
                    case CMLAlignmentMiddle:{
                        make.centerX.equalTo(self.father.innerView.mas_centerX).with.offset(gravityInfo.xAlign.offset).priorityLow();
                    }
                    case CMLAlignmentTail:{
                        make.right.equalTo(self.father.innerView.mas_right).with.offset(-gravityInfo.xAlign.offset).priorityLow();
                    }

                }
                
                break;
            }
            case CMLLinearContainerOrientationHorizental: {
                if(index == 0){
                    make.left.equalTo(self.father.innerView.mas_left).with.offset(self.model.margin.left);
                }
                if(index < [self.father.childrenViewControllers count]-1){
                    CMLBaseViewController *nextViewController=(CMLBaseViewController *)self.father.childrenViewControllers[index+1];
                    make.right.equalTo(nextViewController.view.mas_left).with.offset(-self.model.margin.right-nextViewController.model.margin.left);
                }else{
                    make.right.equalTo(self.father.innerView.mas_right).with.offset(-self.model.margin.right);
                }
                
                
                
                CMLAlignmentInfo *gravityInfo=self.father.model.gravityInfo;
                switch (gravityInfo.yAlign.type) {
                    case CMLAlignmentIgnored: {
                        make.top.equalTo(self.father.inputView.mas_top).with.offset(gravityInfo.yAlign.offset).priority(50);
                        break;
                    }
                    case CMLAlignmentHead: {
                        make.centerY.equalTo(self.father.innerView.mas_centerY).with.offset(gravityInfo.yAlign.offset).priorityLow();
                        break;
                    }
                    case CMLAlignmentMiddle: {
                        make.top.equalTo(self.father.inputView.mas_top).with.offset(gravityInfo.yAlign.offset).priorityLow();
                        break;
                    }
                    case CMLAlignmentTail: {
                        make.bottom.equalTo(self.father.inputView.mas_bottom).with.offset(-gravityInfo.yAlign.offset).priorityLow();
                        break;
                    }

                }
                break;
            }

        }


        

    
    }];

}


-(void)layoutMarginWithFloatInRelativeContainer{
    [self layoutMargin];
    if(!self.father||self.father.model.type != CMLViewModelRelativeContainerModel){
        return;
    }
    @weakify(self);
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        CMLAlignmentInfo *floatInfo=self.father.model.floatInfo;
        switch (floatInfo.xAlign.type) {
            case CMLAlignmentIgnored: {
                
                break;
            }
            case CMLAlignmentHead: {
                make.left.equalTo(self.father.innerView.mas_left).with.offset(floatInfo.xAlign.offset).priorityLow();
                break;
            }
            case CMLAlignmentMiddle: {
                make.centerX.equalTo(self.father.innerView.mas_centerX).with.offset(floatInfo.xAlign.offset).priorityLow();
                break;
            }
            case CMLAlignmentTail: {
                make.right.equalTo(self.father.innerView.mas_right).with.offset(-floatInfo.xAlign.offset).priorityLow();
                break;
            }
            default: {
                break;
            }
        }
        switch (floatInfo.yAlign.type) {
            case CMLAlignmentIgnored: {
                
                break;
            }
            case CMLAlignmentHead: {
                make.top.equalTo(self.father.inputView.mas_top).with.offset(floatInfo.yAlign.offset).priorityLow();
                break;
            }
            case CMLAlignmentMiddle: {
                make.centerY.equalTo(self.father.innerView.mas_centerY).with.offset(floatInfo.yAlign.offset).priorityLow();
                break;
            }
            case CMLAlignmentTail: {
                make.bottom.equalTo(self.father.inputView.mas_bottom).with.offset(-floatInfo.yAlign.offset).priorityLow();
                break;
            }
            default: {
                break;
            }
        }
    }];
}

-(void)layoutRelationInRelativeContainer{
    if(!self.father||self.father.model.type != CMLViewModelRelativeContainerModel){
        return;
    }
    @weakify(self);
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        for (CMLElementRelation * relation in self.model.relations) {
            if (![[[self getRoot].namedViewControllers allKeys] containsObject:relation.targetId]) {
                continue;
            }
            CMLBaseViewController *targetViewController =(CMLBaseViewController *)[[self getRoot].namedViewControllers objectForKey:relation.targetId];
            switch (relation.type) {
                case CMLElementRelationAbove: {
                    make.bottom.lessThanOrEqualTo(targetViewController.view.mas_top).with.offset(-self.model.margin.bottom-targetViewController.model.margin.top);
                    break;
                }
                case CMLElementRelationLeftOf: {
                     make.right.lessThanOrEqualTo(targetViewController.view.mas_left).with.offset(-self.model.margin.right-targetViewController.model.margin.left);
                    break;
                }
                case CMLElementRelationBelow: {
                    make.top.greaterThanOrEqualTo(targetViewController.view.mas_bottom).with.offset(self.model.margin.top+targetViewController.model.margin.bottom);
                    break;
                }
                case CMLElementRelationRightOf: {
                    make.left.greaterThanOrEqualTo(targetViewController.view.mas_right).with.offset(self.model.margin.left+targetViewController.model.margin.right);
                    break;
                }
            }
        }
    }];
    
}

@end
