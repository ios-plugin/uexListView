//
//  CMLButtonViewController.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLButtonViewController.h"

@interface CMLButtonViewController ()

@end

@implementation CMLButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    CMLButtonViewModel *buttonModel=self.model;
    [[[[RACSignal combineLatest:@[RACObserve(buttonModel, text),RACObserve(buttonModel, textColor),RACObserve(buttonModel, textSize),RACObserve(buttonModel, maxLines)]]distinctUntilChanged]
      deliverOn:[RACScheduler scheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self addAChange];
         UILabel *innerView=(UILabel *)self.innerView;
         CML_ASYNC_DO_IN_MAIN_QUEUE(^{
             [innerView setText:buttonModel.text];
             [innerView setTextColor:buttonModel.textColor];
             [innerView setNumberOfLines:buttonModel.maxLines];
             if(buttonModel.textSize){
                 [innerView setFont:[UIFont systemFontOfSize:buttonModel.textSize]];
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
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled=YES;
    return button;
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
