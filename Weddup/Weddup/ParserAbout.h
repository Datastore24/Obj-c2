//
//  ParserAbout.h
//  Weddup
//
//  Created by Кирилл Ковыршин on 10.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motis/Motis.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface ParserAbout : NSObject


@property (strong,nonatomic) NSString * about_me;
@property (strong,nonatomic) NSDictionary * about_general_photo;

@property (assign,nonatomic) CGFloat targetHeightText;
@property (assign,nonatomic) CGFloat targetHeightImage;

@end
