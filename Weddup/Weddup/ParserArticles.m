//
//  Parser.m
//  Lesson6
//
//  Created by Кирилл Ковыршин on 01.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ParserArticles.h"


@implementation ParserArticles
//Метод парсинга
+ (NSDictionary *)mts_mapping {
  return @{
    @"article_date" : mts_key(article_date),
    @"article_name" : mts_key(article_name),
    @"article_annotation" : mts_key(article_annotation),
    @"article_text" : mts_key(article_text),
    @"id" : mts_key(article_id),
    @"atricle_count" : mts_key(article_count)
    
  };
}


@end
