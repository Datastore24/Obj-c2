//
//  ParserItems.h
//  Lesson6
//
//  Created by Кирилл Ковыршин on 01.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motis/Motis.h>

@interface ParserItems : NSObject

//Детали заказа
@property (strong,nonatomic) NSString * itemCount;
@property (strong,nonatomic) NSString * itemName;
@property (strong,nonatomic) NSString * itemPrice;

- (void) parsing: (id) response andArray:(NSMutableArray*) arrayResponse andBlock:(void (^)(void)) block;

@end
