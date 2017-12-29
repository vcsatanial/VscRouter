//
//  TwoViewCtrl.m
//  VscRouter
//
//  Created by tianyan on 2017/12/26.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TwoViewCtrl.h"

@interface TwoViewCtrl ()

@end

@implementation TwoViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.title = @"Two";
	self.view.backgroundColor = [UIColor yellowColor];
	
	NSLog(@"array = %@",self.array);
	NSLog(@"dictionary = %@",self.dictionary);
	NSLog(@"mutArray = %@",self.mutArray);
	NSLog(@"model = %@",self.model);
	NSLog(@"image = %@",self.image);
	NSLog(@"myInt = %d",self.myInt);
	NSLog(@"myDouble = %lf",self.myDouble);
	NSLog(@"myFloat = %f",self.myFloat);
	NSLog(@"myRect = %@",NSStringFromCGRect(self.myRect));
	NSLog(@"\n");
	[self performSelector:@selector(performBlock) withObject:nil afterDelay:2];
}
-(void)performBlock{
	self.testBlock(@"test block back");
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
@implementation TestModel
-(NSString *)description{
	return [NSString stringWithFormat:@"%@ %@",NSStringFromClass([self class]),self.testStr];
}
@end
