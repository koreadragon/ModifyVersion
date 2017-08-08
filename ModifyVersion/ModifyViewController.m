//
//  ModifyViewController.m
//  ModifyVersion
//
//  Created by koreadragon on 2017/8/4.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import "ModifyViewController.h"
static NSString*kVersionName = @"address";



@interface ModifyViewController ()

@property(nonatomic,strong)UITextView*textView;
@property(nonatomic,strong)UITextField*type;
@property(nonatomic,strong)UIButton*submitButton;
@property(nonatomic,strong)UIButton*selectButton;

@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.submitButton setTitle:@"修 改" forState:UIControlStateNormal];
    self.textView.textAlignment = NSTextAlignmentCenter;
    [self.selectButton setTitle:@"字段名" forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}



-(void)submitVersion:(UIButton*)sender{
    NSString*domain = [HGTools returnStr: @"http://192.168.1.66:8088" ifObjIsRealNull:[[NSUserDefaults standardUserDefaults] objectForKey:kVersionName]];
    NSString*url = [NSString stringWithFormat:@"%@/epbox_api/api/setting/confirm?key=%@&value=%@",domain,self.type.text,self.textView.text];
    [SVProgressHUD show];
    
    
    [self.view endEditing:YES];
    [HGTools POST:url params:nil success:^(id response) {
        [SVProgressHUD dismiss];
        [self alertMessage:@"修改成功"];
        
    } failure:^(NSURLSessionDataTask *Task, NSError *error) {
        
        [SVProgressHUD dismiss];
       
        [self alertMessage:error.localizedDescription];
        
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)alertMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"👌" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:sure];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)selectType:(UIButton*)button{
    
    NSUserDefaults* _def = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary*obj = [_def objectForKey:@"originDic"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择需要修改的类型" message:nil
                                                            preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    for (NSString*name in obj.allKeys) {
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.type.text = name;
            self.textView.text = [obj objectForKey:name];
        }];
        [alert addAction:sure];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
   
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    

    
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_submitButton];
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(45);
            make.width.mas_equalTo(self.view).with.offset(-20);
            make.centerX.mas_equalTo(self.view);
//            make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-30);
            
        }];
        [_submitButton setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        _submitButton.backgroundColor = YJ;
        _submitButton.layer.cornerRadius = 5.0;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_submitButton addTarget:self action:@selector(submitVersion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
    
}


-(UITextField *)type{
    if (!_type) {
        _type = [UITextField new];
        _type.placeholder = @"类型,如：codeType或者version";
        [self.view addSubview:_type];
        _type.borderStyle = UITextBorderStyleRoundedRect;
        _type.textAlignment = NSTextAlignmentCenter;
        
        _type.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_type mas_makeConstraints:^(MASConstraintMaker *make) {
            
//            make.centerX.mas_equalTo(self.view);
//            make.width.mas_equalTo(self.view.mas_width).with.multipliedBy(0.8);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(34);
            make.left.mas_equalTo(self.view).with.offset(10);
            make.right.mas_equalTo(self.selectButton.mas_left).with.offset(-10);
            make.width.mas_equalTo(self.selectButton.mas_width).multipliedBy(4.0);
            
        }];
    }
    
    return _type;
}

-(UIButton *)selectButton{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_selectButton];
        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(self.view).with.offset(-10);
            make.centerY.mas_equalTo(self.type.mas_centerY);
            make.height.mas_equalTo(self.type.mas_height).multipliedBy(0.5);
        }];
        [_selectButton setTitleColor:YJ forState:UIControlStateNormal];
//        [_selectButton setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
//        [_selectButton setBackgroundImage:[self imageWithColor:YJ] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectButton;
}


-(UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.view addSubview:_textView];
        
//        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.editable = YES;
        _textView.selectable = YES;
        _textView.layer.cornerRadius = 5.0f;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderWidth = 1.0f;
        _textView.font = [UIFont systemFontOfSize:16.0];
        _textView.layer.borderColor = [UIColor blackColor].CGColor;
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view.mas_width).with.offset(-20);
            make.bottom.mas_equalTo(self.submitButton.mas_top).with.offset(-40);
            make.top.mas_equalTo(self.type.mas_bottom).with.offset(25);
            make.height.mas_equalTo(200);
            
        }];
    }
    
    return _textView;
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
