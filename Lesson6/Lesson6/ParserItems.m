//
//  ParserItems.m
//  Lesson6
//
//  Created by Кирилл Ковыршин on 01.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ParserItems.h"

@implementation ParserItems

+ (NSDictionary*)mts_mapping
{
    return @{@"count": mts_key(itemCount),
             @"name": mts_key(itemName),
             @"price": mts_key(itemPrice)
             };
}

- (void) parsing: (id) response andArray:(NSMutableArray*) arrayResponse andBlock:(void (^)(void)) block{
    
    if([response isKindOfClass:[NSDictionary class]]){
        NSDictionary * dict = (NSDictionary *) response;
        
        ParserItems * parse = [[ParserItems alloc] init];
        [parse mts_setValuesForKeysWithDictionary:dict];
    }else if([response isKindOfClass:[NSArray class]]){
        NSArray * array = (NSArray *) response;
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dict = (NSDictionary *) obj;
            ParserItems * parse = [[ParserItems alloc] init];
            [parse mts_setValuesForKeysWithDictionary:dict];
           
            [arrayResponse addObject:parse];
            if(idx == array.count - 1){
                block();
                
            }
        }];
        
        
        
    }
    
}

@end
