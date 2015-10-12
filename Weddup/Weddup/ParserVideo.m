//
//  ParserVideo.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 12.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ParserVideo.h"

@implementation ParserVideo
+ (NSDictionary *)mts_mapping {
    return @{
             @"name" : mts_key(video_name),
             @"video_link" : mts_key(video_id),
                        
             };
}
@end
