//
//  ParsingResponseVideo.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 12.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ParsingResponseVideo.h"
#import "ParserVideo.h"
#import "ParserMethod.h"
#import "TextAndImageHeight.h"

@implementation ParsingResponseVideo
- (NSMutableArray *)parsing:(id)response

        {
    NSMutableArray * arrayResponse = [[NSMutableArray alloc] init];
    ParserMethod * parserMethod = [[ParserMethod alloc] init];
    //Если это обновление удаляем все объекты из массива и грузим заного
    
    //
      
    if ([response isKindOfClass:[NSArray class]]) {
        NSArray *resonse = (NSArray *)response;
        
        TextAndImageHeight *textAndImageHeight = [[TextAndImageHeight alloc] init];
       
        for (int i = 0; i < resonse.count; i++) {
            NSLog(@"%@",response);
            ParserVideo *parserVideo = [[ParserVideo alloc] init];
            
            [parserVideo mts_setValuesForKeysWithDictionary:[response objectAtIndex:i]];
         
            
            
           parserVideo.video_name = [parserMethod stringByStrippingHTML:parserVideo.video_name];
            
            
            CGFloat textHeight =
            [textAndImageHeight getHeightForText:parserVideo.video_name
                                        textWith:180
                                        withFont:[UIFont systemFontOfSize:22]];
            
            parserVideo.targetHeightText=textHeight;
            //
            
            
     
            [arrayResponse addObject:parserVideo];
            
            
        }
        return arrayResponse;
        
        //Конец цикла
        
        
    }else if ([response isKindOfClass:[NSDictionary class]]) {
        
        
    }
            return nil;
}

@end
