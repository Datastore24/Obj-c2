//
//  SingleTone.m
//  Lesson6
//
//  Created by Кирилл Ковыршин on 01.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "SingleTone.h"

@implementation SingleTone

@synthesize newsArticleId;
@synthesize countOffset;


#pragma mark Singleton Methods

+ (id)sharedManager{
    static SingleTone *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}



@end
