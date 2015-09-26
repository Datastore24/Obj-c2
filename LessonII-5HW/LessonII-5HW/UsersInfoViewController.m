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
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation UsersInfoViewController 

- (void)viewDidLoad {
    self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBackground.jpg"]];
    self.addUserActionButton.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
    self.addUserActionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.addUserActionButton.layer.borderWidth = 1;
    self.addUserActionButton.layer.cornerRadius = 8;
    
    self.cancelButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    self.cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.cornerRadius = 8;
    
    if(self.isInfo){
        self.addUserActionButton.alpha = 0;
        self.urlTextFields.userInteractionEnabled = NO;
        self.loginTextFields.userInteractionEnabled = NO;
        self.passwordTextFields.userInteractionEnabled = NO;
        self.commentsTextFields.userInteractionEnabled = NO;
        
        self.urlTextFields.text = self.usersUrlSite;
        self.loginTextFields.text = self.usersLogin;
        self.passwordTextFields.text = self.usersPassowrd;
        self.commentsTextFields.text = self.usersComments;
        
        
    }else{
        self.addUserActionButton.userInteractionEnabled = NO;
        //Вывов метода нажатия на фон
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleBackgroundTap)];
        [self.view addGestureRecognizer:tap];
        
        //
        
        //Открываем клавиатуру в начале
        [self.urlTextFields becomeFirstResponder];
        [self.urlTextFields addTarget:self
                                 action:@selector(textFieldDidChange)
                       forControlEvents:UIControlEventEditingChanged];
        
        [self.loginTextFields addTarget:self
                               action:@selector(textFieldDidChange)
                     forControlEvents:UIControlEventEditingChanged];
        
        [self.passwordTextFields addTarget:self
                               action:@selector(textFieldDidChange)
                     forControlEvents:UIControlEventEditingChanged];
        
        [self.commentsTextFields addTarget:self
                               action:@selector(textFieldDidChange)
                     forControlEvents:UIControlEventEditingChanged];
        //
        
        
        
        //Действие для кнопки
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addUserAction:(id)sender {
    
   UsersDbClass *usersDbClass = [[UsersDbClass alloc] init];
if([usersDbClass checkUsers:self.urlTextFields.text andLogin:self.loginTextFields.text]){
    [self showAlertWithMessage:@"Сайт с таким логином уже существует"];
}else{
    [usersDbClass addNewUsers:self.urlTextFields.text andLogin:self.loginTextFields.text andPassword:self.passwordTextFields.text andComments:self.commentsTextFields.text];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WHEN_CREATE_NEW_EVENTS object:nil]; //Посыл нотификации
    
    [self.navigationController popViewControllerAnimated:YES];
}
    
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

//Метод срабатывает при изменении кнопки

- (void)textFieldDidChange {
    
    if (self.urlTextFields.text.length != 0 && self.loginTextFields.text.length != 0 && self.passwordTextFields.text.length != 0 && self.commentsTextFields.text.length != 0) {
        
        self.addUserActionButton.userInteractionEnabled = YES;
        
    } else {
        
        self.addUserActionButton.userInteractionEnabled = NO;
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
