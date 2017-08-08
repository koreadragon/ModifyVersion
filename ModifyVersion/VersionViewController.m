//
//  VersionViewController.m
//  ModifyVersion
//
//  Created by koreadragon on 2017/8/4.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import "VersionViewController.h"


static NSString*kVersionName = @"address";


@interface VersionViewController ()
@property(nonatomic,strong)UIActivityIndicatorView *activityView;
@property(nonatomic,strong)UITextView*textView;
@property(nonatomic,strong)UISegmentedControl*seg;
@property(nonatomic,strong)UIToolbar*toolBar;
@property(nonatomic,strong)NSUserDefaults*def;
@property(nonatomic,copy)NSMutableString*domain;
//@property(nonatomic,strong)*<#detail#>;
@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
 
    self.seg.backgroundColor = [UIColor whiteColor];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateSeg];
    [self getSettingInfo];
    
}

-(NSUserDefaults *)def{
    if (!_def) {
        _def = [NSUserDefaults standardUserDefaults];
        
    }
    return _def;
}
-(void)updateSeg{
    if ([self.domain isEqualToString:@"http://192.168.1.66:8088"]) {
        self.seg.selectedSegmentIndex = 0;
        return;
    }
    if ([self.domain isEqualToString:@"http://121.199.35.77:8088"]) {
        self.seg.selectedSegmentIndex = 1;
        return;
    }
    if ([self.domain isEqualToString:@"http://api.epbox.cn"]) {
        self.seg.selectedSegmentIndex = 2;
        return;
    }
}

-(void)changeSeg:(UISegmentedControl *)seg{
    
    NSInteger sele = seg.selectedSegmentIndex;
    
    
    
    if (sele == 0) {
        [self.def setObject:@"http://192.168.1.66:8088" forKey:kVersionName];
        
    }
    if (sele == 1) {
        [self.def setObject:@"http://121.199.35.77:8088" forKey:kVersionName];
        
    }
    if (sele == 2) {
        [self.def setObject:@"http://api.epbox.cn" forKey:kVersionName];
        
    }
    
    [self getSettingInfo];
    
}
-(NSMutableString *)domain{
    if (!_domain) {
        //默认为本地服务器
        _domain = [HGTools returnStr: @"http://192.168.1.66:8088" ifObjIsRealNull:[self.def objectForKey:kVersionName]].mutableCopy;
    }
    
    return _domain;
}

-(void)getSettingInfo {
    
    self.domain = [self.def objectForKey:kVersionName];
 
    NSString*url = [NSString stringWithFormat:@"%@/epbox_api/api/setting/findAll",self.domain];
    
    [self.activityView startAnimating];
    self.textView.text = nil;
    [HGTools GET:url success:^(id response) {
 
         [_activityView stopAnimating];
        NSDictionary*dic = response[@"data"];
        NSArray*resultArray = dic[@"result"];
        
        NSMutableDictionary*originMuDic = [NSMutableDictionary new];
        
        NSMutableString *toDisplay = [NSMutableString string];
        for (NSDictionary*dic in resultArray) {
            NSString*key = dic[@"itemKey"];
            NSString*value = dic[@"itemValue"];
            [originMuDic setObject:value forKey:key];
            if (![toDisplay isEqualToString:@""]) {
                [toDisplay appendString:@"\n"];
            }
            [toDisplay appendFormat: @"【%@】%@",key,value];
        }
        
        [self.def setObject:originMuDic forKey:@"originDic"];
        
        self.textView.text = toDisplay;
 
        
        
    } failure:^(NSURLSessionDataTask *Task, NSError *error) {
         [_activityView stopAnimating];
        self.textView.text = [NSString stringWithFormat:@"请求失败\n%@",error.localizedDescription];
        
    }];
}


-(UIToolbar *)toolBar{
    if (!_toolBar) {
        _toolBar = [UIToolbar new];
        UIBarButtonItem*refresh = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getSettingInfo)];
        UIBarButtonItem*space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [self.view addSubview:_toolBar];
        [_toolBar setItems:@[space,refresh,space]];
        _toolBar.backgroundColor = [UIColor clearColor];
        [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view);
            make.height.mas_equalTo(64);
        }];
    }
    
    return _toolBar;
}

-(UISegmentedControl *)seg{
    if (!_seg) {
        _seg = [[UISegmentedControl alloc]initWithItems:@[@"本地",@"测试",@"正式"]];
        [self.view addSubview:_seg];
        [_seg setTintColor:YJ];
        [_seg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.width.mas_equalTo(self.view).multipliedBy(0.8);
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(self.toolBar.mas_bottom).with.offset(0);
            make.height.mas_equalTo(45);
            
        }];
        _seg.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        
        [_seg addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
        
        
    }
    
    return _seg;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.view addSubview:_textView];
        
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = NO;
        _textView.selectable = YES;
        _textView.font = [UIFont systemFontOfSize:16.0];
        _textView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _textView.layer.cornerRadius = 5.0f;
        _textView.layer.masksToBounds = YES;
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view.mas_width);
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
            make.top.mas_equalTo(self.seg.mas_bottom).with.offset(10);
            
        }];
    }
    
    return _textView;
}

-(UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        //activityView
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [self.textView addSubview:_activityView];
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.mas_equalTo(self.textView);
            
        }];
    }
    return _activityView;
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
