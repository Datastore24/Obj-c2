//
//  ViewController.m
//  Lesson7HW
//
//  Created by Кирилл Ковыршин on 05.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ViewController.h"
#import "API.h"
#import "Parser.h"
#import "SingleTone.h"
#import "ParsingResponse.h"
#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Resize.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * arrayResponse; //массив данных
@property (weak, nonatomic) IBOutlet UITableView *blogTableView;

@property (assign,nonatomic) NSUInteger newsCount;
@property (assign,nonatomic) NSUInteger offset;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.newsCount = 10;
    self.offset = 0;
    
    [self.blogTableView setSeparatorColor:[UIColor purpleColor]];
   
    
    self.arrayResponse = [NSMutableArray array];
    
    
    [self getDataFromVK];
    

    
}

-(void) getDataFromVK{
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"-86601131",@"owner_id",
                             [NSNumber numberWithInteger:self.newsCount],@"count",
                             [NSNumber numberWithInteger:self.offset],@"offset",
                             @"all",@"filter",nil];
    API * api =[API new]; //создаем API
    [api getDataFromServerWithParams:params method:@"wall.get" complitionBlock:^(id response) {
        //Запуск парсера
        ParsingResponse * parsingVk =[[ParsingResponse alloc] init];
        //парсинг данных и запись в массив
        parsingVk.isRefresh = YES;
        [parsingVk parsing:response andArray:self.arrayResponse andView:self.view  andBlock:^{
            
            [self reloadTableViewWhenNewEvent]; // обновление таблицы
        }];
        
    }];
}



//Обновление таблицы
- (void)reloadTableViewWhenNewEvent {
    
    [self.blogTableView
     reloadSections:[NSIndexSet indexSetWithIndex:0]
     withRowAnimation:UITableViewRowAnimationFade];
//    Перезагрузка таблицы с
//    анимацией
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource


//Подсчет количества строк
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"%i",self.arrayResponse.count);
    return self.arrayResponse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    
   
    
    dispatch_block_t block = ^
    {
        for(UIView * view in cell.contentView.subviews){
            
            [view removeFromSuperview];
            
        }
        
    };
    
    if ([NSThread isMainThread]){
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
    
    Parser * parse = [self.arrayResponse objectAtIndex:indexPath.row];
 
    
    
    if(parse.countTextArray>2){
            [cell.contentView addSubview:[self getReadMoreView:parse.targetHeightImage+parse.targetHeightText+parse.targetHeightPhotoText+27 andIndexPath:indexPath.row]];
    }
    [cell.contentView addSubview:[self getViewForCellWithResponse:parse]];
   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Parser * parse = [self.arrayResponse objectAtIndex:indexPath.row];
    if(parse.countTextArray>2){
        NSLog(@"textphoto %f",parse.targetHeightPhotoText);
            return parse.targetHeightImage+parse.targetHeightText+parse.targetHeightPhotoText+55;
    }else{
            return parse.targetHeightImage+parse.targetHeightText+parse.targetHeightPhotoText+10;
    }
    
}

-(UIView *) getViewForCellWithResponse: (Parser *) response{

    
    UIView * resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, response.targetHeightImage+response.targetHeightText+response.targetHeightPhotoText)];
    
    UITextView * textPhotoView = [[UITextView alloc] initWithFrame:CGRectMake(10, response.targetHeightImage+10, self.view.frame.size.width-10, response.targetHeightPhotoText+10)];
    textPhotoView.editable = NO;
    textPhotoView.scrollEnabled = NO;
    textPhotoView.font=[UIFont systemFontOfSize:15];
    textPhotoView.text=response.photoText;
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, response.targetHeightImage+response.targetHeightPhotoText+10, self.view.frame.size.width-10, response.targetHeightText+10)];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.font=[UIFont systemFontOfSize:15];
    textView.text=response.text;
    
    __block UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, response.targetHeightImage)];
    
 //SingleTone с ресайз изображения
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:response.src_big
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if(image){
                                CGSize targetSize = CGSizeMake(self.view.frame.size.width, response.targetHeightImage);
                                
                                UIImage * imageResizing = [image resizedImage:targetSize interpolationQuality:kCGInterpolationHigh];
                                
                                [UIView transitionWithView:imageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                    imageView.image = imageResizing;
                                } completion:nil];
                                
                                
                               
                            }
                        }];
    
    [resultView addSubview:textView];
    [resultView addSubview:textPhotoView];
    [resultView addSubview:imageView];
    
    
    return resultView;
    
}

//получаем текст и помещаем его
-(UITextView *) getTextView: (NSString*) text height: (CGFloat) height{
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-10, height+1)];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.font=[UIFont systemFontOfSize:15];
    textView.text=text;
    
    return textView;
}
//
-(UIView *) getReadMoreView: (CGFloat) height andIndexPath: (NSInteger) indexPath{
    UIView * readMore = [[UIView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, 25)];
    
    UIButton *buttonReadMore = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, readMore.frame.size.width, readMore.frame.size.height)];
    [buttonReadMore setTitle:@"Подробнее" forState:UIControlStateNormal];
    UIImage *buttonImage = [UIImage imageNamed:@"right.png"];
    [buttonReadMore setImage:buttonImage forState:UIControlStateNormal];
   
    [buttonReadMore addTarget:self action:@selector(readMoreAction:) forControlEvents:UIControlEventTouchUpInside];
    buttonReadMore.tag=indexPath;
    [readMore addSubview:buttonReadMore];
    
    readMore.layer.backgroundColor =[UIColor lightGrayColor].CGColor;
    return readMore;
    }

-(void) readMoreAction:(UIButton *) sender {
    
    Parser * parse = [self.arrayResponse objectAtIndex:sender.tag];
    DetailViewController * detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detailViewController.detailText = parse.fullText;
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

-(void)setActivityIndicatorForCell:(Parser *) response cell: (UITableViewCell *) cell{
    if(response.targetHeightImage >0){
        UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        indicator.tag=25;
        
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }



@end
