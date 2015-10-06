//
//  DetailViewController.m
//  Lesson7HW
//
//  Created by Кирилл Ковыршин on 06.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()



@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 90, self.view.frame.size.width-10, self.view.frame.size.height-95)];
    textView.editable = NO;
    textView.scrollEnabled = YES;
    textView.font=[UIFont systemFontOfSize:15];
    textView.text=self.detailText;
    
    [self.view addSubview:textView];

    // Do any additional setup after loading the view.
}
- (IBAction)backAction:(id)sender {
    DetailViewController *back = [self.storyboard instantiateViewControllerWithIdentifier:@"main"];
    [self.navigationController pushViewController:back animated:NO];
    [UIView transitionWithView:self.navigationController.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft     animations:nil completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
