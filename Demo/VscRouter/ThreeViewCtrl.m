//
//  ThreeViewCtrl.m
//  VscRouter
//
//  Created by tianyan on 2017/12/26.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "ThreeViewCtrl.h"
#import "VscRouter.h"

@interface ThreeViewCtrl ()

@end

@implementation ThreeViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.title = @"Three";
	self.view.backgroundColor = [UIColor blueColor];
	NSLog(@"userid = %@",self.userid);
	NSLog(@"username = %@",self.username);
	NSLog(@"\n");
}
-(void)setParameters:(NSDictionary *)parameters{
	[super setParameters:parameters];
	NSLog(@"%@",parameters);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
