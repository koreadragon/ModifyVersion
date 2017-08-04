//
//  HGTools.h
//  EasyReading
//
//  Created by koreadragon on 16/5/31.
//  Copyright © 2016年 koreadragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <CoreText/CoreText.h>
#import <netinet/in.h>
#import <AudioToolbox/AudioToolbox.h>
@interface HGTools : NSObject

{
    SystemSoundID soundID;
}
/**
 *  带进度的post
 *
 *  @param URL     请求网址
 *  @param params  请求参数
 *  @param success 请求结果
 *  @param Error   报错信息
 */
+(void)POSTWithProgressURL:(NSString *)URL params:(NSDictionary *)params progress:(void(^)(NSProgress * progress)) progress success:(void (^)(id response))success failure:(void (^)(NSURLSessionDataTask * Task, NSError * error))Error;
/**
 *  判断当前网络是否可用
 *
 *  @return 布尔返回值
 */
+ (BOOL)connectedToNetwork;

/**
 *  自定义post 请求
 *
 *  @param URL     请求网址
 *  @param params  请求参数
 *  @param success 请求结果
 *  @param Error   报错信息
 */
+ (void)POST:(NSString *)URL params:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSURLSessionDataTask *Task,NSError *error))Error;
/**
 *  自定义get请求
 *
 *  @param URL     请求地址
 *  @param success 返回结果
 *  @param Error   报错信息
 */
+(void)GET:(NSString *)URL
   success:(void(^)(id response)) success
   failure:(void (^)(NSURLSessionDataTask *Task,NSError *error)) Error;

/**
 *  上传照片
 *
 *  @param URL     请求地址
 *  @param params  请求参数
 *  @param image   照片
 *  @param success 返回结果
 *  @param Error   报错信息
 */
//+(void)UPLOADIMAGE:(NSString *)URL
//            params:(NSDictionary *)params
//       uploadImage:(UIImage *)image
//           success:(void (^)(id response))success
//           failure:(void (^)(NSURLSessionDataTask *Task,NSError *error))Error;

/**
 *  上传带图片的内容，允许多张图片上传（URL）POST
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameter           图片数组对应的参数
 *  @param parameters          其他参数字典
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */

+ (void)UploadMultiPartUploadTaskWithURL:(NSString *)url
                            imagesArray:(NSArray *)images
                      parameterOfimages:(NSString *)parameter
                         parametersDict:(NSDictionary *)parameters
                           succeedBlock:(void(^)(id task, id responseObject))succeedBlock
                            failedBlock:(void(^)(id task, NSError *error))failedBlock
                    uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock;


/**
 黑色小弹窗

 @param message 要弹得信息
 */
+ (void)showMessage:(NSString *)message;
/**
 *  将照片裁切后返回NSData数据
 *
 *  @param sourceImage  源照片
 *  @param maxImageSize 照片尺寸
 *  @param maxSize      照片大小
 *
 *  @return 返回NSData照片数据
 */
+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;

/**
 *  弹出警示窗
 *
 *  @param title      标题
 *  @param message    信息内容
 *  @param controller controller
 */
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)controller;
/**
 *  弹窗后自动消失
 *
 *  @param time           显示时长
 *  @param title          内容
 *  @param viewController controller
 */
+(void)alertWithTimeInterval:(NSInteger)time title:(NSString *)title byVC:(id)viewController;
/**
 *  为字符串添加删除线
 *
 *  @param string 源字符串
 *
 *  @return 返回的NSAttributedString字符串
 */
+ (NSAttributedString *)addDeleteLineWithString:(NSString *)string;
/**
 *  判断是否是纯数字
 *
 *  @param string 待判断字符串
 *
 *  @return 返回yes为真，no为假
 */
+ (BOOL)isPureNumandCharacters:(NSString *)string;
/**
 *  遮挡手机中间四位为****
 *
 *  @param phoneStr 待遮挡字符串
 *
 *  @return 已遮挡的字符串
 */
+ (NSString *)coverPhoneNumWithFourStars:(NSString *)phoneStr;


/**
 返回适应文字的rect

 @param string 需要适应的字符串
 @param fontSize 字体
 @param cgSize 待适应区域
 @return 返回CGRect类型结果
 */
+(CGRect)fittingRectWithString:(NSString *)string
                      fontSize:(CGFloat)fontSize
                        CGSize:(CGSize)cgSize;
/**
 *  返回文字两端对齐的NSMutableAttributedString
 *
 *  @param string label字符
 *  @param size   字符font
 *
 *  @return 返回NSMutableAttributedString
 */
+(NSMutableAttributedString *)aligmentLeftAndRight:(NSString *)string
                                              size:(CGFloat)size
                                            cgrect:(CGRect)rect;




/**
 *  返回汉字的首字母(大写)
 *
 *  @param string 源string
 *
 *  @return 返回的大写字母
 */
+(NSString *)returnFirstLetter:(NSString *)string;




/**
 返回排序的首字母数组

 @param array 待排数组
 @return 返回的首字母数组
 */
+(NSArray *)orderedLetterArray:(NSArray <NSString *> *)array;

/**
 *  返回ABCD字典
 *
 *  @param array 待分组的字符串数组
 *
 *  @return 返回已分组的字符串数组
 */
+(NSDictionary *)orderDictionary:(NSArray <NSString *> *)array;
/**
 *  返回排序的字典和数组，@{@"ABCIndex":Array,@"ABCDic":Dic}
 *
 *  @param array 待排序字符串数组
 *
 *  @return 返回排好的字典与键值array
 */
+(NSDictionary *)orderedIndexAndDictionary:(NSArray <NSString *> *)array;




/**
 是否是字母

 @param testString 待检测字母
 @return 是否是字母的bool值
 */
+(BOOL)isAaToZz:(NSString *)testString;
/**
 *  用户是否有登录
 *
 *  @return  buer
 */
+(BOOL)isLogin;
/**
 *  按照提供的key排序包含字典的数组并返回字典数组
 *
 *  @param muArray 待排序的数组
 *  @param key     该数组包含的字典中需要排序的value对应的key值
 */
+(NSMutableArray *)sortArrayContainDic:(NSMutableArray *)muArray
                    withKey:(NSString *)key;

/**
 *  将包含数组的字典按照指定key排序
 *
 *  @param muArray 待排数组
 *  @param key     key
 */
+(void)sortArray:(NSMutableArray *)muArray
         WithKey:(NSString *)key;
/**
 *  真正空
 *
 *  @param obj 待检测对象
 *
 *  @return bool
 */
+(BOOL)isRealNull:(id)obj;


/**
 *  如果对象（一般为字符串为各种空时）返回指定字符串
 *
 *  @param string 指定返回格式的字符串
 *  @param obj    待检测对象
 *
 *  @return 返回值
 */
+(NSString *)returnStr:(NSString *)string
       ifObjIsRealNull:(id)obj;


/**
 *  给前者字符串添加下划线
 *
 *  @param string1 前者
 *  @param string2 后者
 *
 *  @return 处理过的string
 */
+(NSMutableAttributedString *)addUnderlineToForeString:(NSString *)string1
                                               string2:(NSString *)string2;


/**
 *  将对象转换成字符串
 *
 *  @param value 待转换
 *
 *  @return 字符串
 */
+(NSString *)returnStringNoMatterWhatYouR:(NSObject *)value;

/**
 *  获取苹果设备具体型号
 *
 *
 *  @return 设备名称，如 "iPhone6s"
 */

+ (NSString *)getDeviceInfo;
/*
 *  获取设备内存
 */

+ (NSString *)getDeviceFlash;


/*
 *  判断手机号是否合法
 */
//+(BOOL)isCorrectPhoneNumber:(NSString *)phone;
/**
 *  用户登录
 *
 *
 */
+(void)login:(NSDictionary *)dic;

/**
 *  用户退出
 *
 *
 */
+(void)signOut;


/**
 *  获取用户信息
 *
 *
 */

+(NSDictionary *)getUserInfo;

/**获取6位验证码
 *
 */
+(NSString *)getUserToken;


/**
 获取32位token

 @return token
 */
+(NSString *)getToken;



/**
 判断是不是银行卡

 @param cardNumber 待检测银行卡
 @return bool值
 */
+(BOOL)IsBankCard:(NSString *)cardNumber;



/**
 判断是不是手机号

 @param number 待检测手机号
 @return bool值
 */
+(BOOL)IsPhoneNumber:(NSString *)number;

/**
 匹配固定位数的数字

 @param string 待匹配数字
 @param count 需要限制的位数
 @return 判断的布尔值
 */
+(BOOL)matchNumber:(NSString *)string withCount:(NSInteger)count;
/**
 判断是不是身份证号

 @param IDCardNumber 待检测身份证
 @return bool值
 */
+(BOOL)IsIdentityCard:(NSString *)IDCardNumber;


/**
 计算缓存

 @return 缓存数据
 */
+(float)calculateFolderSizeAtPath;


/**
 清除缓存
 */
+(void)clearCache;

/**
 获取当前viewController

 @return 控制器
 */
+ (UIViewController *)getCurrentVC;


/**
 通过字符串生成二维码
 
 @param qrString 用来生成二维码的字符串
 @param size 目标二维码大小
 @return 生成的二维码
 */
+ (UIImage *)QRImageWithString:(NSString *)qrString withSize:(CGFloat) size;


/**
 改变二维码颜色,并且透明
 
 @param image 待传图片
 @param red 红色
 @param green 绿色
 @param blue 蓝色
 @return 修改过的彩照
 */
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

/**
 播放声音文件
 
 @param soundName 声音文件名
 */
+(void)playSoundWithName:(NSString *)soundName;
/**
 初始化声音
 
 @param filename 声音名称
 @return self
 */
-(id)initForPlayingSoundEffectWith:(NSString *)filename;


/**
 播放声音
 
 */
-(void)play;

 
/**
 弹出提示框，带block

 @param title 标题
 @param messa 内容详情
 @param sure 确认block
 @param sureText 确认按钮文字
 @param cancelTitle 取消按钮文字
 */
+(void)alertTitle:(NSString*)title message:(NSString*)messa sure:(void (^)(id action))sure sureText:(NSString*)sureText cancelText:(NSString*)cancelTitle;




/**
 角标减1
 */
+(void)badge_minus;











@end
