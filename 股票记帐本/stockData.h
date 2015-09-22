//
//  stockData.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/2.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface stockData : NSObject<NSCoding>

@property (copy, nonatomic) NSString *nameOfStock;
@property (copy, nonatomic) NSString *timeOfDeal;
@property (copy, nonatomic) NSString *buyNumber;
@property (copy, nonatomic) NSString *buyPrice;
@property (copy, nonatomic) NSString *numberOfHolding;
@property (copy, nonatomic) NSString *gainOrLose;
@property (copy, nonatomic) NSString *buyTime;
@property (copy, nonatomic) NSString *stockNumber;
@property (strong, nonatomic) NSString *totalGain;
@property (strong, nonatomic) NSString *buyFee;
@property (strong, nonatomic) NSMutableArray *sellData;
@property (strong, nonatomic) NSMutableArray *sellPrice;
@property (strong, nonatomic) NSMutableArray *sellMount;
@property (strong, nonatomic) NSMutableArray *gainOrLoseArray;
@property (strong, nonatomic) NSMutableArray *sellStockDate;
@property (strong, nonatomic) NSMutableArray *sellFee;



@end
