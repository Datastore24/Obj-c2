//
//  ParserMethod.m
//  Weddup
//
//  Created by Кирилл Ковыршин on 10.10.15.
//  Copyright © 2015 datastore24. All rights reserved.
//

#import "ParserMethod.h"

@implementation ParserMethod
-(NSString *) stringByImage: (NSString*) string {
    NSRange r;
    string =
    [string stringByReplacingOccurrencesOfString:@"</p><p>"
                                      withString:@"\n\n"];
    
    
    string =
    [string stringByReplacingOccurrencesOfString:@"</em>"
                                      withString:@"\n\n"];
    string =
    [string stringByReplacingOccurrencesOfString:@"<br>"
                                      withString:@"\n"];
    
    string =
    [string stringByReplacingOccurrencesOfString:@"</h2>"
                                      withString:@"\n\n"];
    
    string =
    [string stringByReplacingOccurrencesOfString:@"&nbsp;"
                                      withString:@" "];
    
    string =
    [string stringByReplacingOccurrencesOfString:@"&ndash;"
                                      withString:@"-"];
    
    string =
    [string stringByReplacingOccurrencesOfString:@"&laquo;"
                                      withString:@"\""];
    string =
    [string stringByReplacingOccurrencesOfString:@"&raquo;"
                                      withString:@"\""];
    
    string =
    [string stringByReplacingOccurrencesOfString:@"&ldquo;"
                                      withString:@"\""];
    string =
    [string stringByReplacingOccurrencesOfString:@"&rdquo;"
                                      withString:@"\""];
    
    string =
    [string stringByReplacingOccurrencesOfString:@"&hellip;"
                                      withString:@"..."];
    
    
    
    
    
    int i=0;
    
    while ((r = [string rangeOfString:@"<img[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        NSString * result_image = [NSString stringWithFormat:@"[SEP][IMAGE_%i][SEP]",i];
        string = [string stringByReplacingCharactersInRange:r withString:result_image];
        i++;
    }
    
    
    return string;
}

-(NSString *) stringByStrippingHTML: (NSString*) string {
    NSRange r;
    string =
    [string stringByReplacingOccurrencesOfString:@"<br>"
                                      withString:@"\n"];
    string =
    [string stringByReplacingOccurrencesOfString:@"</em>"
                                      withString:@"\n\n"];
    
    string =
    [string stringByReplacingOccurrencesOfString:@"</h2>"
                                      withString:@"\n\n"];
    
    string =
    [string stringByReplacingOccurrencesOfString:@"&nbsp;"
                                      withString:@" "];
    
    string =
    [string stringByReplacingOccurrencesOfString:@"&ndash;"
                                      withString:@"-"];
    
    
    
    string =
    [string stringByReplacingOccurrencesOfString:@"&ldquo;"
                                      withString:@"\""];
    string =
    [string stringByReplacingOccurrencesOfString:@"&rdquo;"
                                      withString:@"\""];
    string =
    [string stringByReplacingOccurrencesOfString:@"&laquo;"
                                      withString:@"\""];
    string =
    [string stringByReplacingOccurrencesOfString:@"&raquo;"
                                      withString:@"\""];
    
    
    
    
    
    while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        string = [string stringByReplacingCharactersInRange:r withString:@""];
    return string;
}

-(NSMutableArray *) getImageWithArray: (NSString *) string{
    
    NSError *error = NULL;
    NSMutableArray * mArray =[[NSMutableArray alloc] init];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"]\\s[\\s\\S]*?width\\s*?=\\s*?['\"](.*?)['\"]\\s[\\s\\S]*?height\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    __block NSString * img;
    __block NSString * width;
    __block NSString * height;
    
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, [string length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             img = [string substringWithRange:[result rangeAtIndex:2]];
                             width = [string substringWithRange:[result rangeAtIndex:3]];
                             height = [string substringWithRange:[result rangeAtIndex:4]];
                             NSMutableDictionary * array = [[NSMutableDictionary alloc] init];
                             [array setObject:img forKey:@"img"];
                             [array setObject:width forKey:@"width"];
                             [array setObject:height forKey:@"height"];
                             
                             [mArray addObject:array];
                             
                         }];
    return mArray;
}

-(NSMutableDictionary *) getImageWithDictionary: (NSString *) string{
    
    NSError *error = NULL;
    NSMutableDictionary * array = [[NSMutableDictionary alloc] init];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"]\\s[\\s\\S]*?width\\s*?=\\s*?['\"](.*?)['\"]\\s[\\s\\S]*?height\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    __block NSString * img;
    __block NSString * width;
    __block NSString * height;
    
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, [string length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             img = [string substringWithRange:[result rangeAtIndex:2]];
                            
                             width = [string substringWithRange:[result rangeAtIndex:3]];
                             height = [string substringWithRange:[result rangeAtIndex:4]];
                             
                             [array setObject:img forKey:@"img"];
                             [array setObject:width forKey:@"width"];
                             [array setObject:height forKey:@"height"];
                             
                             
                         }];
    return array;
}


-(NSString *) getImage: (NSString *) string{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    __block NSString * img;
    
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, [string length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             img = [string substringWithRange:[result rangeAtIndex:2]];
                             
                             
                         }];
    return img;
}

//Обрезка текста
- (NSString *)trancateTextField:(NSString *)text andcount:(NSInteger)count {
    //Обрезаем до 2 предложение
    NSArray *array = [text componentsSeparatedByString:@"."];
    NSString *result;
    if (array.count > 3) {
        
        result = [[text componentsSeparatedByString:[array objectAtIndex:count]] firstObject];
        
    } else {
        
        result = text;
        
    }
    
    return result;
    //
}

//Счетчик предложений
- (NSInteger)countTextField:(NSString *)text {
    NSArray *array = [text componentsSeparatedByString:@"."];
    return array.count;
}

@end
