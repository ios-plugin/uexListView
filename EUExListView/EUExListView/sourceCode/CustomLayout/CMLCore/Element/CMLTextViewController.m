//
//  CMLTextViewController.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLTextViewController.h"

@interface CMLTextViewController ()

@end

@implementation CMLTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    CMLTextViewModel *textModel=self.model;
    [[[[RACSignal combineLatest:@[RACObserve(textModel, text),RACObserve(textModel, textColor),RACObserve(textModel, textSize),RACObserve(textModel, maxLines)]]distinctUntilChanged]
      deliverOn:[RACScheduler scheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self addAChange];
         UILabel *innerView=(UILabel *)self.innerView;
         CML_ASYNC_DO_IN_MAIN_QUEUE(^{
             [innerView setText:textModel.text];
             [innerView setTextColor:textModel.textColor];
             [innerView setNumberOfLines:textModel.maxLines];
             if(textModel.textSize){
                 [innerView setFont:[UIFont systemFontOfSize:textModel.textSize]];
             }
             [self finishAChange];
         });
         
         
     }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)makeInnerView{
    UILabel *label=[[UILabel alloc]init];
    label.userInteractionEnabled=YES;
    return label;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
