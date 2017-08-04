//
//  TabViewController.m
//  ModifyVersion
//
//  Created by koreadragon on 2017/8/4.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //当前版本
    VersionViewController*versionVC = [VersionViewController new];
    UIImage*version = [UIImage imageNamed:@"version"];
    version = [version imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIImage*unVersion = [UIImage imageNamed:@"unVersion"];
    unVersion = [unVersion imageWithRenderingMode:UIImageRenderingModeAutomatic];
    versionVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"当前信息" image:unVersion selectedImage:version];
 
    //修改版本
    ModifyViewController*modifyVC = [ModifyViewController new];
    UIImage*modify = [UIImage imageNamed:@"modify"];
    modify = [modify imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIImage*unModify = [UIImage imageNamed:@"unModify"];
    unModify = [unModify imageWithRenderingMode:UIImageRenderingModeAutomatic];
    modifyVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"开始修改" image:unModify selectedImage:modify];
    
    
    
    self.viewControllers = @[versionVC,
                             modifyVC
                             ];
    
    self.tabBar.tintColor = [UIColor blackColor];
    
     
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
