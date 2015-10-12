//
//  ParsingResponsePrice.h
//  Weddup
//
//  Created by Кирилл Ковыршин on 12.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ParsingResponsePrice : NSObject
- (void)parsing:(id)response andArray:(NSMutableArray*) arrayResponse andView:(UIView *) view
       andBlock:(void (^)(void))block;
@end
