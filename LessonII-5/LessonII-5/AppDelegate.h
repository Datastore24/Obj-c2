//
//  AppDelegate.h
//  LessonII-5
//
//  Created by Кирилл Ковыршин on 25.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext; //связующее звяно между приложение и PersistentStoreCoordinator

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel; //отвечает за модель базы данны, именно ту модель, которую мы видим в файле с расширением xcdatamodeld

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator; //Мост между мобильным приложением и базой данных

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

