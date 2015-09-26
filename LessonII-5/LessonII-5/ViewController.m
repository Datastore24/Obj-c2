//
//  ViewController.m
//  LessonII-5
//
//  Created by Кирилл Ковыршин on 25.09.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ViewController.h"
#import "ClassWithBlock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [ClassWithBlock getArrayWithComplitionBlock:@"sting1" string:@"string2" block:^(NSMutableArray *array) {
        NSLog(@"%@",array);
    }];
    
    
    void (^simpleBlock) (void) = ^{
        NSLog(@"This is a block");
    };
    
    NSLog(@"Method >>>>>>>");
    
    simpleBlock();
    
    void (^blockWithParams)(NSString *) = ^ (NSString* string) {
        NSLog(@"%@",string);
    };
    
    blockWithParams(@"String");
    
    [self methodWithBlock:simpleBlock];
    
    
    
}

- (void) methodWithBlock: (void (^) (void)) block{
    
    NSLog(@"Method >>>>>>>");
    NSLog(@"Method >>>>>>>");
    NSLog(@"Method >>>>>>>");
    NSLog(@"Method >>>>>>>");
    
    block();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
