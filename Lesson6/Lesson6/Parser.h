//
//  Parser.h
//  Lesson6
//
//  Created by Кирилл Ковыршин on 01.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motis/Motis.h>

@interface Parser : NSObject

//Данные из массива
@property (strong,nonatomic) NSString * orderDate;
@property (strong,nonatomic) NSString * address;
@property (strong,nonatomic) NSString * comment;
@property (strong,nonatomic) NSString * customer_name;
@property (strong,nonatomic) NSString * discount;
@property (strong,nonatomic) NSString * external_id;
@property (strong,nonatomic) NSString * phone1;
@property (strong,nonatomic) NSString * orderSum;


- (void) parsing: (id) response andArray:(NSMutableArray*) arrayResponse andBlock:(void (^)(void)) block;

@end
