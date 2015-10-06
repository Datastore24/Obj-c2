//
//  ParsingVK.m
//  Lesson7HW
//
//  Created by Кирилл Ковыршин on 05.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ParsingResponse.h"
#import "TextAndImageHeight.h"
#import "UIImage+Resize.h"
#import "Parser.h"


@implementation ParsingResponse
//Метод обрабатывающий ответ сервера
- (void)parsing:(id)response
       andArray:(NSMutableArray *)arrayResponse
        andView:(UIView *)view
       andBlock:(void (^)(void))block {
    //Если коллекция
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)response;
        
        NSArray *response = [dict objectForKey:@"response"];
        
        for (int i = 1; i < response.count; i++) {
            Parser *parse = [[Parser alloc] init];
            [parse mts_setValuesForKeysWithDictionary:[response objectAtIndex:i]];
            
            if (parse.height > 0 && parse.width > 0) {
                
                //Убираем мусор
                NSString *text = parse.text;
                text = [text stringByReplacingOccurrencesOfString:@"<br>"
                                                       withString:@"\n"];
                
                TextAndImageHeight *textAndImageHeight =
                [[TextAndImageHeight alloc] init];
                //Высота текста
                CGFloat textHeight =
                [textAndImageHeight getHeightForText:text
                                            textWith:view.frame.size.width - 10
                                            withFont:[UIFont systemFontOfSize:15]];
                //ВЫсота картинки
                CGFloat imageHeight = [textAndImageHeight
                                       getHeightForImageViewWithTargetWidth:view.frame.size.width
                                       imageWith:parse.width
                                       imageHeight:parse.height];
                
                //Высота ячейки
                parse.targetHeight=textHeight;
                NSLog(@"%f",textHeight);
                //          self.targetHeight = textHeight; //+ imageHeight;
                
                parse.text = text;
                
                [arrayResponse addObject:parse];
                if (i == response.count - 2) {
                    block();
                }
            }
        }
        
        //Если массив, внутри которого коллекции
    }
}

@end
