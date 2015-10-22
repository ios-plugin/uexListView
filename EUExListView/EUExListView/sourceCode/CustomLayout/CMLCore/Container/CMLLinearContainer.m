//
//  CMLLinearContainer.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLLinearContainer.h"

@interface CMLLinearContainer ()

@end

@implementation CMLLinearContainer


- (instancetype)initWithModel:(__kindof CMLBaseViewModel *)model father:(__kindof CMLBaseContainer *)father
{
    self = [super initWithModel:model father:father];
    if (self) {
        for (int i=0; i<self.childrenViewControllers.count; i++) {
            CMLBaseViewController *aViewController = self.childrenViewControllers[i];
            if(aViewController.model.weight>0){
                if(!_weightedChildrenViewControllers){
                    _weightedChildrenViewControllers=[NSMutableArray array];
                }
                [self.weightedChildrenViewControllers addObject:aViewController];
            }
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
