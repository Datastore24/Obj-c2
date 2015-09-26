//
//  ViewController.m
//  LessonII-5HW
//
//  Created by Кирилл Ковыршин on 26.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ViewController.h"
#import "UsersDbClass.h"
#import "Users.h"
#import "ConstantsHeader.h"
#import "CustomTableView.h"
#import "UsersInfoViewController.h"
@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
@property (strong,nonatomic) NSArray * arrayUsers;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UsersDbClass * users = [[UsersDbClass alloc] init];
    //Создаем property с массивом пользователей
    self.arrayUsers = [users showAllUsers];
    
    //
    self.usersTableView.backgroundColor = [UIColor clearColor];
    self.usersTableView.opaque = NO;
    self.usersTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"viewBackground.jpg"]];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewWhenNewEvent) name:NOTIFICATION_WHEN_CREATE_NEW_EVENTS object:nil];
   
}

//Отписываемся от нотификации
- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadTableViewWhenNewEvent {
    
    self.arrayUsers = nil;
    
    UsersDbClass * users = [[UsersDbClass alloc] init];
    self.arrayUsers = [users showAllUsers];
    
    
    
    [self.usersTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade]; //Перезагрузка таблицы с анимацией
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.arrayUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * identifier = @"mainCell";
    
    CustomTableView *cell = (CustomTableView *)
    [tableView dequeueReusableCellWithIdentifier:identifier
                                    forIndexPath:indexPath];
                Users * users = [self.arrayUsers objectAtIndex:indexPath.row];
                cell.urlLabel.text = users.urlSite;
                cell.loginLabel.text = users.login;
                cell.commentLabel.text = users.comments;
    cell.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UsersInfoViewController * userInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"usersDetailView"];
    
    Users * users = [self.arrayUsers objectAtIndex:indexPath.row];

    userInfoViewController.usersUrlSite = users.urlSite;
    userInfoViewController.usersLogin = users.login;
    userInfoViewController.usersPassowrd = users.password;
    userInfoViewController.usersComments = users.comments;
    userInfoViewController.isInfo = YES;
    
    
    [self.navigationController pushViewController:userInfoViewController animated:YES];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UsersDbClass * usersDbClass = [[UsersDbClass alloc] init];
        Users * users = [self.arrayUsers objectAtIndex:indexPath.row];
       
        [usersDbClass deleteUsers:users.urlSite andLogin:users.login];
        self.arrayUsers = nil;
        self.arrayUsers = [usersDbClass showAllUsers];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

@end
