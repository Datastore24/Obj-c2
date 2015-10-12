//
//  DetailNewsViewController.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 09.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "DetailNewsViewController.h"
#import "ContactViewController.h"
#import "PriceViewController.h"

#import "ParsingResponseArticle.h"
#import "ParserArticles.h"
#import "SingleTone.h"
#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения
#import "UIImage+Resize.h"//Ресайз изображения
#import "ParseDate.h"
#import "TextAndImageHeight.h"
#import "BBlock.h"


@interface DetailNewsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *detailView;
@property (assign,nonatomic) CGFloat positionHeight;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;


@end

@implementation DetailNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Меню
    [self.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.newsButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.contactButton addTarget:self action:@selector(goContactRight) forControlEvents:UIControlEventTouchUpInside];
    [self.priceButton addTarget:self action:@selector(goPriceRight) forControlEvents:UIControlEventTouchUpInside];
    
    //
    NSInteger index = [[SingleTone sharedManager] newsArticleId];
    ParserArticles * parser = [self.arrayWithData objectAtIndex:index];
    
    self.positionHeight = 0;
    [self.detailView setCanCancelContentTouches:NO];
    self.detailView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.detailView.clipsToBounds = YES;
    self.detailView.scrollEnabled = YES;
    self.detailView.pagingEnabled = NO;
    self.detailView.autoresizesSubviews=YES;
    [self.detailView setContentMode:UIViewContentModeScaleAspectFit];

    [self getViewWithResponse:parser resultView:self.detailView];
 
    // Do any additional setup after loading the view.
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


-(UIScrollView *) getViewWithResponse: (ParserArticles *) response  resultView :(UIScrollView *) resultView{
    
    UILabel * dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-130, 8, 100, 20)];
    dateLabel.textAlignment = NSTextAlignmentRight;
    
    ParseDate * parseDate =[[ParseDate alloc] init];
    TextAndImageHeight * textAndImageHeight = [[TextAndImageHeight alloc] init];
    
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
    
    CGFloat textHeight =
    [textAndImageHeight getHeightForText:response.article_name
                                textWith:self.detailView.frame.size.width-20
                                withFont:[UIFont systemFontOfSize:15]];
    
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 33, resultView.frame.size.width-10, textHeight+20)];
    
    
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.selectable =NO;
    textView.userInteractionEnabled = NO;
    textView.font=[UIFont systemFontOfSize:15];
    textView.textColor = [UIColor purpleColor];
    textView.text=response.article_name;
    self.positionHeight +=textHeight+43; //Отступ от заголовка
 
    
    
    for(int i=0;i<response.article_full_text.count; i++){
        NSString * detailText = [response.article_full_text objectAtIndex:i];
        
        if([detailText isEqual:@""]){
            
        }else if([detailText rangeOfString:@"[IMAGE_"].location == NSNotFound  ){
            
            CGFloat textDetailHeight =
            [textAndImageHeight getHeightForText:detailText
                                        textWith:self.detailView.frame.size.width-40
                                        withFont:[UIFont systemFontOfSize:15]];
            
                textDetailHeight+=20;
            
            
             UITextView * textDetalView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.positionHeight, resultView.frame.size.width-10, textDetailHeight)];
            
            textDetalView.editable = NO;
            textDetalView.scrollEnabled = NO;
            textDetalView.selectable =NO;
            textDetalView.userInteractionEnabled = NO;
            textDetalView.font=[UIFont systemFontOfSize:15];
            textDetalView.textColor = [UIColor blackColor];
            textDetalView.text=detailText;
            
            
            [resultView addSubview:textDetalView];
            
            self.positionHeight += textDetailHeight+15;
            
        }else{
           
             NSString * articleId = [detailText stringByReplacingOccurrencesOfString:@"[IMAGE_" withString:@""];
              articleId = [articleId stringByReplacingOccurrencesOfString:@"]" withString:@""];

            
            
            NSInteger finishArticleId = [articleId integerValue];
            
            
            NSMutableArray * arrayPhoto = response.article_array_photo;
            
            
            NSDictionary * dictPhoto = [arrayPhoto objectAtIndex:finishArticleId];
       

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
            
            
        }
             
        
    }
    self.detailView.contentSize= CGSizeMake(self.view.frame.size.width, self.positionHeight+120);
    
    
    [resultView addSubview:dateLabel];
    [resultView addSubview:textView];
   
    //[conteinerImage addSubview:imageView];
    //[resultView addSubview:conteinerImage];
    
    
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
