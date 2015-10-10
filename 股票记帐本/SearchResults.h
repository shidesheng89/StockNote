//
//  searchResults.h
//  股票记帐本
//
//  Created by 施德胜 on 15/10/8.
//  Copyright © 2015年 施德胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResults : NSObject
@property (copy, nonatomic) NSString *nameOfStock;
@property (copy, nonatomic) NSString *stockCode;
@property (copy, nonatomic) NSString *percent;
@property (copy, nonatomic) NSString *price;

- (NSComparisonResult)compareName:(SearchResults *)other;
@end
