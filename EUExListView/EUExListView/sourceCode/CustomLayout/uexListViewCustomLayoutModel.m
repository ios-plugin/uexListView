//
//  uexListViewCustomLayoutModel.m
//  EUExListView
//
//  Created by CeriNo on 15/10/29.
//  Copyright © 2015年 AppCan.can. All rights reserved.
//

#import "uexListViewCustomLayoutModel.h"

#import "CMLTableViewCellData.h"
#import "EUExListView.h"

typedef NS_ENUM(NSInteger,uexListViewCustomLayoutXMLDataSource) {
    uexListViewCustomLayoutXMLDataLeft,
    uexListViewCustomLayoutXMLDataCenter,
    uexListViewCustomLayoutXMLDataRight
};



@interface uexListViewCustomLayoutModel()
@property (nonatomic,strong,readwrite)NSMutableDictionary<NSString *,ONOXMLDocument *> *leftXMLDictionary;
@property (nonatomic,strong,readwrite)NSMutableDictionary<NSString *,ONOXMLDocument *> *centerXMLDictionary;
@property (nonatomic,strong,readwrite)NSMutableDictionary<NSString *,ONOXMLDocument *> *rightXMLDictionary;
@property (nonatomic,assign,readwrite)uexListViewCustomLayoutRefreshMode refreshMode;
@property (nonatomic,assign,readwrite)uexListViewCustomLayoutSwipeType swipeType;

@property (nonatomic,strong,readwrite)NSMutableArray<CMLTableViewCellData *> *cellDataSource;


@end
@implementation uexListViewCustomLayoutModel


- (instancetype)initWithEUExListView:(EUExListView *)euexObj
{
    self = [super init];
    if (self) {
        self.leftXMLDictionary=[NSMutableDictionary dictionary];
        self.centerXMLDictionary=[NSMutableDictionary dictionary];
        self.rightXMLDictionary=[NSMutableDictionary dictionary];
        self.cellDataSource=[NSMutableArray array];
        self.swipeType=uexListViewCustomLayoutSwipeTypeNone;
        self.refreshMode=uexListViewCustomLayoutRefreshBothTopAndBottom;
        self.euexObj=euexObj;
        self.leftSliderLimit=-1;
        self.rightSliderLimit=-1;
    }
    return self;
}

-(void)reset{
    [self.leftXMLDictionary removeAllObjects];
    [self.centerXMLDictionary removeAllObjects];
    [self.rightXMLDictionary removeAllObjects];
    [self.cellDataSource removeAllObjects];
}


-(BOOL)parseXMLData:(NSDictionary *)info{
    if(![info objectForKey:@"layout"]||![[info objectForKey:@"layout"] isKindOfClass:[NSDictionary class]]){
        return NO;
    }
    NSDictionary *layoutDict=[info objectForKey:@"layout"];
    if(![layoutDict objectForKey:@"center"]||![[layoutDict objectForKey:@"center"] isKindOfClass:[NSArray class]]){
        return NO;
    }
    [self parseXMLFromData:layoutDict byKey:@"center" toDict:self.centerXMLDictionary];
    [self parseXMLFromData:layoutDict byKey:@"left" toDict:self.leftXMLDictionary];
    [self parseXMLFromData:layoutDict byKey:@"right" toDict:self.rightXMLDictionary];
    return YES;
}

-(void)parseXMLFromData:(NSDictionary *)dataDict byKey:(NSString *)key toDict:(NSMutableDictionary *)target{
    if(![dataDict objectForKey:key]||![[dataDict objectForKey:key] isKindOfClass:[NSArray class]]){
        return ;
    }
    NSArray *xmlObjectArray=[dataDict objectForKey:key];
    for(NSDictionary *xmlObject in xmlObjectArray){
        if([xmlObject objectForKey:@"src"]||![xmlObject objectForKey:@"type"]){
            continue;
        }
        NSError *error=nil;
        ONOXMLDocument *document =[ONOXMLDocument XMLDocumentWithData:[NSData dataWithContentsOfFile:[self.euexObj absPath:[[xmlObject objectForKey:@"src"] CML_toString]]] error:&error];
        NSString *type=[[xmlObject objectForKey:@"type"] CML_toString];
        if(type){
            [target setValue:document forKey:type];
        }
    }
}
-(BOOL)parseSwipeType:(NSDictionary *)info{
    if(![info objectForKey:@"swipeMode"]){
        return NO;
    }
    NSInteger mode=[[info objectForKey:@"swipeMode"] integerValue];
    if(![@[@0,@1,@2,@3] containsObject:@(mode)]){
        return NO;
    }
    self.swipeType=(uexListViewCustomLayoutSwipeType)mode;
    return YES;
}
-(BOOL)parseRefreshMode:(NSDictionary *)info{
    if(![info objectForKey:@"refreshMode"]){
        return NO;
    }
    NSInteger mode=[[info objectForKey:@"refreshMode"] integerValue];
    if(![@[@0,@1,@2,@3] containsObject:@(mode)]){
        return NO;
    }
    self.refreshMode=(uexListViewCustomLayoutRefreshMode)mode;
    return YES;
}
-(BOOL)parseSliderWidth:(NSDictionary *)info{
    if([info objectForKey:@"offsetLeft"]){
        self.leftSliderLimit=[[info objectForKey:@"offsetLeft"] floatValue];
    }
    if([info objectForKey:@"offsetRight"]){
        self.leftSliderLimit=[[info objectForKey:@"offsetRight"] floatValue];
    }
    return YES;
}
-(void)resetCellDataSource:(NSArray *)dataArray{
    [self.cellDataSource removeAllObjects];
    for(int i=0;i<dataArray.count;i++){
        if([dataArray[i] isKindOfClass:[NSDictionary class]]){
            [self addCellData:dataArray[i]];
        }
    }
    
}



-(void)addCellData:(NSDictionary *)dataInfo{
    __kindof CMLBaseViewModel *leftModel,*centerModel,*rightModel;
    centerModel=[self fetchModelFromXML:uexListViewCustomLayoutXMLDataCenter byKey:@"center"];
    switch (self.swipeType) {
        case uexListViewCustomLayoutSwipeTypeNone:{
            
            break;
        }
        case uexListViewCustomLayoutSwipeTypeBothLeft:{
            break;
        }
        case uexListViewCustomLayoutSwipeTypeOnlyLeft:{
            break;
        }
        case uexListViewCustomLayoutSwipeTypeOnlyRight:{
            break;
        }

    }
    //CMLTableViewCellData *cellData=[CMLTableViewCellData alloc]initWithCenterModel:[CeriXMLLayout modelWithXMLData:[self.]] leftSliderModel:<#(__kindof CMLContainerModel *)#> rightSliderModel:<#(__kindof CMLContainerModel *)#>
}


-(__kindof CMLBaseViewModel *)fetchModelFromXML:(uexListViewCustomLayoutXMLDataSource)datasource byKey:(NSString *)key{
    NSDictionary<NSString *,ONOXMLDocument *> *target=nil;
    switch (datasource) {
        case uexListViewCustomLayoutXMLDataLeft:{
            target=self.leftXMLDictionary;
            break;
        }
        case uexListViewCustomLayoutXMLDataRight:{
            target=self.rightXMLDictionary;
            break;
        }
        case uexListViewCustomLayoutXMLDataCenter:{
            target=self.centerXMLDictionary;
        }

    }
    ONOXMLDocument *doc=[target objectForKey:key];
    if(doc){
        return [CeriXMLLayout modelWithXMLData:doc.rootElement];
    }
}


@end
