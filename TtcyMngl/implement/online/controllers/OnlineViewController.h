//
//  OnlineViewController.h
//  TtcyMngl
//
//  Created by 牛利江 on 14-7-1.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlineCelebritView.h"
#import "Model.h"


@interface OnlineViewController : UIViewController<CelebritTypeDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView *celebrityTableView;
    NSMutableArray *_models;
    NSInteger  _nonceType;
    NSMutableArray *_typeModel;

}
@property(nonatomic,assign) NSInteger pageSize; //分页 每页大小
@property(nonatomic,assign) NSInteger pageCount; //分页 每页大小
@property(nonatomic,copy) NSString *navigationUrl;
@property(nonatomic,copy) NSString *navigationTitle;
@property(nonatomic,nonatomic)UIView *mostlyView;
@property(nonatomic,copy) NSString *Url;
@property(nonatomic,copy) NSString *modeName;
-(void)OnlineviewDidLoad;
-(void)loadMore;

-(void)initialize;
-(void)initView;

@end
