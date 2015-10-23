//
//  CMLButtonViewModel.h
//  EUExListView
//
//  Created by CeriNo on 15/10/22.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "CMLBaseViewModel.h"

@interface CMLButtonViewModel : CMLBaseViewModel
@property (nonatomic,copy  ) NSString  *text;
@property (nonatomic,strong) UIColor   *textColor;
@property (nonatomic,assign) CGFloat   textSize;
@property (nonatomic,assign) NSInteger maxLines;
@end
