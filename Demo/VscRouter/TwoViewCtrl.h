//
//  TwoViewCtrl.h
//  VscRouter
//
//  Created by tianyan on 2017/12/26.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TestModel;
@interface TwoViewCtrl : UIViewController
@property (nonatomic,copy) NSArray *array;
@property (nonatomic,copy) NSDictionary *dictionary;
@property (nonatomic,strong) NSMutableArray *mutArray;
@property (nonatomic,strong) TestModel *model;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign) int myInt;
@property (nonatomic,assign) double myDouble;
@property (nonatomic,assign) float myFloat;
@property (nonatomic,assign) CGRect myRect;
@property (nonatomic,copy) void (^testBlock)(NSString *displayStr);
@end

@interface TestModel : NSObject
@property (nonatomic,copy) NSString *testStr;
@end
