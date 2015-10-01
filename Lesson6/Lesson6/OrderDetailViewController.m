//
//  OrderDetailViewController.m
//  Lesson6
//
//  Created by Кирилл Ковыршин on 01.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "API.h"
#import "CustomOrderDetailTableViewCell.h"
#import "ParserItems.h"
#import "SingleTone.h"

@interface OrderDetailViewController ()  <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *summLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (strong, nonatomic) NSMutableArray * arrayResponse;
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Заполняем доступные Label
    self.arrayResponse = [NSMutableArray array];
    self.nameLabel.text = self.orderName;
    self.addressLabel.text = self.orderAddress;
    self.phoneLabel.text = self.orderPhone;
    self.summLabel.text = self.orderSumm;
    self.discountLabel.text = self.orderDiscount;
    self.commentLabel.text = self.orderComment;
    //
    
    //Обращение к API для забора деталей заказа и используем синглтон для того, что бы передать ID заказа
    API * api =[API new];
    [api getOrderFromServerWithId:[[SingleTone sharedManager] someProperty] complitionBlock:^(id response) {
        ParserItems * parse =[[ParserItems alloc] init];
        [parse parsing:response andArray:self.arrayResponse andBlock:^{
            [self reloadTableViewWhenNewEvent];
        }];
    }];
    //
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Перезагрузка таблицы
- (void)reloadTableViewWhenNewEvent {
    
    [self.orderTableView
     reloadSections:[NSIndexSet indexSetWithIndex:0]
     withRowAnimation:UITableViewRowAnimationFade]; //Перезагрузка таблицы с
    //анимацией
}

#pragma mark - UITableViewDataSource
//Количество строк
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayResponse.count;
}

//Заполнение таблицы данными
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"itemsCell";
    //Кастомное представление строки
    CustomOrderDetailTableViewCell *cell = (CustomOrderDetailTableViewCell *)
    [tableView dequeueReusableCellWithIdentifier:identifier
                                    forIndexPath:indexPath];

    //Заполнение таблицы
    ParserItems * parser = [self.arrayResponse objectAtIndex:indexPath.row];
    cell.itemName.text=parser.itemName;
    cell.itemCount.text=parser.itemCount;
    cell.itemPrice.text=parser.itemPrice;
    //
    

    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
