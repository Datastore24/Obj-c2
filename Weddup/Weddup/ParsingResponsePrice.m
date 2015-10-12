//
//  ParsingResponsePrice.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 12.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ParsingResponsePrice.h"
#import "TextAndImageHeight.h"
#import "UIImage+Resize.h"
#import "ParserPrice.h"
#import "ParserMethod.h"

@implementation ParsingResponsePrice
- (void)parsing:(id)response
       andArray:(NSMutableArray *)arrayResponse
        andView:(UIView *)view
       andBlock:(void (^)(void))block {
    ParserMethod * parserMethod = [[ParserMethod alloc] init];
    //Если это обновление удаляем все объекты из массива и грузим заного
    
    //
    
    if ([response isKindOfClass:[NSArray class]]) {
        NSArray *resonse = (NSArray *)response;
        
        TextAndImageHeight *textAndImageHeight = [[TextAndImageHeight alloc] init];
        
        for (int i = 0; i < resonse.count; i++) {
            
            ParserPrice *parserPrice = [[ParserPrice alloc] init];
            [parserPrice mts_setValuesForKeysWithDictionary:[response objectAtIndex:i]];
            
            //работаем с анатоцией
            
            //Работа с анотацией
            parserPrice.price_name = [parserMethod stringByStrippingHTML:parserPrice.price_name];
            
           
            
            
            CGFloat textHeight =
            [textAndImageHeight getHeightForText:parserPrice.price_name
                                        textWith:180
                                        withFont:[UIFont systemFontOfSize:22]];
            
            parserPrice.targetHeightText=textHeight;
            //
            
            
            //Работа с текстом
            
        
            parserPrice.price_body = [parserMethod stringByStrippingHTML:parserPrice.price_body];
            
            
            
            //
             [arrayResponse addObject:parserPrice];
            
            //Отслеживаем конец цикла
            if ([[resonse objectAtIndex:i] isEqual:[resonse lastObject]]) {
                
                block();
                
            }
        }
        
        
        //Конец цикла
        
        
    }else if ([response isKindOfClass:[NSDictionary class]]) {
        
        
    }
}

@end
