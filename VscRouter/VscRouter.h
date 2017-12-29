//
//  VscRouter.h
//  VscRouter
//
//  Created by tianyan on 2017/12/21.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewController+Route.h"

typedef id(^RouteBlock)(NSDictionary *parameters);

@interface VscRouter : NSObject

/**
 可以不用传递,功能是判断scheme是否相同
 */
@property (nonatomic,copy) NSString *scheme;

/**
 以.json文件进行解析,获取所有注册过的路由
 */
@property (nonatomic,copy) NSString *jsonResource;

/**
 以.plist文件进行解析,获取所有注册过的路由
 */
@property (nonatomic,copy) NSString *plistResource;

/**
 默认是NO,如果改为YES,会判断KVC传值的时候 对象属性是否相同,如若不同会不进行传值
 */
@property (nonatomic,assign) BOOL checkPropertyType;


/**
 URLString的使用按照URL仿制
 下面几个方法的值传递,既可以使用Parameters字典,也可以使用URL中的parameters
 例:
 [scheme://] [/abc/bcd] ? userid = 123
 如此userid也会被传递到ViewCtroller的paramaters关联字典当中
 */
#pragma mark - 实例方法
/**
 Router的单例
 */
+(VscRouter *)shareRouter;

/**
 拼接URL的方法

 @param URLString 初始的URLString
 @param parameters parameters键值对(非NSString值会忽略)
 @return 生成全新的URLString
 */
-(NSString *)urlString:(NSString *)URLString parameters:(NSDictionary <NSString *,id> *)parameters;

/**
 注册一个对象的类到Route当中

 @param route route名
 @param objcClass route的类(建议反射生成)
 */
-(void)registerObject:(NSString *)route class:(Class)objcClass;

/**
 根据route生成相应对象

 @param route route名
 @param dictionary 对象的属性值,以字典形式直接复制
 @return Route对应生成的对象
 */
-(id)detect:(NSString *)route parameters:(NSDictionary *)dictionary;

/**
 方法可以生成viewcontroller数组,调用pushViewCtrollers方法可以完成多级页面的切换

 @param URLString 仿URL模式的本地调用URLString
 @param parameters 传递值的字典
 @param property 是否将字典中的值直接KVC到对象(ViewController)上
 @param nativeHandler 返回的控制器数组在Block当中
 @param otherHandler 并没有生成相应的控制器数组,将字典与URLString拼接成完整的urlStr
 */
-(void)detect:(NSString *)URLString parameters:(NSDictionary<NSString *,id> *)parameters propertyFill:(BOOL)property nativeResponse:(void (^)(NSArray <UIViewController *>*ctrlsArray))nativeHandler otherResponse:(void (^)(NSString *URLString))otherHandler;

#pragma mark - 类方法 内部为[VscRoute shareRoute] 调用,仅为方便使用
+(NSString *)urlString:(NSString *)URLString parameters:(NSDictionary <NSString *,id> *)parameters;
+(void)registerObject:(NSString *)route class:(Class)objcClass;
+(id)detect:(NSString *)route parameters:(NSDictionary *)dictionary ;
+(void)detect:(NSString *)URLString parameters:(NSDictionary<NSString *,id> *)parameters propertyFill:(BOOL)property nativeResponse:(void (^)(NSArray <UIViewController *>*ctrlsArray))nativeHandler otherResponse:(void (^)(NSString *URLString))otherHandler;

@end
