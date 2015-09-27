//
//  UsersDbClass.h
//  LessonII-5HW
//
//  Created by Кирилл Ковыршин on 26.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsersDbClass : NSObject

-(void) addNewUsers: (NSString *) urlSite andLogin: (NSString *) login andPassword: (NSString *) password andComments: (NSString *) comments;
- (void)deleteUsers:(NSString *)urlSite andLogin:(NSString *) login;
- (BOOL)checkUsers:(NSString *) urlSite andLogin:(NSString *)login;
-(NSArray *) showAllUsers;
- (void)updateUsers:(NSString *)urlSite andLogin:(NSString *)login andPassword:(NSString *)password andComment:(NSString *) comment;

@end
