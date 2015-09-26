//
//  ClassWithBlock.m
//  LessonII-5
//
//  Created by Кирилл Ковыршин on 25.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ClassWithBlock.h"

@implementation ClassWithBlock

+ (void) getArrayWithComplitionBlock: (NSString *) str string: (NSString *) strTwo block:(void (^) (NSMutableArray * array)) complitionBlock{

    NSMutableArray * array = [NSMutableArray array];
    [array addObject:str];
    [array addObject:strTwo];
    complitionBlock(array);
}



@end
