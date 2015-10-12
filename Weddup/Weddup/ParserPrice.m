//
//  ParserPrice.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 11.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ParserPrice.h"

@implementation ParserPrice
//Метод парсинга
+ (NSDictionary *)mts_mapping {
    return @{
             @"name" : mts_key(price_name),
             @"body" : mts_key(price_body),
             @"properties" : mts_key(price_properties),
             @"images" : mts_key(price_images),
             @"min_price" : mts_key(min_price)
             
             };
}

@end
