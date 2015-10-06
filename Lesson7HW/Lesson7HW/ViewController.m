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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * arrayResponse; //массив данных
@property (weak, nonatomic) IBOutlet UITableView *blogTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.arrayResponse = [NSMutableArray array];
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"-86601131",@"owner_id",
                             [NSNumber numberWithInteger:10],@"count",
                             [NSNumber numberWithInteger:2],@"offset",
                             @"all",@"filter",nil];
    API * api =[API new]; //создаем API
    [api getDataFromServerWithParams:params method:@"wall.get" complitionBlock:^(id response) {
        //Запуск парсера
        ParsingResponse * parsingVk =[[ParsingResponse alloc] init];
        //парсинг данных и запись в массив
        
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
    
    
    return self.arrayResponse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    Parser * parse = [self.arrayResponse objectAtIndex:indexPath.row];
   NSLog(@"%f",parse.targetHeight);
    
    
    if(parse.countTextArray>2){
            [cell.contentView addSubview:[self getReadMoreView:parse.targetHeight andIndexPath:indexPath.row]];
    }
    [cell.contentView addSubview:[self getTextView:parse.text height:parse.targetHeight]];
   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Parser * parse = [self.arrayResponse objectAtIndex:indexPath.row];
    if(parse.countTextArray>2){
            return parse.targetHeight+37;
    }else{
            return parse.targetHeight;
    }
    
}



-(UITextView *) getTextView: (NSString*) text height: (CGFloat) height{
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-10, height+1)];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.font=[UIFont systemFontOfSize:15];
    textView.text=text;
    
    return textView;
}
-(UIView *) getReadMoreView: (CGFloat) height andIndexPath: (NSInteger) indexPath{
    UIView * readMore = [[UIView alloc] initWithFrame:CGRectMake(0, height+1, self.view.frame.size.width, 25)];
    
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }



@end
