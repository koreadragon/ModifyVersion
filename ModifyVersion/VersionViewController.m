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
@property(nonatomic,strong)UILabel*versionLabel;
@property(nonatomic,strong)UISwitch*changeAddressSwitch;
@property(nonatomic,strong)UILabel*addressTipsLabel;
@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.addressTipsLabel.text = @"打开:本地服\n关闭:测试服";
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getSettingInfo];
    
}

-(void)switchAddress:(UISwitch*)sender{
    
    if (!sender.isOn) {//测试
        [[NSUserDefaults standardUserDefaults]setObject:@"http://121.199.35.77:8088" forKey:kVersionName];
    }else{//本地
        [[NSUserDefaults standardUserDefaults]setObject:@"http://192.168.1.66:8088" forKey:kVersionName];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self getSettingInfo];
    
    
}

-(void)getSettingInfo {
    
    //默认为本地服务器
    NSString*domain = [HGTools returnStr: @"http://192.168.1.66:8088" ifObjIsRealNull:[[NSUserDefaults standardUserDefaults] objectForKey:kVersionName]];
    
    if ([domain isEqualToString:@"http://192.168.1.66:8088"]) {
        self.changeAddressSwitch.on = YES;
    }else{
        self.changeAddressSwitch.on = NO;
    }
    
    NSString*url = [NSString stringWithFormat:@"%@/epbox_api/api/setting/findAll",domain];
    
    [self.activityView startAnimating];
    self.versionLabel.text = nil;
    [HGTools GET:url success:^(id response) {
 
         [_activityView stopAnimating];
        NSDictionary*dic = response[@"data"];
        NSArray*resultArray = dic[@"result"];
        
        NSMutableString *toDisplay = [NSMutableString string];
        for (NSDictionary*dic in resultArray) {
            NSString*key = dic[@"itemKey"];
            NSString*value = dic[@"itemValue"];
            if (![toDisplay isEqualToString:@""]) {
                [toDisplay appendString:@"\n"];
            }
            [toDisplay appendFormat: @"【%@】%@",key,value];
        }
        
        self.textView.text = toDisplay;
 
        
        
    } failure:^(NSURLSessionDataTask *Task, NSError *error) {
         [_activityView stopAnimating];
        self.textView.text = [NSString stringWithFormat:@"请求失败\n%@",error.localizedDescription];
        
    }];
}

-(UILabel *)addressTipsLabel{
    if (!_addressTipsLabel ) {
        _addressTipsLabel = [UILabel new];
        [self.view addSubview:_addressTipsLabel];
        _addressTipsLabel.textAlignment = NSTextAlignmentCenter;
        _addressTipsLabel.font = [UIFont systemFontOfSize:15.0];
        _addressTipsLabel.textColor = [UIColor lightGrayColor];
        _addressTipsLabel.numberOfLines = 0;
        [_addressTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(self.changeAddressSwitch);
            make.left.mas_equalTo(self.changeAddressSwitch);
            make.right.mas_equalTo(self.view);
            make.height.mas_equalTo(50);
            
        }];
        
        
    }
    
    return _addressTipsLabel;
}

-(UISwitch *)changeAddressSwitch{
    if (!_changeAddressSwitch) {
        _changeAddressSwitch = [UISwitch new];
        [self.view addSubview:_changeAddressSwitch];
 
        [_changeAddressSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(64);
            make.centerX.mas_equalTo(self.view);
        }];
        
        [_changeAddressSwitch addTarget:self action:@selector(switchAddress:) forControlEvents:UIControlEventValueChanged];
    }
    return _changeAddressSwitch;
}

-(UILabel *)versionLabel{
    if (!_versionLabel ) {
        _versionLabel = [UILabel new];
        [self.view addSubview:_versionLabel];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _versionLabel.numberOfLines = 0;
        [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view);
            make.height.mas_equalTo(100);
            
        }];
        
        
    }
    
    return _versionLabel;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.view addSubview:_textView];
        
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.selectable = YES;
        _textView.font = [UIFont systemFontOfSize:16.0];
        _textView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _textView.layer.cornerRadius = 5.0f;
        _textView.layer.masksToBounds = YES;
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view.mas_width);
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
            make.top.mas_equalTo(self.changeAddressSwitch.mas_bottom).with.offset(25);
            
        }];
    }
    
    return _textView;
}

-(UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        //activityView
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [self.versionLabel addSubview:_activityView];
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
