//
//  Parser.m
//  Lesson6
//
//  Created by Кирилл Ковыршин on 01.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "Parser.h"


@implementation Parser
//Метод парсинга
+ (NSDictionary *)mts_mapping {
  return @{
    @"text" : mts_key(text),
    @"attachment.photo.src_big" : mts_key(src_big),
    @"attachment.photo.width" : mts_key(width),
    @"attachment.photo.height" : mts_key(height),
    @"attachment.photo.text" : mts_key(photoText)
  };
}


@end
