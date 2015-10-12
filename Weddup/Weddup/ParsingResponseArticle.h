//
//  ParsingVK.h
//  Lesson7HW
//
//  Created by Кирилл Ковыршин on 05.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ParsingResponseArticle : NSObject

@property (assign,nonatomic) BOOL isRefresh;
@property (strong,nonatomic) NSString * article_count;

- (void)parsing:(id)response andArray:(NSMutableArray*) arrayResponse andView:(UIView *) view
       andBlock:(void (^)(void))block;
@end
