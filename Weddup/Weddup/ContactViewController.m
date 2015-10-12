//
//  ContactViewController.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 10.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ContactViewController.h"
#import "API.h"
#import "ParserAbout.h"
#import "ParsingResponseAbout.h"
#import "TextAndImageHeight.h"
#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения
#import "UIImage+Resize.h"//Ресайз изображения

#import "PriceViewController.h"

@interface ContactViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *contactScrollView;
@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;


@property (assign,nonatomic) CGFloat positionHeight;
@property (strong, nonatomic) NSMutableArray * arrayResponse; //массив данных

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.newsButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.priceButton addTarget:self action:@selector(goPriceRight) forControlEvents:UIControlEventTouchUpInside];
    [self getAboutMeFromWeddup];
    
   
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Действия для меню

- (void)goPriceRight{
    //Другое окно с деталями заказа
    ContactViewController *contact = [self.storyboard
                                      instantiateViewControllerWithIdentifier:@"price"];
    
    [self.navigationController pushViewController:contact
                                         animated:YES];
}

- (void)goBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//


//Получение статей
-(void) getAboutMeFromWeddup{
    //Передаваемые параметры

    API * api =[API new]; //создаем API
    [api getDataFromServerWithParams:nil method:@"action=load_about" complitionBlock:^(id response) {
        //Запуск парсера
        ParsingResponseAbout * parsingResponce =[[ParsingResponseAbout alloc] init];
        
        //парсинг данных и запись в массив
        
        ParserAbout * parser = [[parsingResponce parsing:response] objectAtIndex:0];
        [self getViewWithResponse:parser resultView:self.contactScrollView];
      
        
    }];
}



-(UIScrollView *) getViewWithResponse: (ParserAbout *) response  resultView :(UIScrollView *) resultView{
    

    TextAndImageHeight * textAndImageHeight = [[TextAndImageHeight alloc] init];
    
            
            NSDictionary * dictPhoto = response.about_general_photo;

            
            NSString * currentPhoto = [dictPhoto objectForKey:@"img"];
            CGFloat  currentWidth = [[dictPhoto objectForKey:@"width"] floatValue];
            CGFloat  currentHeight = [[dictPhoto objectForKey:@"height"] floatValue];
    
    
            NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://weddup.ru%@",currentPhoto]];
            
            CGFloat imageHeight = [textAndImageHeight
                                   getHeightForImageViewWithTargetWidth:self.view.frame.size.width
                                   imageWith:currentWidth
                                   imageHeight:currentHeight];
            
            CGFloat currentPosition = self.positionHeight;
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, currentPosition, self.view.frame.size.width, imageHeight)];
            self.positionHeight +=imageHeight+20;
            
            
            //SingleTone с ресайз изображения
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:imgURL
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if(image){
                                        imageView.frame=CGRectMake(0, currentPosition, self.view.frame.size.width, imageHeight);
                                        
                                        CGSize targetSize = CGSizeMake(self.view.frame.size.width, imageHeight);
                                        
                                        UIImage * imageResizing = [image resizedImage:targetSize interpolationQuality:kCGInterpolationHigh];
                                        
                                        imageView.image = imageResizing;
                                        
                                        [resultView addSubview:imageView];
                                        
                                        
                                    }else{
                                        
                                    }
                                }];
            
            
    
    
    
    CGFloat textHeight =
    [textAndImageHeight getHeightForText:response.about_me
                                textWith:self.contactScrollView.frame.size.width-20
                                withFont:[UIFont systemFontOfSize:15]];
    
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.positionHeight, resultView.frame.size.width-10, textHeight+20)];
    
    
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.selectable =NO;
    textView.userInteractionEnabled = NO;
    textView.font=[UIFont systemFontOfSize:15];
    textView.textColor = [UIColor purpleColor];
    textView.text=response.about_me;
    self.positionHeight +=textHeight+43; //Отступ от заголовка
    
    [resultView addSubview:textView];
    
    //[conteinerImage addSubview:imageView];
    //[resultView addSubview:conteinerImage];
    self.contactScrollView.contentSize= CGSizeMake(self.view.frame.size.width, self.positionHeight+90);
    
    return resultView;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
