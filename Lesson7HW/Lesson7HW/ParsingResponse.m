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
    
    if (self.isRefresh) {
        [arrayResponse removeAllObjects];
    }
  if ([response isKindOfClass:[NSDictionary class]]) {
    NSDictionary *dict = (NSDictionary *)response;
    
    NSArray *response = [dict objectForKey:@"response"];

    for (int i = 1; i < response.count; i++) {
      Parser *parse = [[Parser alloc] init];
      [parse mts_setValuesForKeysWithDictionary:[response objectAtIndex:i]];

      //Текст
      
      parse.fullText = parse.text;
      parse.fullText =
          [parse.fullText stringByReplacingOccurrencesOfString:@"<br>"
                                                    withString:@"\n"];
      NSString *text = parse.text;
      text =
          [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
      
      parse.countTextArray = [self countTextField:text];
        
          text = [self trancateTextField:text andcount:2];


      TextAndImageHeight *textAndImageHeight =
          [[TextAndImageHeight alloc] init];
      //Высота текста
      CGFloat textHeight =
          [textAndImageHeight getHeightForText:text
                                      textWith:view.frame.size.width-10
                                      withFont:[UIFont systemFontOfSize:15]];

      parse.text = text;
      //
        
      //Описание фотографии
        parse.fullText = parse.text;
        parse.fullText =
        [parse.fullText stringByReplacingOccurrencesOfString:@"<br>"
                                                  withString:@"\n"];
        //
        NSString *photoText = parse.photoText;
        CGFloat photoTextHeight;
        
        if([photoText length] != 0){
        photoText =
        [photoText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        
        //Высота текста
        photoTextHeight =
        [textAndImageHeight getHeightForText:photoText
                                    textWith:view.frame.size.width-10
                                    withFont:[UIFont systemFontOfSize:15]];
        
        parse.photoText = photoText;
        }else{
            photoTextHeight = 0;
        }

      //
      if (parse.height > 0 && parse.width > 0) {

        CGFloat imageHeight = [textAndImageHeight
            getHeightForImageViewWithTargetWidth:view.frame.size.width
                                       imageWith:parse.width
                                     imageHeight:parse.height];
          
          
          
              parse.targetHeightImage = imageHeight;
              parse.targetHeightText = textHeight + 15;
         
            parse.targetHeightPhotoText = photoTextHeight;
          
          
          

          
        [arrayResponse addObject:parse];

      } else {
            
          parse.targetHeightText = textHeight+15;
          parse.targetHeightImage = 0;
              parse.targetHeightPhotoText = photoTextHeight;
         
       

        [arrayResponse addObject:parse];
      }
        //Отслеживаем конец цикла
      if ([[response objectAtIndex:i] isEqual:[response lastObject]]) {
        block();
      }
    }//Конец цикла

    //Если массив, внутри которого коллекции
  }
}

//Обрезка текста
- (NSString *)trancateTextField:(NSString *)text andcount:(NSInteger)count {
  //Обрезаем до 2 предложение
  NSArray *array = [text componentsSeparatedByString:@"."];
  NSString *result;
  if (array.count > 3) {

    result = [[text componentsSeparatedByString:[array objectAtIndex:count]] firstObject];

  } else {
      
    result = text;
      
  }

  return result;
  //
}

//Счетчик предложений
- (NSInteger)countTextField:(NSString *)text {
  NSArray *array = [text componentsSeparatedByString:@"."];
  return array.count;
}

@end
