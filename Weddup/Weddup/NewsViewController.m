//
//  ViewController.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 07.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "NewsViewController.h"
#import "API.h" //Обращение к API
#import "ParserArticles.h" //Парсинг новостей
#import "ParsingResponseArticle.h" //Парсинг ответа от сервера
#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения
#import "UIImage+Resize.h"//Ресайз изображения
#import "ParseDate.h"//Парсинг даты
//Обновление
#import "KYPullToCurveVeiw.h"
#import "KYPullToCurveVeiw_footer.h"
#import "SingleTone.h"

//Другие окна
#import "DetailNewsViewController.h"
#import "ContactViewController.h"
#import "PriceViewController.h"

//Блоки
#import "BBlock.h"


@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (assign,nonatomic) NSUInteger newsCount;
@property (assign,nonatomic) NSUInteger offset;
@property (assign,nonatomic) NSUInteger maxCount;

@property (nonatomic, strong) KYPullToCurveVeiw *headerView;
@property (nonatomic, strong) KYPullToCurveVeiw_footer *footerView;

@property (assign,nonatomic) BOOL isRefresh;

@property (strong, nonatomic) NSMutableArray * arrayResponse; //массив данных

//Взаимодействие с меню
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Кнопки меню
   
    [self.contactButton addTarget:self action:@selector(goContactRight) forControlEvents:UIControlEventTouchUpInside];
    [self.priceButton addTarget:self action:@selector(goPriceRight) forControlEvents:UIControlEventTouchUpInside];
    [self.videoButton addTarget:self action:@selector(goVideoRight) forControlEvents:UIControlEventTouchUpInside];
    //
    
    
    self.newsCount = 10;
    self.offset = 0;
    self.arrayResponse = [NSMutableArray array]; // Создание массива данных
    
    //Нижнее меню
    self.menuView.layer.borderColor =[UIColor grayColor].CGColor; //Цвет меню
    self.menuView.layer.borderWidth = 1; //Граница меню нижнего
    //
    self.isRefresh = YES;
    //Настройка разделителя статей
    [self.newsTableView setSeparatorColor:[UIColor purpleColor]];
    //
    
    self.headerView.alpha=0;
    self.footerView.alpha=0;
    
    [self getArticlesFromWeddup];
    
    
    
    
}

//Действия для меню

- (void)goContactRight{
    //Другое окно с деталями заказа
    ContactViewController *contact = [self.storyboard
                                      instantiateViewControllerWithIdentifier:@"contact"];
    
    [self.navigationController pushViewController:contact
                                         animated:YES];
}

- (void)goVideoRight{
    //Другое окно с деталями заказа
    ContactViewController *contact = [self.storyboard
                                      instantiateViewControllerWithIdentifier:@"video"];
    
    [self.navigationController pushViewController:contact
                                         animated:YES];
}

- (void)goPriceRight{
    //Другое окно с деталями заказа
    PriceViewController *contact = [self.storyboard
                                      instantiateViewControllerWithIdentifier:@"price"];
    
    [self.navigationController pushViewController:contact
                                         animated:YES];
}

- (void)goBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//

//Получение статей
-(void) getArticlesFromWeddup{
    //Передаваемые параметры
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithInteger:self.newsCount],@"count",
                             [NSNumber numberWithInteger:self.offset],@"offset",
                             nil];
    API * api =[API new]; //создаем API
    [api getDataFromServerWithParams:params method:@"action=load_articles" complitionBlock:^(id response) {
        //Запуск парсера
        ParsingResponseArticle * parsingResponce =[[ParsingResponseArticle alloc] init];
        parsingResponce.isRefresh = self.isRefresh;
        //парсинг данных и запись в массив
        [parsingResponce parsing:response andArray:self.arrayResponse andView:self.view  andBlock:^{
           
            
            self.maxCount = [parsingResponce.article_count integerValue];
            if (self.isRefresh) {
                
                [self.headerView stopRefreshing];
                self.newsTableView.scrollEnabled = YES;
                
            }
            else {
                
                [self.footerView stopRefreshing];
                self.newsTableView.scrollEnabled = YES;
                
                
            }
            [self reloadTableViewWhenNewEvent];
        
        }];
        
    }];
}

//Для рефрешера
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /*
     Относительно предупреждений, это было связано с тем, что блок является объектом (сущностью в памяти) и такой объект должен быть высвобождени из памяти (потом). Объекты, которые инициализируются внутри блока имеют strong ссылку и эти объекты поставлены в зависимость от жизни объекта ViewController. Таким образом компилятор предупреждает о том, что возможно блок не сможет быть высвобожден из памяти.
     Чтоб это исправить, мы должны указать объектам, которые инициализируются внутри блока, что их жизнь, в данном конкретном случае зависит не от вью контроллера, а от блока.
     Для этого необходимо создать локальную переменную (как приведено ниже), которая будет иметь weak (слабую) ссылку на объект. Теперь блок может быть высвобожден из памяти
     Под эту тему нашел оч хороший класс, который реализует основные задачи с блоками в GCD, а так же прием описанный выше. Я этот класс дополнил возможностью выполнения задачи синхронно, в общем можно пользоваться
     
     */
    
    self.headerView = [[KYPullToCurveVeiw alloc]initWithAssociatedScrollView:self.newsTableView withNavigationBar:YES];

    
    BBlockWeakSelf wself = self;
    [self.headerView  addRefreshingBlock:^{
        
        wself.isRefresh = YES;
        wself.newsTableView.scrollEnabled = NO;
        wself.offset = 0;
        wself.newsCount=10;
        [wself getArticlesFromWeddup];
        
    }];
    
    
    self.footerView = [[KYPullToCurveVeiw_footer alloc]initWithAssociatedScrollView:self.newsTableView withNavigationBar:YES];
    
    
    
    [self.footerView addRefreshingBlock:^{
        
        if (wself.offset + wself.newsCount < wself.maxCount) {
            wself.isRefresh = NO;
            wself.newsTableView.scrollEnabled = NO;
            wself.offset = self.offset + self.newsCount;
            [wself getArticlesFromWeddup];
        }else{
            wself.offset=wself.maxCount;
            wself.newsTableView.scrollEnabled = YES;
            wself.newsCount=wself.maxCount;
            [wself.footerView stopRefreshing];
        }
        
    }];
    
    
}

//

//Обновление таблицы
- (void)reloadTableViewWhenNewEvent {
    
    
    [self.newsTableView
     reloadSections:[NSIndexSet indexSetWithIndex:0]
     withRowAnimation:UITableViewRowAnimationFade];
    
    self.newsTableView.scrollEnabled = YES;
    
    //    Перезагрузка таблицы с
    //    анимацией
  
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.arrayResponse.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"newsCell";
    

    UITableViewCell *newsCell =
    [tableView dequeueReusableCellWithIdentifier:identifier
                                    forIndexPath:indexPath];
    
    ParserArticles * parser = [self.arrayResponse objectAtIndex:indexPath.row];
    
    
    [BBlock dispatchOnMainThreadSync:^{
        for (UIView * view in newsCell.contentView.subviews) {
            
            [view removeFromSuperview];
        }
        
        [self setActivityIndicatorForCell:parser cell:newsCell];
    }];

   
    
    [newsCell.contentView addSubview:[self getViewForCellWithResponse:parser cell:newsCell]];

    return newsCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ParserArticles * parse = [self.arrayResponse objectAtIndex:indexPath.row];
    
      return parse.targetHeightText+parse.targetHeightImage+5;
   
    
}



-(UIView *) getViewForCellWithResponse: (ParserArticles *) response  cell :(UITableViewCell *) cell{
    
    UIView * resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, response.targetHeightText+response.targetHeightImage)];
    
    UILabel * dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-130, 8, 100, 20)];
    dateLabel.textAlignment = NSTextAlignmentRight;
   
    ParseDate * parseDate =[[ParseDate alloc] init];
    
    //Изменения даты
    if([response.article_date isEqual:[parseDate dateFormatToDay]]){
        dateLabel.text = @"сегодня";
    }else if([response.article_date isEqual:[parseDate dateFormatToYesterDay]]){
        dateLabel.text = @"вчера";
    }else if([response.article_date isEqual:[parseDate dateFormatToDayBeforeYesterday]]){
         dateLabel.text = @"позавчера";
    }else{
        dateLabel.text = response.article_date;
    }
    //
    
    dateLabel.textColor = [UIColor lightGrayColor];
    dateLabel.font = [UIFont systemFontOfSize:11];
    
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 33, 200, response.targetHeightText)];
    
  
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.selectable =NO;
    textView.userInteractionEnabled = NO;
    textView.font=[UIFont systemFontOfSize:15];
    textView.textColor = [UIColor purpleColor];
    textView.text=response.article_name;
    
    
    
    UIView * conteinerImage = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 70, 70)];
    conteinerImage.layer.cornerRadius = 35.0;
    conteinerImage.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    conteinerImage.layer.shadowOffset = CGSizeMake(3, 3);
    conteinerImage.layer.shadowOpacity = 1;
    conteinerImage.layer.shadowRadius = 1.0;
    conteinerImage.clipsToBounds = NO;
    
    
    __block UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 70, 70)];
    
    //SingleTone с ресайз изображения
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:response.article_general_photo
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if(image){
                                CGSize targetSize = CGSizeMake(70, 70);
                                
                                UIImage * imageResizing = [image resizedImage:targetSize interpolationQuality:kCGInterpolationHigh];
                                
                                [BBlock dispatchOnMainThreadSync:^{
                                    for (UIView * view in cell.contentView.subviews) {
                                        
                                        if (view.tag == 25) {
                                            
                                            [view removeFromSuperview];
                                            
                                        }
                                        
                                    }
                                }];
                                
                                [UIView transitionWithView:imageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                    imageView.image = imageResizing;
                                    imageView.layer.cornerRadius = 35.0;
                                    imageView.layer.masksToBounds = YES;
                                    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
                                    imageView.layer.borderWidth = 3.0;
                                    imageView.layer.masksToBounds = YES;
                                    imageView.clipsToBounds = YES;
                                } completion:nil];
                                
                                
                                
                            }
                        }];
    [resultView addSubview:dateLabel];
    [resultView addSubview:textView];
    [conteinerImage addSubview:imageView];
    [resultView addSubview:conteinerImage];
    
    
    return resultView;
    
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Другое окно с деталями заказа
    DetailNewsViewController *detailNews = [self.storyboard
                                              instantiateViewControllerWithIdentifier:@"detailNews"];
    
    detailNews.arrayWithData = self.arrayResponse;
    
    
    [[SingleTone sharedManager] setNewsArticleId:indexPath.row]; //Создание синглтона, который передаст ID заказа
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:detailNews
                                         animated:YES];
    
}

- (void)setActivityIndicatorForCell:(ParserArticles *) response cell :(UITableViewCell *) cell
{
    
    if (response.targetHeightImage > 0) {
        
        
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]
                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.tag = 25;
        [indicator startAnimating];
        indicator.frame = CGRectMake(self.view.frame.size.width / 2 - 10,
                                     response.targetHeightImage / 2 - 10, 20, 20);
        [cell.contentView addSubview:indicator];
        
    }
    
}

@end
