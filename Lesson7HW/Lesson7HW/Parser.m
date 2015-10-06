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
+ (NSDictionary*)mts_mapping
{
    return @{@"date": mts_key(orderDate),
             @"address": mts_key(address),
             @"comment": mts_key(comment),
             @"customer_name": mts_key(customer_name),
             @"phone1": mts_key(phone1),
             @"discount": mts_key(discount),
             @"external_id": mts_key(external_id),
             @"summ": mts_key(orderSum),  // <-- KeyPath access
             };
}


//Метод обрабатывающий ответ сервера
- (void) parsing: (id) response andArray:(NSMutableArray*) arrayResponse andBlock:(void (^)(void)) block{
    
    //Если коллекция
    if([response isKindOfClass:[NSDictionary class]]){
        NSDictionary * dict = (NSDictionary *) response;
        
        Parser * parse = [[Parser alloc] init];
        [parse mts_setValuesForKeysWithDictionary:dict];
        
        //Если массив, внутри которого коллекции
    }else if([response isKindOfClass:[NSArray class]]){
        NSArray * array = (NSArray *) response;
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dict = (NSDictionary *) obj;
            Parser * parse = [[Parser alloc] init];
            [parse mts_setValuesForKeysWithDictionary:dict];
            
            [arrayResponse addObject:parse];
            if(idx == array.count - 1){
                block();
                
            }
        }];
        
        
        
    }
    
}

@end
