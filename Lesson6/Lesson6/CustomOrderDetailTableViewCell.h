//
//  CustomOrderDetailTableViewCell.h
//  Lesson6
//
//  Created by Кирилл Ковыршин on 01.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomOrderDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemCount;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;

@end
