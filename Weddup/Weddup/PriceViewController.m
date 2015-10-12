//
//  PriceViewController.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 11.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "PriceViewController.h"
#import "API.h" //Обращение к API

#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения
#import "UIImage+Resize.h"//Ресайз изображения

#import "ParserPrice.h"
#import "ParsingResponsePrice.h"
#import "SingleTone.h"


//Другие окна
#import "ContactViewController.h"
#import "DetailPriceViewController.h"

//Блоки
#import "BBlock.h"


@interface PriceViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *priceTableView;
@property (strong, nonatomic) NSMutableArray * arrayResponse; //массив данных

//Взаимодействие с меню
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@end

@implementation PriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayResponse = [NSMutableArray array]; // Создание массива данных

    //Меню
   
    [self.newsButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.contactButton addTarget:self action:@selector(goContactRight) forControlEvents:UIControlEventTouchUpInside];
    
    //
    
    [self getPricesFromWeddup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Действия для меню

- (void)goContactRight{
    //Другое окно с деталями заказа
    ContactViewController *contact = [self.storyboard
                                      instantiateViewControllerWithIdentifier:@"contact"];
    
    [self.navigationController pushViewController:contact
                                         animated:YES];
}

- (void)goBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//

//Обновление таблицы
- (void)reloadTableViewWhenNewEvent {
    
    
    [self.priceTableView
     reloadSections:[NSIndexSet indexSetWithIndex:0]
     withRowAnimation:UITableViewRowAnimationFade];
    
    self.priceTableView.scrollEnabled = YES;
    
    //    Перезагрузка таблицы с
    //    анимацией
    
}

//Получение услуг
-(void) getPricesFromWeddup{
    //Передаваемые параметры
    
    API * api =[API new]; //создаем API
    [api getDataFromServerWithParams:nil method:@"action=load_products" complitionBlock:^(id response) {
        //Запуск парсера
        ParsingResponsePrice * parsingResponce =[[ParsingResponsePrice alloc] init];
        //парсинг данных и запись в массив
        [parsingResponce parsing:response andArray:self.arrayResponse andView:self.view  andBlock:^{
            
            [self reloadTableViewWhenNewEvent];
            
        }];
        
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.arrayResponse.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"priceCell";
    
    
    UITableViewCell *priceCell =
    [tableView dequeueReusableCellWithIdentifier:identifier
                                    forIndexPath:indexPath];
    
    ParserPrice * parser = [self.arrayResponse objectAtIndex:indexPath.row];
    
    
    
    
    
    [priceCell.contentView addSubview:[self getViewForCellWithResponse:parser]];
    
    
    
    return priceCell;

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ParserPrice * parse = [self.arrayResponse objectAtIndex:indexPath.row];
    
    return parse.targetHeightText+10;
    
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Другое окно с деталями заказа
    DetailPriceViewController *detailPrice = [self.storyboard
                                            instantiateViewControllerWithIdentifier:@"detailPrice"];
    
    detailPrice.arrayWithData = self.arrayResponse;
    
    
    [[SingleTone sharedManager] setNewsArticleId:indexPath.row]; //Создание синглтона, который передаст ID заказа
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:detailPrice
                                         animated:YES];
    
    
}


-(UIView *) getViewForCellWithResponse: (ParserPrice *) response {
   
    CGFloat resultPosition;
    if(response.targetHeightText>60){
        resultPosition=response.targetHeightText/2-30;
    }else{
        resultPosition=response.targetHeightText/2-12;
    }
    UIView * resultView = [[UIView alloc] initWithFrame:CGRectMake(0, resultPosition, self.view.frame.size.width, response.targetHeightText)];
    
    UITextView * priceNameView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, 180, response.targetHeightText)];
    
    
    priceNameView.editable = NO;
    priceNameView.scrollEnabled = NO;
    priceNameView.selectable =NO;
    priceNameView.userInteractionEnabled = NO;
    priceNameView.font=[UIFont systemFontOfSize:15];
    priceNameView.textColor = [UIColor purpleColor];
    priceNameView.text=response.price_name;
    
    UITextView * priceMinView = [[UITextView alloc] initWithFrame:CGRectMake(200, 0, 100, 30)];
    
    
    priceMinView.editable = NO;
    priceMinView.scrollEnabled = NO;
    priceMinView.selectable =NO;
    priceMinView.userInteractionEnabled = NO;
    priceMinView.font=[UIFont systemFontOfSize:15];
    priceMinView.textColor = [UIColor lightGrayColor];
    NSString * resultMinPrice = [NSString stringWithFormat:@"от %@ руб.",response.min_price];
    priceMinView.text=resultMinPrice;
    
    [resultView addSubview:priceNameView];
    [resultView addSubview:priceMinView];

    
    
    return resultView;
    
}



@end
