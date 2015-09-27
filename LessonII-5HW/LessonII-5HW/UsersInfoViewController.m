//
//  UsersInfoViewController.m
//  LessonII-5HW
//
//  Created by Кирилл Ковыршин on 26.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "UsersInfoViewController.h"
#import "UsersDbClass.h"
#import "ConstantsHeader.h"

@interface UsersInfoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlTextFields;
@property (weak, nonatomic) IBOutlet UITextField *loginTextFields;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFields;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextFields;
@property (weak, nonatomic) IBOutlet UIButton *addUserActionButton;
@property (weak, nonatomic) IBOutlet UIButton *editUserActionButton;


@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UILabel *urlSitePlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *loginPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *commentPlaceholder;
@property (assign,nonatomic) float normalCoordX;
@property (weak, nonatomic) IBOutlet UILabel *passwordPlaceholder;
@end

@implementation UsersInfoViewController 

- (void)viewDidLoad {
    self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBackground.jpg"]];
    
    self.addUserActionButton.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
    self.addUserActionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.addUserActionButton.layer.borderWidth = 1;
    self.addUserActionButton.layer.cornerRadius = 8;
    
    self.editUserActionButton.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
    self.editUserActionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.editUserActionButton.layer.borderWidth = 1;
    self.editUserActionButton.layer.cornerRadius = 8;
    
    [self.editButton setTarget:self];
    [self.editButton setAction:@selector(editAction)];
    
    
    if(self.isInfo){
        self.addUserActionButton.alpha = 0;
        self.editUserActionButton.alpha =0;
        self.urlTextFields.userInteractionEnabled = NO;
        self.loginTextFields.userInteractionEnabled = NO;
        self.passwordTextFields.userInteractionEnabled = NO;
        self.commentsTextFields.userInteractionEnabled = NO;
        
        self.urlTextFields.text = self.usersUrlSite;
        self.loginTextFields.text = self.usersLogin;
        self.passwordTextFields.text = self.usersPassowrd;
        self.commentsTextFields.text = self.usersComments;
        
        self.urlSitePlaceholder.alpha = 0;
        self.loginPlaceholder.alpha = 0;
        self.passwordPlaceholder.alpha = 0;
        self.commentPlaceholder.alpha = 0;
        
        
        
    }else{
        self.editUserActionButton.alpha =0;
        [self.navigationItem setRightBarButtonItems:nil animated:NO];
        self.addUserActionButton.userInteractionEnabled = NO;
        //Вывов метода нажатия на фон
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleBackgroundTap)];
        [self.view addGestureRecognizer:tap];
        
        //
        
        //Открываем клавиатуру в начале

        [self.urlTextFields addTarget:self
                               action:@selector(textFieldEditingDidBegin:)
                       forControlEvents:UIControlEventEditingDidBegin];
        self.urlTextFields.tag=10;
        
        [self.loginTextFields addTarget:self
                                 action:@selector(textFieldEditingDidBegin:)
                     forControlEvents:UIControlEventEditingDidBegin];
        self.loginTextFields.tag=20;
        
        [self.passwordTextFields addTarget:self
                                    action:@selector(textFieldEditingDidBegin:)
                     forControlEvents:UIControlEventEditingDidBegin];
        self.passwordTextFields.tag=30;
        
        [self.commentsTextFields addTarget:self
                                    action:@selector(textFieldEditingDidBegin:)
                     forControlEvents:UIControlEventEditingDidBegin];
        self.commentsTextFields.tag=40;
        
       
        //
        
        
        
        //Действие для кнопки
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

     
     - (void)editAction{
         [self.navigationItem setRightBarButtonItems:nil animated:YES];
         [UIView animateWithDuration:0.3 animations:^{
             self.editUserActionButton.alpha = 1;
             [self.editUserActionButton setFrame:CGRectMake(self.addUserActionButton.frame.origin.x-50, self.addUserActionButton.frame.origin.y, 130, self.addUserActionButton.frame.size.height)];

         } completion:^(BOOL finished) {
             
         }];
         
         self.urlTextFields.userInteractionEnabled = NO;
         self.urlTextFields.backgroundColor = [UIColor grayColor];
         self.loginTextFields.userInteractionEnabled = NO;
         self.loginTextFields.backgroundColor =[UIColor grayColor];
         self.passwordTextFields.userInteractionEnabled = YES;
         self.commentsTextFields.userInteractionEnabled = YES;
         
     }

//Обновление

- (IBAction)editUserAction:(id)sender {
    UsersDbClass *usersDbClass = [[UsersDbClass alloc] init];
    [usersDbClass updateUsers:self.urlTextFields.text andLogin:self.loginTextFields.text andPassword:self.passwordTextFields.text andComment:self.commentsTextFields.text];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WHEN_CREATE_NEW_EVENTS object:nil]; //Посыл нотификации
    
    [self.navigationController popViewControllerAnimated:YES];
}
//

//Добавление
- (IBAction)addUserAction:(id)sender {
    
   UsersDbClass *usersDbClass = [[UsersDbClass alloc] init];
if([usersDbClass checkUsers:self.urlTextFields.text andLogin:self.loginTextFields.text]){
    [self showAlertWithMessage:@"Сайт с таким логином уже существует"];
}else{
    [usersDbClass addNewUsers:self.urlTextFields.text andLogin:self.loginTextFields.text andPassword:self.passwordTextFields.text andComments:self.commentsTextFields.text];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WHEN_CREATE_NEW_EVENTS object:nil]; //Посыл нотификации
    
    [self.navigationController popViewControllerAnimated:YES];
}
    
//
    
}

//Нажание на фон userfrendly
- (void)handleBackgroundTap {
    
    [self.view endEditing:YES];
}


//Обработка текстового поля
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.usersUrlSite] &&
        self.urlTextFields.text.length != 0 && self.loginTextFields.text.length != 0 && self.passwordTextFields.text.length != 0 && self.commentsTextFields.text.length != 0) {
        
        [self.urlTextFields becomeFirstResponder];
        
        return YES;
    
    } else {
        
        [self showAlertWithMessage:@"Все поля формы должны быть заполнены"];
    }
    return NO;
}

//Анимация плейсхолдера
- (void) animatePlaceholder:(UILabel *)placeholder andAnimationType:(BOOL) animationType{
    
    self.normalCoordX = placeholder.frame.origin.x;
    if(animationType){
        [UIView animateWithDuration:0.4 animations:^{
            placeholder.alpha=0;
            [placeholder setFrame:CGRectMake(self.normalCoordX+50, placeholder.frame.origin.y, placeholder.bounds.size.width, placeholder.bounds.size.height)];
            
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            placeholder.alpha=1;
            [placeholder setFrame:CGRectMake(self.normalCoordX-50, placeholder.frame.origin.y, placeholder.bounds.size.width, placeholder.bounds.size.height)];
            
        }];
    }
    
}

//Метод срабатывает при изменении текста
-(void)textFieldDidChange:(UITextField *) sender {
    if (self.urlTextFields.text.length != 0 && self.loginTextFields.text.length != 0 && self.passwordTextFields.text.length != 0 && self.commentsTextFields.text.length != 0) {
        
        self.addUserActionButton.userInteractionEnabled = YES;
        
    } else {
        
        
        self.addUserActionButton.userInteractionEnabled = NO;
    }
}

//Вызов анимации плейсхолдера
- (void)textFieldEditingDidBegin:(UITextField *) sender {
    
    if(sender.tag ==10){
        
        [self animatePlaceholder:self.urlSitePlaceholder andAnimationType:1];
        [self.urlTextFields addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
        
    }else if(sender.tag ==20){
        
        [self animatePlaceholder:self.loginPlaceholder andAnimationType:1];
        [self.loginTextFields addTarget:self
                                 action:@selector(textFieldDidChange:)
                       forControlEvents:UIControlEventEditingChanged];
        
    }else if(sender.tag ==30){
        
        [self animatePlaceholder:self.passwordPlaceholder andAnimationType:1];
        [self.passwordTextFields addTarget:self
                                    action:@selector(textFieldDidChange:)
                          forControlEvents:UIControlEventEditingChanged];
        
    }else if(sender.tag ==40 ){
        
        [self animatePlaceholder:self.commentPlaceholder andAnimationType:1];
        [self.commentsTextFields addTarget:self
                                    action:@selector(textFieldDidChange:)
                          forControlEvents:UIControlEventEditingChanged];
        
    }

    
    
}




//Сообщение об ошибке
- (void)showAlertWithMessage:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание!!!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}

@end
