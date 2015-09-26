//
//  ClassWithBlock.h
//  LessonII-5
//
//  Created by Кирилл Ковыршин on 25.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassWithBlock : NSObject

+ (void) getArrayWithComplitionBlock: (NSString *) str string: (NSString *) strTwo block:(void (^) (NSMutableArray * array)) complitionBlock;

@end
