//
//  ParserVideo.h
//  Weddup
//
//  Created by Кирилл Ковыршин on 12.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Motis/Motis.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ParserVideo : NSObject
@property (strong,nonatomic) NSString * video_name;
@property (strong,nonatomic) NSString * video_id;


@property (assign,nonatomic) CGFloat targetHeightText;
@end
