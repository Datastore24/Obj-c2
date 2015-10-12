//
//  ParsingVK.m
//  Lesson7HW
//
//  Created by Кирилл Ковыршин on 05.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ParsingResponseArticle.h"
#import "TextAndImageHeight.h"
#import "UIImage+Resize.h"
#import "ParserArticles.h"
#import "ParserMethod.h"


@implementation ParsingResponseArticle
//Метод обрабатывающий ответ сервера
- (void)parsing:(id)response
       andArray:(NSMutableArray *)arrayResponse
        andView:(UIView *)view
       andBlock:(void (^)(void))block {
    ParserMethod * parserMethod = [[ParserMethod alloc] init];
    //Если это обновление удаляем все объекты из массива и грузим заного
    if (self.isRefresh) {
        
        [arrayResponse removeAllObjects];
    }
    
    //
    
  if ([response isKindOfClass:[NSArray class]]) {
    NSArray *resonse = (NSArray *)response;
      
      TextAndImageHeight *textAndImageHeight = [[TextAndImageHeight alloc] init];
      
      for (int i = 0; i < resonse.count; i++) {
          
          ParserArticles *parserArctile = [[ParserArticles alloc] init];
          [parserArctile mts_setValuesForKeysWithDictionary:[response objectAtIndex:i]];
          
          //работаем с анатоцией
          //Дергаем главную фотографию
          NSString * urlImage = [parserMethod getImage:parserArctile.article_annotation];
          parserArctile.article_general_photo = (NSURL *)[NSString stringWithFormat:@"http://weddup.ru%@",urlImage];
          CGFloat imageHeight = [textAndImageHeight
                                 getHeightForImageViewWithTargetWidth:70
                                 imageWith:70
                                 imageHeight:70];
          
          if(!urlImage){
              parserArctile.targetHeightImage = 0;
          }else{
              parserArctile.targetHeightImage = imageHeight;
              
          }
          //
          
          //Работа с анотацией
          parserArctile.article_annotation = [parserMethod stringByStrippingHTML:parserArctile.article_annotation];
          self.article_count = parserArctile.article_count;
          [arrayResponse addObject:parserArctile];
          
          
          CGFloat textHeight =
          [textAndImageHeight getHeightForText:parserArctile.article_name
                                      textWith:200
                                      withFont:[UIFont systemFontOfSize:22]];
          
          parserArctile.targetHeightText=textHeight;
          //
          
          
          //Работа с текстом
          
          
          NSMutableArray * imageArray = [parserMethod getImageWithArray:parserArctile.article_text];
          
          parserArctile.article_array_photo = imageArray;
          
          parserArctile.article_text = [parserMethod stringByImage:parserArctile.article_text];
          parserArctile.article_text = [parserMethod stringByStrippingHTML:parserArctile.article_text];
          
          NSArray *articleArrayFullText = [parserArctile.article_text componentsSeparatedByString:@"[SEP]"];
          parserArctile.article_full_text = articleArrayFullText;
          
       
          
          //
          
          
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
