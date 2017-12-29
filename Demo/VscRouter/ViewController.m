//
//  ViewController.m
//  VscRouter
//
//  Created by tianyan on 2017/12/21.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "ViewController.h"
#import "VscRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.
	[VscRouter shareRouter].jsonResource = @"Register.json";
//	[VscRouter shareRouter].plistResource = @"Register.plist";
	[VscRouter shareRouter].checkPropertyType = YES;
	
	CGFloat width = [UIScreen mainScreen].bounds.size.width;
	
	UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, width, 50)];
	[button1 addTarget:self action:@selector(clickEnter1) forControlEvents:64];
	[button1 setTitle:@"多层控制器创建" forState:0];
	[button1 setTitleColor:[UIColor redColor] forState:0];
	[self.view addSubview:button1];
	
	UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, width, 50)];
	[button2 addTarget:self action:@selector(clickEnter2) forControlEvents:64];
	[button2 setTitle:@"单层控制器创建|方式1" forState:0];
	[button2 setTitleColor:[UIColor redColor] forState:0];
	[self.view addSubview:button2];
	
	UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, width, 50)];
	[button3 addTarget:self action:@selector(clickEnter3) forControlEvents:64];
	[button3 setTitle:@"单层控制器创建|方式2" forState:0];
	[button3 setTitleColor:[UIColor redColor] forState:0];
	[self.view addSubview:button3];
	
	UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, width, 50)];
	[button4 addTarget:self action:@selector(clickEnter4) forControlEvents:64];
	[button4 setTitle:@"各种传值" forState:0];
	[button4 setTitleColor:[UIColor redColor] forState:0];
	[self.view addSubview:button4];
	
	[VscRouter registerObject:@"model" class:NSClassFromString(@"TestModel")];
}
-(void)clickEnter1{
	[[VscRouter shareRouter] detect:@"native://view1/view/view3?username=Visac#test" parameters:@{@"userid":@"116359398"} propertyFill:YES nativeResponse:^(NSArray<UIViewController *> *ctrlsArray) {
		[self.navigationController pushViewControllers:ctrlsArray animated:YES];
	} otherResponse:^(NSString *URLString) {
		NSLog(@"%@",URLString);
	}];
}
-(void)clickEnter2{
	[[VscRouter shareRouter] detect:@"view3?username=Visac#test" parameters:@{@"userid":@"116359398"} propertyFill:YES nativeResponse:^(NSArray<UIViewController *> *ctrlsArray) {
		[self.navigationController pushViewControllers:ctrlsArray animated:YES];
	} otherResponse:^(NSString *URLString) {
		NSLog(@"%@",URLString);
	}];
}
-(void)clickEnter3{
	UIViewController *viewCtrl = [VscRouter detect:@"view3?userid=116359398" parameters:@{@"username":@"Visac",@"unknown":@"nothing"} propertyFill:NO];
	[self.navigationController pushViewController:viewCtrl animated:YES];
}
-(void)clickEnter4{
	id model = [VscRouter detect:@"model" parameters:@{@"testStr":@"testModelPass"} propertyFill:YES];
	id block = ^(NSString *displayStr){
		NSLog(@"block pass value %@",displayStr);
	};
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
	[dic setObject:@"116359398" forKey:@"userid"];
	[dic setObject:@[@"testarray1",@"testarray2"] forKey:@"array"];
	[dic setObject:@[@"mutArray1",@"mutArray2"] forKey:@"mutArray"];
	[dic setObject:model forKey:@"model"];
	[dic setObject:[[UIImage alloc] init] forKey:@"image"];
	[dic setObject:@{@"testkey":@"testvalue"} forKey:@"dictionary"];
	[dic setObject:[NSNumber numberWithInt:5] forKey:@"myInt"];
	[dic setObject:@"1.41421" forKey:@"myFloat"];
	[dic setObject:@"3.1415926" forKey:@"myDouble"];
	[dic setObject:[NSValue valueWithCGRect:CGRectMake(1, 2, 3, 4)] forKey:@"myRect"];
	[dic setObject:block forKey:@"testBlock"];
	[[VscRouter shareRouter] detect:@"native://www.baidu.com/view2?username=Visac#test"  parameters:dic propertyFill:YES nativeResponse:^(NSArray<UIViewController *> *ctrlsArray) {
		[self.navigationController pushViewControllers:ctrlsArray animated:YES];
	} otherResponse:^(NSString *URLString) {
		NSLog(@"%@",URLString);
	}];
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
