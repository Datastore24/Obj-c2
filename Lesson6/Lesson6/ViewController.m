//
//  ViewController.m
//  Lesson6
//
//  Created by Кирилл Ковыршин on 29.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ViewController.h"
#import "API.h"
#import "CustomOrdersTableViewCell.h"
#import "Parser.h"
#import "OrderDetailViewController.h"
#import "SingleTone.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ordersTableView;
@property (strong, nonatomic) NSMutableArray * arrayResponse; //массив данных


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.arrayResponse = [NSMutableArray array]; // Создаем массив
    
    API * api =[API new]; //создаем API
    
    //Обращемся к методу получения данных заказа
    [api getDataFromServerWithMethod:@"" complitionBlock:^(id response) {
        
        //Запуск парсера
        Parser * parse =[[Parser alloc] init];
        //парсинг данных и запись в массив
        [parse parsing:response andArray:self.arrayResponse andBlock:^{
            [self reloadTableViewWhenNewEvent]; // обновление таблицы
        }];
      
        
    }];
    
}



//Обновление таблицы
- (void)reloadTableViewWhenNewEvent {
    
    [self.ordersTableView
     reloadSections:[NSIndexSet indexSetWithIndex:0]
     withRowAnimation:UITableViewRowAnimationFade]; //Перезагрузка таблицы с
    //анимацией
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource


//Подсчет количества строк
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayResponse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"orderCell";
    
    //Кастомная сторка
    CustomOrdersTableViewCell *cell = (CustomOrdersTableViewCell *)
    [tableView dequeueReusableCellWithIdentifier:identifier
                                    forIndexPath:indexPath];

    //Обращение к объектам массива
    Parser * parser = [self.arrayResponse objectAtIndex:indexPath.row];
    //Загрузка данных строки
    cell.nameLabel.text=parser.customer_name;
    cell.addressLabel.text=parser.address;
    cell.phoneLabel.text=parser.phone1;
    cell.summLabel.text = [NSString stringWithFormat:@"%@ руб.",parser.orderSum];
    cell.dateLabel.text = parser.orderDate;
    //
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Другое окно с деталями заказа
    OrderDetailViewController *orderDetail = [self.storyboard
                                                       instantiateViewControllerWithIdentifier:@"orderDetail"];
    
     Parser * parser = [self.arrayResponse objectAtIndex:indexPath.row];
    
    //Заполнение ячеек другого view (обращение к property)
    orderDetail.orderID = parser.external_id;
    orderDetail.orderName=parser.customer_name;
    orderDetail.orderAddress=parser.address;
    orderDetail.orderPhone=parser.phone1;
    orderDetail.orderSumm = [NSString stringWithFormat:@"%@ руб.",parser.orderSum];
    orderDetail.orderDiscount = [NSString stringWithFormat:@"%@ руб.",parser.discount];
    
    [[SingleTone sharedManager] setSomeProperty:parser.external_id]; //Создание синглтона, который передаст ID заказа
    
    
    [self.navigationController pushViewController:orderDetail
                                         animated:YES];
}





@end
