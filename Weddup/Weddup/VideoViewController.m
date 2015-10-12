//
//  VideoViewController.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 12.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "VideoViewController.h"
#import <YTPlayerView.h>
#import "API.h"
#import "ParserVideo.h"
#import "ParsingResponseVideo.h"

@interface VideoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *videoScrollView;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;

@property(strong,nonatomic) NSMutableArray * arrayResponse;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.videoScrollView setCanCancelContentTouches:NO];
    self.videoScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.videoScrollView.clipsToBounds = YES;
    self.videoScrollView.scrollEnabled = YES;
    self.videoScrollView.pagingEnabled = NO;
    self.videoScrollView.autoresizesSubviews=YES;
    [self.videoScrollView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self getVideoFromWeddup];
   
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Получение статей
-(void) getVideoFromWeddup{
    //Передаваемые параметры
    
    API * api =[API new]; //создаем API
    [api getDataFromServerWithParams:nil method:@"action=load_video" complitionBlock:^(id response) {
        //Запуск парсера
       
        ParsingResponseVideo * parsingResponce =[[ParsingResponseVideo alloc] init];
        
        //парсинг данных и запись в массив
        
     NSMutableArray * parser = [parsingResponce parsing:response];
    [self getViewWithResponse:parser resultView:self.videoScrollView];
        
        
    }];
}



-(UIScrollView *) getViewWithResponse: (NSMutableArray *) response  resultView :(UIScrollView *) resultView{
    
    int border= 10;
    
    for (int i=0; i<response.count; i++){
        ParserVideo * parse = [response objectAtIndex:i];
        
        UIView * viewWithPlayer = [[UIView alloc] initWithFrame:CGRectMake(0, 10+border, self.videoScrollView.frame.size.width, 200)];
        YTPlayerView * playerView = [[YTPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.videoScrollView.frame.size.width, viewWithPlayer.frame.size.height)];
        
        [playerView loadWithVideoId:parse.video_id];
        [viewWithPlayer addSubview:playerView];
        
        [resultView addSubview:viewWithPlayer];
        border += 230;
        
    }
    
    resultView.contentSize= CGSizeMake(self.view.frame.size.width, border+100);
    
    
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
