//
//  VscRouter.m
//  VscRouter
//
//  Created by tianyan on 2017/12/21.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "VscRouter.h"
#import <objc/runtime.h>
#import "NSObject+Property.h"

@interface VscRouter ()
@property (nonatomic,strong) NSMutableDictionary *routeDic;
@end

@implementation VscRouter
+(VscRouter *)shareRouter{
	static VscRouter *router = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		router = [[VscRouter alloc] init];
	});
	return router;
}
-(NSMutableDictionary *)routeDic{
	if (!_routeDic) {
		_routeDic = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	return _routeDic;
}
-(NSString *)scheme{
	if (!_scheme) {
		_scheme = @"native";
	}
	return _scheme;
}
-(void)setJsonResource:(NSString *)jsonResource{
	if (jsonResource.length == 0) {
		return;
	}
	_jsonResource = jsonResource;
	NSString *path = [[NSBundle mainBundle] pathForResource:jsonResource ofType:nil];
	NSData *data = [NSData dataWithContentsOfFile:path];
	id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
	[self addRouteWithObject:result];
}
-(void)setPlistResource:(NSString *)plistResource{
	if (plistResource.length == 0) {
		return;
	}
	_plistResource = plistResource;
	NSString *path = [[NSBundle mainBundle] pathForResource:plistResource ofType:nil];
	NSDictionary *tmpDic = [NSDictionary dictionaryWithContentsOfFile:path];
	[self addRouteWithObject:tmpDic];
}
-(void)addRouteWithObject:(id)objc{
	if ([objc isKindOfClass:[NSArray class]]) {
		NSArray *array = objc;
		for (id temp in array) {
			[self addRouteWithObject:temp];
		}
	}else if ([objc isKindOfClass:[NSDictionary class]]) {
		NSDictionary *dic = objc;
		for (NSString *key in dic.allKeys) {
			if (dic[key]) {
				Class routeClass = NSClassFromString(dic[key]);
				if (routeClass) {
					[self.routeDic setObject:routeClass forKey:key];
				}
			}
		}
	}
}
-(Class)classFromRoute:(NSString *)route{
	return self.routeDic[route];
}
-(BOOL)exsistClass:(Class)class{
	return class_isMetaClass(object_getClass(class));
}
-(NSString *)urlString:(NSString *)URLString parameters:(NSDictionary<NSString *,id> *)parameters{
	if (!parameters) {
		return URLString;
	}else{
		NSString *fragment;
		if ([URLString rangeOfString:@"#"].location != NSNotFound) {
			NSArray *partArray = [URLString componentsSeparatedByString:@"#"];
			URLString = partArray[0];
			fragment = partArray[1];
		}
		NSURL *checkURL = [NSURL URLWithString:URLString];
		NSMutableString *appString = URLString.mutableCopy;
		NSString *startStr = @"&";
		if (checkURL.query.length == 0) {
			startStr = @"?";
		}
		if (![appString hasSuffix:startStr]) {
			[appString appendString:startStr];
		}
		BOOL firstEnter = YES;
		for (NSString *key in parameters.allKeys) {
			if (!firstEnter) {
				[appString appendString:@"&"];
			}
			if ([parameters[key] isKindOfClass:[NSString class]]) {
				[appString appendFormat:@"%@=%@",key,parameters[key]];
			}
			firstEnter = NO;
		}
		if (fragment) {
			[appString appendFormat:@"#%@",fragment];
		}
		return appString.copy;
	}
}
-(void)registerObject:(NSString *)route class:(Class)objcClass{
	[self.routeDic setObject:objcClass forKey:route];
}
-(id)detect:(NSString *)route parameters:(NSDictionary *)dictionary{
	NSString *realRoute = route;
	if ([route rangeOfString:@"?"].location != NSNotFound) {
		realRoute = [route componentsSeparatedByString:@"?"][0];
		NSURL *tempURL = [NSURL URLWithString:route];
		NSString *queryStr = tempURL.query;
		if (queryStr) {
			NSMutableDictionary *muDic = dictionary.mutableCopy;
			NSArray *paras = [queryStr componentsSeparatedByString:@"&"];
			for (NSString *component in paras) {
				@autoreleasepool {
					NSArray *array = [component componentsSeparatedByString:@"="];
					if (array.count == 2 && ((NSString *)array[0]).length != 0) {
						[muDic setObject:array[1] forKey:array[0]];
					}
				}
			}
			dictionary = muDic.copy;
		}
	}
	Class objcClass = self.routeDic[realRoute];
	id object = [[objcClass alloc] init];
	if ([object respondsToSelector:@selector(setParameters:)]) {
		[object performSelector:@selector(setParameters:) withObject:dictionary];
	}
	[object propertyFromDictionary:dictionary checkSameType:self.checkPropertyType];
	return object;
}
-(void)detect:(NSString *)URLString parameters:(NSDictionary<NSString *,id> *)parameters propertyFill:(BOOL)property nativeResponse:(void (^)(NSArray <UIViewController *>*ctrlsArray))nativeHandler otherResponse:(void (^)(NSString *URLString))otherHandler{
	NSURL *handlerURL = [NSURL URLWithString:URLString];
	NSString *scheme = handlerURL.scheme;
	NSArray *ctrlsRoute = handlerURL.pathComponents;
	if (scheme && ![scheme isEqualToString:self.scheme]) {
		if (otherHandler) {
			NSString *urlStr = [self urlString:URLString parameters:parameters];
			otherHandler(urlStr);
		}
	}else{
		if (nativeHandler) {
			NSMutableArray <UIViewController *>*ctrlArray = [[NSMutableArray alloc] initWithCapacity:0];
			for (NSString *route in ctrlsRoute) {
				Class vcClass = [self classFromRoute:route];
				if ([self exsistClass:vcClass]) {
					[ctrlArray addObject:[[vcClass alloc] init]];
				}else{
					if (![route isEqualToString:@"/"]) {
						NSLog(@"[%@] Does Not Mean A UIViewController Class",route);
					}
				}
			}
			NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] initWithCapacity:0];
			if (parameters) {
				[paraDic setDictionary:parameters];
			}
			NSString *paraQuery = handlerURL.query;
			if (paraQuery) {
				NSArray *paras = [paraQuery componentsSeparatedByString:@"&"];
				for (NSString *component in paras) {
					@autoreleasepool {
						NSArray *array = [component componentsSeparatedByString:@"="];
						if (array.count == 2 && ((NSString *)array[0]).length != 0) {
							[paraDic setObject:array[1] forKey:array[0]];
						}
					}
				}
			}
			[[ctrlArray lastObject] setParameters:paraDic];
			if (property) {
				[[ctrlArray lastObject] propertyFromDictionary:paraDic checkSameType:self.checkPropertyType];
			}
			nativeHandler(ctrlArray.copy);
		}
	}
}

+(NSString *)urlString:(NSString *)URLString parameters:(NSDictionary<NSString *,id> *)parameters{
	return [[VscRouter shareRouter] urlString:URLString parameters:parameters];
}
+(void)registerObject:(NSString *)route class:(Class)objcClass{
	[[VscRouter shareRouter] registerObject:route class:objcClass];
}
+(id)detect:(NSString *)route parameters:(NSDictionary *)dictionary{
	return [[VscRouter shareRouter] detect:route parameters:dictionary];
}
+(void)detect:(NSString *)URLString parameters:(NSDictionary<NSString *,id> *)parameters propertyFill:(BOOL)property nativeResponse:(void (^)(NSArray<UIViewController *> *))nativeHandler otherResponse:(void (^)(NSString *))otherHandler{
	[[VscRouter shareRouter] detect:URLString parameters:parameters propertyFill:property nativeResponse:nativeHandler otherResponse:otherHandler];
}
@end
