//
//  UIViewController+Route.h
//  VscRouter
//
//  Created by tianyan on 2017/12/27.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Route)
@property (nonatomic,copy) NSDictionary *parameters;
@end

@interface UINavigationController (Router)
-(void)pushViewControllers:(NSArray <UIViewController *>*)viewControllers animated:(BOOL)animated;
@end
