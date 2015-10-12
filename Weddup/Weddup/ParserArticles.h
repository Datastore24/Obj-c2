//
//  Parser.h
//  Lesson6
//
//  Created by Кирилл Ковыршин on 01.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motis/Motis.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface ParserArticles : NSObject

//Данные из массива
@property (strong,nonatomic) NSString * article_annotation;
@property (strong,nonatomic) NSString * article_date;
@property (strong,nonatomic) NSString * article_name;
@property (strong,nonatomic) NSString * article_text;
@property (strong,nonatomic) NSString * article_id;
@property (strong,nonatomic) NSString * article_count;


@property (strong,nonatomic) NSArray * article_full_text;
@property (strong,nonatomic) NSMutableArray * article_array_photo;
@property (strong,nonatomic) NSURL * article_general_photo;
@property (assign,nonatomic) CGFloat targetHeightText;
@property (assign,nonatomic) CGFloat targetHeightImage;
@property (assign,nonatomic) NSInteger countTextArray;






@end
