//
//  ParsingResponseAbout.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 10.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ParsingResponseAbout.h"
#import "TextAndImageHeight.h"
#import "UIImage+Resize.h"
#import "ParserAbout.h"
#import "ParserMethod.h"

@implementation ParsingResponseAbout
//Метод обрабатывающий ответ сервера
- (NSMutableArray *)parsing:(id)response
       {
           NSMutableArray * arrayResponse = [[NSMutableArray alloc] init];
    ParserMethod * parserMethod = [[ParserMethod alloc] init];
    
    if ([response isKindOfClass:[NSArray class]]) {
        NSArray *resonse = (NSArray *)response;
   
        
        for (int i = 0; i < resonse.count; i++) {
            
            ParserAbout *parserAbout = [[ParserAbout alloc] init];
            [parserAbout mts_setValuesForKeysWithDictionary:[response objectAtIndex:i]];
            
            //работаем с анатоцией
            //Дергаем главную фотографию
            parserAbout.about_general_photo = [parserMethod getImageWithDictionary:parserAbout.about_me];
            
            
            //
            
            //Работа с анотацией
            parserAbout.about_me = [parserMethod stringByStrippingHTML:parserAbout.about_me];
            [arrayResponse addObject:parserAbout];
            
        
            
            //
            
            
            
            
                
            
        }
      
        return arrayResponse;
        
        //Конец цикла
        
        
    }else if ([response isKindOfClass:[NSDictionary class]]) {
        
        
    }
           return nil;
}



@end
