//
//  ParserMethod.h
//  Weddup
//
//  Created by Кирилл Ковыршин on 10.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserMethod : NSObject
-(NSString *) stringByImage: (NSString*) string; //Замена изображения на метку [IMAGE_index], где index порядковый номер
- (NSString *) stringByStrippingHTML: (NSString*) string; //удаление HTML
- (NSMutableArray *) getImageWithArray: (NSString *) string; //Получение массива изображений с размерами
-(NSMutableDictionary *) getImageWithDictionary: (NSString *) string; //Получение одной фотографии в коллекции с размерами
- (NSString *) getImage: (NSString *) string; //Получение изображения в строке
- (NSString *)trancateTextField:(NSString *)text andcount:(NSInteger)count; //обрезка текста
- (NSInteger)countTextField:(NSString *)text;//Счетчик предложение
@end
