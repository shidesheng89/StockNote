//
//  SelectedStock.m
//  股票记帐本
//
//  Created by 施德胜 on 15/10/11.
//  Copyright © 2015年 施德胜. All rights reserved.
//

#import "SelectedStock.h"

@implementation SelectedStock
- (NSComparisonResult)compareName:(SelectedStock *)other
{
    return [self.code localizedStandardCompare:other.code];
}
@end
