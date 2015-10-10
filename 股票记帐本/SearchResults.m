//
//  searchResults.m
//  股票记帐本
//
//  Created by 施德胜 on 15/10/8.
//  Copyright © 2015年 施德胜. All rights reserved.
//

#import "SearchResults.h"

@implementation SearchResults
- (NSComparisonResult)compareName:(SearchResults *)other
{
    return [self.stockCode localizedStandardCompare:other.stockCode];
}
@end
