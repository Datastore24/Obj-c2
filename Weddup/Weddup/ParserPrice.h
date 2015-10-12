//
//  ParserPrice.h
//  Weddup
//
//  Created by Кирилл Ковыршин on 11.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motis/Motis.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface ParserPrice : NSObject
//Данные из массива
@property (strong,nonatomic) NSString * price_name;
@property (strong,nonatomic) NSString * price_body;
@property (strong,nonatomic) NSString * min_price;
@property (strong,nonatomic) NSArray * price_properties;
@property (strong,nonatomic) NSArray * price_images;

@property (assign,nonatomic) CGFloat targetHeightText;


@end
