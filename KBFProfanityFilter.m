//
//  KBFProfanityFilter.m
//  ProfanityFilterSample
//
//  Created by Kevin on 16/8/4.
//  Copyright © 2016年 Island of Doom Software Inc. All rights reserved.
//

#import "KBFProfanityFilter.h"

@interface KBFProfanityFilter ()

@property (nonatomic, readonly)NSDictionary *ProfanityWordDict;

@end

@implementation KBFProfanityFilter

+ (instancetype)sharedInstance
{
    static KBFProfanityFilter *s_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[self alloc] init];
    });
    
    return s_instance;
}

- (instancetype) init {
    if (self) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Profanity" ofType:@"plist"];
        _ProfanityWordDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
// Below string used to test
//        NSError *jsonError;
//        _ProfanityWordDict = [NSJSONSerialization JSONObjectWithData:[@"{\"黄\":{\"色\":{\"isEnd\":true,\"图\":{\"isEnd\":true}},\"图\":{\"片\":{\"isEnd\":true}}}}" dataUsingEncoding:NSUTF8StringEncoding]
//                                                             options:NSJSONReadingMutableContainers
//                                                               error:&jsonError];
    }
    return self;
}

- (NSString*)filteringString:(NSString*)string
{
    return [self filteringString:string withReplacementString:@"*"];
}


- (NSString*)filteringString:(NSString*)string withReplacementString:(NSString*)replacementString
{
    NSMutableString *result = [string mutableCopy];
    
    NSArray *rangesToFilter = [self rangesOfFilteredWordsInString:string];
    for (NSValue *rangeValue in rangesToFilter) {
        NSRange range = [rangeValue rangeValue];
        NSString *replacement = [@"" stringByPaddingToLength:range.length withString:replacementString startingAtIndex:0];
        [result replaceCharactersInRange:range withString:replacement];
    }
    
    return result;
}

- (int) isDict:(NSDictionary *)dict hasProfanity:(unichar*) buffer withLocation:(int) index{
    
    NSString *key = [NSString stringWithFormat:@"%C", buffer[index]];
    id obj = [dict objectForKey:key];
    if (obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            return [self isDict:(NSDictionary *)obj hasProfanity:(unichar*) buffer withLocation:index+1];
//        } else {
//            if ([dict objectForKey:@"isEnd"]) {
//                return index - 1;
//            } else {
//                return -1;
//            }
        } else {
            NSLog(@"KBFProfanityFilter Error: Should not reach here");
            assert(0);
            return -1;
        }
    } else {
//        return -1;
        if ([dict objectForKey:@"isEnd"]) {
            return index - 1;
        } else {
            return -1;
        }
    }
}

- (NSArray*)rangesOfFilteredWordsInString:(NSString*)string {
    
    NSMutableArray *result = [NSMutableArray array];
    
    NSUInteger len = [string length];
    unichar buffer[len+1];
    
    [string getCharacters:buffer range:NSMakeRange(0, len)];
    
    for(int i = 0; i < len; i++) {
        int index = [self isDict: _ProfanityWordDict hasProfanity:buffer withLocation:i];
        if ( index > 0 ) {
            // The scan location is now at the end of the word
            NSRange range = NSMakeRange(i, index - i + 1);
            [result addObject:[NSValue valueWithRange:range]];
        } else {
            
        }
    }
    return result;
}

@end
