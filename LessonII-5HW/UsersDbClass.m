//
//  UsersDbClass.m
//  LessonII-5HW
//
//  Created by Кирилл Ковыршин on 26.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "UsersDbClass.h"
#import "Users.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation UsersDbClass

-(void) addNewUsers: (NSString *) urlSite andLogin: (NSString *) login andPassword: (NSString *) password andComments: (NSString *) comments{
    // Get the local context
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Users.sqlite"];
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_context];
    if(![self checkUsers:urlSite andLogin:login]){
        Users *users = [Users MR_createEntityInContext:localContext];
        users.urlSite = urlSite;
        users.login = login;
        users.password = password;
        users.comments = comments;
        users.addedDate = [NSDate date];
        
        [localContext MR_saveToPersistentStoreAndWait];
    }else{
        NSLog(@"Такие данные уже существуют");
    }
    
    
    
}

-(NSArray *) showAllUsers{
    NSArray *users            = [Users MR_findAll];
    return users;
}

- (BOOL)checkUsers:(NSString *) urlSite andLogin:(NSString *)login{
   
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_context];
    
    
    NSPredicate *predicate                  = [NSPredicate predicateWithFormat:@"urlSite ==[c] %@ AND login ==[c] %@", urlSite  , login];
    Users *usersFounded                   = [Users MR_findFirstWithPredicate:predicate inContext:localContext];
    
    // If a person was founded
    if (usersFounded)
    {
        return YES;
    }else{
        return NO;
    }
}

- (void)deleteUsers:(NSString *)urlSite andLogin:(NSString *) login
{
    // Get the local context
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_context];
    
    // Retrieve the first person who have the given firstname
    NSPredicate *predicate                  = [NSPredicate predicateWithFormat:@"urlSite ==[c] %@ AND login ==[c] %@", urlSite  , login];
    Users *usersFounded                   = [Users MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if (usersFounded)
    {
        // Delete the person found
        [usersFounded MR_deleteEntityInContext:localContext];
        
        // Save the modification in the local context
        // With MagicalRecords 2.0.8 or newer you should use the MR_saveNestedContexts
        [localContext MR_saveToPersistentStoreAndWait];
    }
}


@end
