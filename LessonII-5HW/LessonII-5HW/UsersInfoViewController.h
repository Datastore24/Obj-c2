//
//  UsersInfoViewController.h
//  LessonII-5HW
//
//  Created by Кирилл Ковыршин on 26.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersInfoViewController : UIViewController

@property (strong,nonatomic) NSString * usersUrlSite;
@property (strong,nonatomic) NSString * usersLogin;
@property (strong,nonatomic) NSString * usersPassowrd;
@property (strong,nonatomic) NSString * usersComments;


@property (assign,nonatomic) BOOL isInfo;

@end
