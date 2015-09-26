//
//  SomePerson+CoreDataProperties.h
//  LessonII-5
//
//  Created by Кирилл Ковыршин on 25.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SomePerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface SomePerson (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;

@end

NS_ASSUME_NONNULL_END
