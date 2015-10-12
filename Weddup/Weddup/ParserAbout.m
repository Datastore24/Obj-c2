//
//  ParserAbout.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 10.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ParserAbout.h"

@implementation ParserAbout
//Метод парсинга
+ (NSDictionary *)mts_mapping {
    return @{
             @"about_me" : mts_key(about_me),
             
             };
}
@end
