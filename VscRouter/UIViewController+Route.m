
//
//  UIViewController+Route.m
//  VscRouter
//
//  Created by tianyan on 2017/12/27.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "UIViewController+Route.h"
#import <objc/runtime.h>

static char kRouterParameters;
@implementation UIViewController (Router)
-(void)setParameters:(NSDictionary *)parameters{
	objc_setAssociatedObject(self, &kRouterParameters, parameters, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSDictionary *)parameters{
	return objc_getAssociatedObject(self, &kRouterParameters);
}
@end

@implementation UINavigationController (Router)
-(void)pushViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
	if (viewControllers.count > 1) {
		NSMutableArray *array = self.viewControllers.mutableCopy;
		[array addObjectsFromArray:[viewControllers subarrayWithRange:NSMakeRange(0, viewControllers.count - 1)]];
		self.viewControllers = array;
	}
	[[self.viewControllers lastObject].navigationController pushViewController:[viewControllers lastObject] animated:YES];
}
@end
