//
//  NSObject+Property.m
//  VscRouter
//
//  Created by tianyan on 2017/12/28.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>


BOOL charsIsEquil(const char *_char1,const char *_char2){
	if (strcmp(_char1, _char2) == 0) {
		return YES;
	}else{
		return NO;
	}
}
@implementation NSObject (Property)
-(void)propertyFromDictionary:(NSDictionary *)dictionary checkSameType:(BOOL)checkType{
	if (!dictionary || dictionary.allKeys.count == 0) {
		return;
	}
	unsigned int count;
	objc_property_t *properties = class_copyPropertyList([self class], &count);
	for (int index = 0; index < count ; index ++) {
		objc_property_t property = properties[index];
		NSString *propertyName = @(property_getName(property));
		if ([dictionary.allKeys containsObject:propertyName]) {
			if (checkType) {
				unsigned int attributesCount ;
				objc_property_attribute_t *attributes = property_copyAttributeList(property, &attributesCount);
				for (int index = 0; index < attributesCount; index ++) {
					objc_property_attribute_t attribute = attributes[index];
					if (charsIsEquil(attribute.name, "T")) {
						NSString *valueStr = [NSString stringWithUTF8String:attribute.value];
						if ([valueStr rangeOfString:@"@\""].location != NSNotFound) {
							valueStr = [valueStr stringByReplacingOccurrencesOfString:@"@\"" withString:@""];
							valueStr = [valueStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
							if ([dictionary[propertyName] isKindOfClass:NSClassFromString(valueStr)]) {
								[self setValue:dictionary[propertyName] forKey:propertyName];
							}else{
								if ([dictionary[propertyName] respondsToSelector:@selector(mutableCopy)]) {
									if ([[dictionary[propertyName] mutableCopy] isKindOfClass:NSClassFromString(valueStr)]) {
										[self setValue:[dictionary[propertyName] mutableCopy] forKey:propertyName];
									}else{
										NSLog(@"%@ Can Not Become A Property,Because They Have Different Type",dictionary[propertyName]);
									}
								}
							}
						}else{
							id value = dictionary[propertyName];
							if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSValue class]]) {
								[self setValue:value forKey:propertyName];
							}else{
								id myValue;
								if (charsIsEquil(attribute.value, "i")) {
									myValue = [NSNumber numberWithInt:[value intValue]];
								}else if (charsIsEquil(attribute.value, "q")) {
									myValue = [NSNumber numberWithInteger:[value integerValue]];
								}else if (charsIsEquil(attribute.value, "d")) {
									myValue = [NSNumber numberWithDouble:[value doubleValue]];
								}else if (charsIsEquil(attribute.value, "f")) {
									myValue = [NSNumber numberWithFloat:[value floatValue]];
								}else if (charsIsEquil(attribute.value, "*")) {
									myValue = [NSNumber numberWithChar:[value charValue]];
								}else if (charsIsEquil(attribute.value, "B")) {
									myValue = [NSNumber numberWithBool:[value boolValue]];
								}else if (charsIsEquil(attribute.value, "@?")) {
									myValue = [value copy];
								}else{
									NSLog(@"%@ Can Not Become A Property,Because They Have Different Type",value);
								}
								if (myValue) {
									[self setValue:myValue forKey:propertyName];
								}
							}
						}
						break;
					}
				}
			}else{
				[self setValue:dictionary[propertyName] forKey:propertyName];
			}
		}
	}
}
@end
