//
//  AboutViewController.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "AboutViewController.h"
#import "SHLUILabel.h"
#import "VerticalTextView.h"

@interface AboutViewController ()

@property (nonatomic,strong)NSString * contentDetail;
@property (nonatomic,strong)UIScrollView * scrolContent;

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBaseCondition];
    [self setData];
    [self createContent];
}
-(void)setBaseCondition
{
    getPlayBarHeight();
    if (is4Inch) {
        self.view.backgroundColor = CENT_COLOR_4INCH;
    }else{
        self.view.backgroundColor = CENT_COLOR;
    }
    if (isIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}
- (void)setData
{
    self.contentDetail = @"               \n\
            2006                            \n\
                                                                         \n\
           5000         10                                     \n\
                                                       \n\
                            \n\
                          12 5                                         \n\
            \n\
        13347131212 / 0471 4814631\n\
           \n\
        15704719988 / 0471 4814632\n\
               \n\
        13347131212\n\
                     \n\
       www.ttcy.com\n\
    Email  nmgttcy@163.com";
}

- (void)createContent
{
    self.scrolContent = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 510)];
    _scrolContent.backgroundColor = [UIColor clearColor];
    _scrolContent.showsHorizontalScrollIndicator = NO;
#warning 此处需要优化
    _scrolContent.contentSize = CGSizeMake(1101, 0);
//    [self loadSHLLabel];
    [self.view addSubview:_scrolContent];
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 1000, 450)];
    imageV.image = [UIImage imageNamed:@"about_company.png"];
    [_scrolContent addSubview:imageV];
}
- (void) loadSHLLabel {
    
    SHLUILabel * contentLab = [[SHLUILabel alloc] init];
    contentLab.text = _contentDetail;
    
    //设置字体颜色
    contentLab.textColor = [UIColor blackColor];
    contentLab.backgroundColor = [UIColor clearColor];
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    contentLab.numberOfLines = 0;
    contentLab.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    [contentLab font:[[NSBundle mainBundle] pathForResource:@"OyutamongbaitiM" ofType:@"ttf"] size:18.f];
    
    //根据字符串长度和Label显示的宽度计算出contentLab的高
    int labelHeight = [contentLab getAttributedStringHeightWidthValue:568];
    
    NSLog(@"SHLLabel height:%d", labelHeight);
    contentLab.frame = CGRectMake(0, 0, 1533, kMainScreenHeight-PlayBarHeight-40);

    [self.scrolContent addSubview:contentLab];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
