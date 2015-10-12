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
    return [self.code localizedStandardCompare:other.code];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    //加载
    if ((self=[super init])) {
        self.name=[aDecoder decodeObjectForKey:@"name"];
        self.code=[aDecoder decodeObjectForKey:@"code"];
        self.percent=[aDecoder decodeObjectForKey:@"percent"];
        self.price=[aDecoder decodeObjectForKey:@"price"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    //保存
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.percent forKey:@"percent"];
    [aCoder encodeObject:self.price forKey:@"price"];
 
}
@end
