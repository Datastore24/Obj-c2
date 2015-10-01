//
//  CustomOrdersTableViewCell.h
//  Lesson6
//
//  Created by Кирилл Ковыршин on 01.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomOrdersTableViewCell : UITableViewCell

//Данные строки основого экрана
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *summLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
