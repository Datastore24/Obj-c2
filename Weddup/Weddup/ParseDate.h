//
//  ParseDate.h
//  Weddup
//
//  Created by Кирилл Ковыршин on 08.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseDate : NSObject


- (NSString *)dateFormatToDay;
- (NSString *)dateFormatToYesterDay;
- (NSString *)dateFormatToDayBeforeYesterday;

@end
