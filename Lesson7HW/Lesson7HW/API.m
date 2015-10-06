//
//  API.m
//  Lesson6
//
//  Created by Кирилл Ковыршин on 29.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "API.h"

#define MAIN_URL @"https://api.vk.com/method/"


@implementation API

//Запрос на сервер, для забора заказа
-(void) getDataFromServerWithParams: (NSDictionary *) params method:(NSString*) method complitionBlock: (void (^) (id response)) compitionBack{
    
    NSString * url = [NSString stringWithFormat:@"%@%@",MAIN_URL,method];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    //Запрос
    [manager GET: url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Вызов блока
        compitionBack (responseObject);

        //Ошибки
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



@end
