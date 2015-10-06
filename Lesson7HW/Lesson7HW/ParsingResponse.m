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
          parse.fullText = parse.text;
          parse.fullText = [parse.fullText stringByReplacingOccurrencesOfString:@"<br>"
                                                           withString:@"\n"];
        text = [text stringByReplacingOccurrencesOfString:@"<br>"
                                               withString:@"\n"];
          text = [self trancateTextField:text andcount:2];
          parse.countTextArray = [self countTextField:text];

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

        if (textHeight < 36) {
          parse.targetHeight = 60;
        } else {
          parse.targetHeight = textHeight+15;
        }
        

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

-(NSString*) trancateTextField:(NSString *) text andcount:(NSInteger) count {
    //Обрезаем до 2 предложение
    NSArray * array = [text componentsSeparatedByString:@"."];
    NSString * result;
    if(array.count > 3){
        result = [[text componentsSeparatedByString:[array objectAtIndex:count]] firstObject];
    }else{
        result = text;
    }
    NSLog(@"%@",result);
    return result;
    //
}

-(NSInteger) countTextField:(NSString *) text {
    NSArray * array = [text componentsSeparatedByString:@"."];
    return array.count;

}

@end
