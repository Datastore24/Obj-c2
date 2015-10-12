//
//  DetailPriceViewController.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 12.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "DetailPriceViewController.h"

#import "ContactViewController.h"
#import "PriceViewController.h"
#import "ParserPrice.h"
#import "SingleTone.h"
#import "TextAndImageHeight.h"

#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения
#import "UIImage+Resize.h"//Ресайз изображения

@interface DetailPriceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

@property (weak, nonatomic) IBOutlet UIScrollView *detailView;
@property (assign,nonatomic) CGFloat positionHeight;


@end

@implementation DetailPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Меню
    
    [self.backButton addTarget:self action:@selector(goPriceRight) forControlEvents:UIControlEventTouchUpInside];
    [self.newsButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.contactButton addTarget:self action:@selector(goContactRight) forControlEvents:UIControlEventTouchUpInside];
    [self.priceButton addTarget:self action:@selector(goPriceRight) forControlEvents:UIControlEventTouchUpInside];
    //
    
    NSInteger index = [[SingleTone sharedManager] newsArticleId];
    ParserPrice * parser = [self.arrayWithData objectAtIndex:index];
    
    self.positionHeight = 0;
    [self.detailView setCanCancelContentTouches:NO];
    self.detailView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.detailView.clipsToBounds = YES;
    self.detailView.scrollEnabled = YES;
    self.detailView.pagingEnabled = NO;
    self.detailView.autoresizesSubviews=YES;
    [self.detailView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self getViewWithResponse:parser resultView:self.detailView];
    
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


-(UIScrollView *) getViewWithResponse: (ParserPrice *) response  resultView :(UIScrollView *) resultView{
    
    TextAndImageHeight * textAndImageHeight = [[TextAndImageHeight alloc] init];
    
    CGFloat textNameHeight =
    [textAndImageHeight getHeightForText:response.price_name
                                textWith:self.detailView.frame.size.width-20
                                withFont:[UIFont systemFontOfSize:20]];
    
    
    UITextView * priceNameView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.positionHeight, resultView.frame.size.width-10, self.positionHeight+textNameHeight+20)];
    
    
    priceNameView.editable = NO;
    priceNameView.scrollEnabled = NO;
    priceNameView.selectable =NO;
    priceNameView.userInteractionEnabled = NO;
    priceNameView.font=[UIFont systemFontOfSize:20];
    priceNameView.textColor = [UIColor purpleColor];
    priceNameView.text=response.price_name;
    self.positionHeight +=textNameHeight+43; //Отступ от заголовка
    [resultView addSubview:priceNameView];

    UILabel * discription = [[UILabel alloc] initWithFrame:CGRectMake(15, self.positionHeight, resultView.frame.size.width-10, 20)];
    discription.text = @"Цены на услуги";
    
    [resultView addSubview:discription];
    self.positionHeight +=30;
    
    for(int i=0;i<response.price_properties.count; i++){
        NSDictionary * priceProperties = [response.price_properties objectAtIndex:i];
        NSString * price_name = [priceProperties objectForKey:@"v_name"];
        NSString * price_pr = [priceProperties objectForKey:@"v_price"];
        
            CGFloat textDetailHeight =
            [textAndImageHeight getHeightForText:price_name
                                        textWith:200
                                        withFont:[UIFont systemFontOfSize:15]];
            
            textDetailHeight+=20;
            
            
            UITextView * textDetalView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.positionHeight, 200, textDetailHeight)];
            
            textDetalView.editable = NO;
            textDetalView.scrollEnabled = NO;
            textDetalView.selectable =NO;
            textDetalView.userInteractionEnabled = NO;
            textDetalView.font=[UIFont systemFontOfSize:15];
            textDetalView.textColor = [UIColor purpleColor];
            textDetalView.text=price_name;
        
        CGFloat textPriceHeight =
        [textAndImageHeight getHeightForText:price_pr
                                    textWith:80
                                    withFont:[UIFont systemFontOfSize:15]];
        
        textPriceHeight+=20;
        
        
        UITextView * textPriceView = [[UITextView alloc] initWithFrame:CGRectMake(self.detailView.frame.size.width-80, self.positionHeight, 80, textDetailHeight)];
        
        textPriceView.editable = NO;
        textPriceView.scrollEnabled = NO;
        textPriceView.selectable =NO;
        textPriceView.userInteractionEnabled = NO;
        textPriceView.font=[UIFont systemFontOfSize:15];
        textPriceView.textColor = [UIColor lightGrayColor];
        textPriceView.text=price_pr;
        
        
        [resultView addSubview:textDetalView];
        [resultView addSubview:textPriceView];
            
            self.positionHeight += textDetailHeight+15;
        
         }
    
    for(int i=0;i<response.price_images.count; i++){
        NSDictionary * priceImages = [response.price_images objectAtIndex:i];
        
        NSString * resultFilename = [self resultFileName:[priceImages objectForKey:@"filename"]];
        
        
        NSLog(@"%@ %@",[priceImages objectForKey:@"width"],[priceImages objectForKey:@"height"]);
       if([[priceImages objectForKey:@"width"] isEqualToString:@"0"]  && [[priceImages objectForKey:@"height"] isEqualToString:@"0"]){
           
       }else{
        
        
        NSInteger widhtImage = [[priceImages objectForKey:@"width"] integerValue];
        NSInteger heightImage = [[priceImages objectForKey:@"height"] integerValue];
        

        
        NSString * filename = [NSString stringWithFormat:@"http://weddup.ru/files/products/%@",resultFilename];
           NSLog(@"%@",filename);
            
            NSURL *imgURL = [NSURL URLWithString:filename];
            

            
        
 
        
        CGFloat imageHeight = [textAndImageHeight
                              getHeightForImageViewWithTargetWidth:resultView.frame.size.width
                              imageWith:widhtImage
                              imageHeight:heightImage];
        
         CGFloat currentPosition= self.positionHeight;
     
        
        
        
        __block UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, currentPosition, resultView.frame.size.width, imageHeight)];
        
        
            //SingleTone с ресайз изображения
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:imgURL
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if(image){
                                        
                                        
                                        
                                        imageView.frame=CGRectMake(0, currentPosition, resultView.frame.size.width, imageHeight);
                                        
                                        CGSize targetSize = CGSizeMake(resultView.frame.size.width, imageHeight);
                                        
                                        UIImage * imageResizing = [image resizedImage:targetSize interpolationQuality:kCGInterpolationHigh];
                                        
                                        imageView.image = imageResizing;
                                       
                                        [resultView addSubview:imageView];
                                     
                                    }else{
                                        
                                    }
                                }];
        
        self.positionHeight +=imageHeight+20;
        }
        }
        
    
    
    
    CGFloat textBodyHeight =
    [textAndImageHeight getHeightForText:response.price_body
                                textWith:self.detailView.frame.size.width-20
                                withFont:[UIFont systemFontOfSize:15]];
    
    NSLog(@"%f",self.positionHeight+20);
    UITextView * priceBodyView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.positionHeight, resultView.frame.size.width-10, textBodyHeight+20)];
    
    
    priceBodyView.editable = NO;
    priceBodyView.scrollEnabled = NO;
    priceBodyView.selectable =NO;
    priceBodyView.userInteractionEnabled = NO;
    priceBodyView.font=[UIFont systemFontOfSize:15];
    priceBodyView.textColor = [UIColor blackColor];
    priceBodyView.text=response.price_body;
    self.positionHeight +=textBodyHeight+43; //Отступ от заголовка
    
    self.detailView.contentSize= CGSizeMake(self.view.frame.size.width, self.positionHeight+120);
    
    
    [resultView addSubview:priceBodyView];
    
    //[conteinerImage addSubview:imageView];
    //[resultView addSubview:conteinerImage];
    
    
    return resultView;
    
}

-(NSString*) resultFileName:(NSString *) string{
    string =
    [string stringByReplacingOccurrencesOfString:@".jpg"
                                                                      withString:@".800x800w.jpg"];
    
    string =
    [string stringByReplacingOccurrencesOfString:@".JPG"
                                                                      withString:@".800x800w.JPG"];
    return string;
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
