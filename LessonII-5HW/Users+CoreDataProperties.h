//
//  Users+CoreDataProperties.h
//  LessonII-5HW
//
//  Created by Кирилл Ковыршин on 26.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Users.h"

NS_ASSUME_NONNULL_BEGIN

@interface Users (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *urlSite;
@property (nullable, nonatomic, retain) NSString *login;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *comments;
@property (nullable, nonatomic, retain) NSDate *addedDate;

@end

NS_ASSUME_NONNULL_END
