//
//  API.m
//  Lesson6
//
//  Created by Кирилл Ковыршин on 29.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "API.h"
#define API_KEY @"R6tYkBhREgYp6ioXDx7gAkzHfCZnGyxnsRbEhjlMr05lii9MF6"
#define SHOP_ID @"3"


@implementation API

//Запрос на сервер, для забора заказа
-(void) getDataFromServerWithMethod: (NSString *) string complitionBlock: (void (^) (id response)) compitionBack{
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    //Параметры передаваемые серверу
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"load_all_orders",@"action",
                             SHOP_ID,@"shop_id",
                             API_KEY,@"api_key", nil];
    
    //Запрос
    [manager GET:@"http://aquatoriall.ru/leadoon.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Вызов блока
        compitionBack (responseObject);

        //Ошибки
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//Запрос на сервер за деталями заказа
-(void) getOrderFromServerWithId: (NSString *) orderId complitionBlock:  (void (^) (id response)) compitionBack{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"load_orders",@"action",
                             SHOP_ID,@"shop_id",
                             API_KEY,@"api_key",
                             orderId,@"order_id",
                             nil];
    [manager POST:@"http://aquatoriall.ru/leadoon.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        compitionBack (responseObject);
//        NSLog(@"JSON POST: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

@end
