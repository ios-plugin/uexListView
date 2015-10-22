//
//  CMLImageViewController.m
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLImageViewController.h"
#import "CMLBaseContainer.h"
#import "UIImageView+WebCache.h"
@interface CMLImageViewController ()

@end

@implementation CMLImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    @weakify(self);
    CMLImageViewModel * imageModel=self.model;
    [[[RACSignal combineLatest:@[[RACObserve(imageModel, scaleType) distinctUntilChanged],[RACObserve(imageModel, imageSrc) distinctUntilChanged],[RACObserve(imageModel, placeholderPath) distinctUntilChanged]]]
      deliverOn:[RACScheduler scheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         __kindof CMLContainerModel *rootModel=[self getRoot].model;
         NSString *mappingSrc=[rootModel.mappingCenter mappingFilePath:imageModel.imageSrc];
         NSString *mappingPlaceHolderPath=[rootModel.mappingCenter mappingFilePath:imageModel.placeholderPath];
         UIImage *placeHolderImage=[mappingPlaceHolderPath length]>0?[UIImage imageWithContentsOfFile:mappingPlaceHolderPath]:nil;
         SDWebImageOptions options=0;
         if(imageModel.webCacheOptions & CMLImageWebCacheRefreshCached){
             options =options|SDWebImageRefreshCached;
         }
         if(imageModel.webCacheOptions & CMLImageWebCacheOnlyMemory){
             options =options|SDWebImageCacheMemoryOnly;
         }
         if(imageModel.webCacheOptions & CMLImageWebCacheAllowInvalidSSLCertificates){
             options =options|SDWebImageAllowInvalidSSLCertificates;
         }
         CML_ASYNC_DO_IN_MAIN_QUEUE(^{
             [((UIImageView*)self.innerView) sd_setImageWithURL:[NSURL URLWithString:mappingSrc]
                          placeholderImage:placeHolderImage
                                   options:options
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                 }];
         });
     }];
    
    [[[RACObserve(imageModel, scaleType) distinctUntilChanged]
      deliverOn:[RACScheduler scheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self addAChange];
         UIViewContentMode mode=UIViewContentModeCenter;
         switch (imageModel.scaleType) {
             case CMLImageScaleUndefined: {
                 break;
             }
             case CMLImageScaleFitXY: {
                 mode=UIViewContentModeScaleToFill;

                 break;
             }
             case CMLImageScaleCenter: {
                 
                 break;
             }
             case CMLImageScaleCenterCrop: {
                 mode=UIViewContentModeScaleAspectFill;
                 break;
             }
             case CMLImageScaleCenterInside: {
                 mode=UIViewContentModeScaleAspectFit;
                 break;
             }

         }
         
         CML_ASYNC_DO_IN_MAIN_QUEUE(^{
             [self.innerView setContentMode:mode];
             [self finishAChange];
         });
     }];
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
-(UIImageView*)makeInnerView{
    UIImageView *innerView =[[UIImageView alloc]init];
    innerView.userInteractionEnabled=YES;
    
    return innerView;
}
@end
