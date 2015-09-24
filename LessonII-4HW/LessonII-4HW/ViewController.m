//
//  ViewController.m
//  LessonII-4HW
//
//  Created by Кирилл Ковыршин on 24.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countDefault;
@property (weak, nonatomic) IBOutlet UILabel *countThousands;
@property (strong, nonatomic) NSString * countI;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //Значения по умолчанию
    self.countDefault.text = @"0";
    self.countThousands.text = @"0";
    //
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        [self makeCount];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Создаем большой массив данных
- (void) makeCount{
    //Очередь потоков
    @synchronized(self) {

        int countThousands=0;
        for(int i=0; i<=10000; i++){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countDefault.text =[NSString stringWithFormat:@"%i",i];
            });
            
            if(i%1000 == 0){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.countThousands.text =[NSString stringWithFormat:@"%i",countThousands];
                });
                countThousands++;
            }
        
            NSLog(@"%i",i);
    
        }
        
    }
}




@end
