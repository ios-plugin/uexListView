//
//  CMLMacros.h
//  CeriXMLLayout
//
//  Created by CeriNo on 15/10/13.
//  Copyright © 2015年 Vheissu. All rights reserved.
//

#ifndef CMLMacros_h
#define CMLMacros_h

#define CML_ASYNC_DO_IN_GLOBAL_QUEUE(x) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), x)
#define CML_ASYNC_DO_IN_MAIN_QUEUE(x) dispatch_async(dispatch_get_main_queue(), x)


#endif /* CMLMacros_h */
