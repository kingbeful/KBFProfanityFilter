//
//  KBFProfanityFilter.h
//  ProfanityFilterSample
//
//  Created by Kevin on 16/8/4.
//  Copyright © 2016年 Island of Doom Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBFProfanityFilter : NSObject

/**
 Returns a singleton instance
 */
+ (instancetype)sharedInstance;

/**
 Returns a string with offending words replaced by "∗"
 */
- (NSString*)filteringString:(NSString*)string;

/**
 Returns a string with offending words replaced by the string you pass in (repeated to fit)
 */
- (NSString*)filteringString:(NSString*)string withReplacementString:(NSString*)replacementString;

@end
