//
//  OrderDetailViewController.h
//  Lesson6
//
//  Created by Кирилл Ковыршин on 01.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController

//Промежуточные опции, которые позволяют заполнить данные экрана деталей, без дополнительного запроса
//Массив создан во ViewControlle
//Далее мы его используем в файле имплементации, для заполнения деталей

@property (strong,nonatomic) NSString * orderName;
@property (strong,nonatomic) NSString * orderAddress;
@property (strong,nonatomic) NSString * orderPhone;
@property (strong,nonatomic) NSString * orderSumm;
@property (strong, nonatomic) NSString * orderComment;
@property (strong,nonatomic) NSString * orderDiscount;
@property (strong,nonatomic) NSString * orderID;

@end
