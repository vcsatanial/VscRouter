//
//  NSObject+Property.h
//  VscRouter
//
//  Created by tianyan on 2017/12/28.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)
-(void)propertyFromDictionary:(NSDictionary *)dictionary checkSameType:(BOOL)checkType;
@end
