//
//  API.h
//  Lesson6
//
//  Created by Кирилл Ковыршин on 29.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface API : NSObject

//Метод запрашивающий список заказов
-(void) getDataFromServerWithMethod: (NSString *) string complitionBlock: (void (^) (id response)) compitionBack;

//Детали заказа
-(void) getOrderFromServerWithId: (NSString *) orderId complitionBlock:  (void (^) (id response)) compitionBack;

@end
