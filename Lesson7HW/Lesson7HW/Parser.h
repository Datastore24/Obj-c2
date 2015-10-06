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

@interface Parser : NSObject

//Данные из массива
@property (strong,nonatomic) NSString * text;
@property (strong,nonatomic) NSString * fullText;
@property (strong,nonatomic) NSURL * src_big;
@property (assign,nonatomic) CGFloat width;
@property (assign,nonatomic) CGFloat height;
@property (assign,nonatomic) CGFloat targetHeight;
@property (assign,nonatomic) NSInteger countTextArray;






@end
