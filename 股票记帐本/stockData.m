//
//  stockData.m
//  股票记帐本
//
//  Created by 施德胜 on 15/9/2.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import "stockData.h"

@implementation stockData

- (id)init{
    //当用户添加一个新的stockdata到应用中时会调用常规init方法
    if ((self=[super init])) {
//        self.nameOfStock=[[NSMutableArray alloc]initWithCapacity:20];
//        self.timeOfDeal=[[NSMutableArray alloc]initWithCapacity:20];
//        self.buyPriceAndNumebr=[[NSMutableArray alloc]initWithCapacity:20];
//        self.numberOfHolding=[[NSMutableArray alloc]initWithCapacity:20];
//        self.gainOrLose=[[NSMutableArray alloc]initWithCapacity:20];

//        
//        self.stockDataDirectionary=[[NSMutableDictionary alloc] initWithCapacity:100];
        self.sellData=[[NSMutableArray alloc]initWithCapacity:20];
        self.sellMount=[[NSMutableArray alloc]initWithCapacity:20];
        self.sellPrice=[[NSMutableArray alloc]initWithCapacity:20];
        self.gainOrLoseArray=[[NSMutableArray alloc]initWithCapacity:20];
        self.sellStockDate=[[NSMutableArray alloc]initWithCapacity:20];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    //加载
    if ((self=[super init])) {
        self.sellData=[aDecoder decodeObjectForKey:@"SellData"];
        self.nameOfStock=[aDecoder decodeObjectForKey:@"nameOfStock"];
        self.timeOfDeal=[aDecoder decodeObjectForKey:@"timeOfDeal"];
        self.buyNumber=[aDecoder decodeObjectForKey:@"buyNumber"];
        self.buyPrice=[aDecoder decodeObjectForKey:@"buyPrice"];
        self.numberOfHolding=[aDecoder decodeObjectForKey:@"numberOfHolding"];
        self.gainOrLose=[aDecoder decodeObjectForKey:@"gainOrLose"];
        self.buyTime=[aDecoder decodeObjectForKey:@"buyTime"];
        self.sellPrice=[aDecoder decodeObjectForKey:@"sellPrice"];
        self.sellMount=[aDecoder decodeObjectForKey:@"sellMount"];
        self.gainOrLoseArray=[aDecoder decodeObjectForKey:@"gainOrLoseArray"];
        self.totalGain=[aDecoder decodeObjectForKey:@"totalGain"];
        self.sellStockDate=[aDecoder decodeObjectForKey:@"sellStockDate"];
        self.stockNumber=[aDecoder decodeObjectForKey:@"stockNumber"];
        
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    //保存
    [aCoder encodeObject:self.sellData forKey:@"SellData"];
    [aCoder encodeObject:self.nameOfStock forKey:@"nameOfStock"];
    [aCoder encodeObject:self.timeOfDeal forKey:@"timeOfDeal"];
    [aCoder encodeObject:self.buyPrice forKey:@"buyPrice"];
    [aCoder encodeObject:self.buyNumber forKey:@"buyNumber"];
    [aCoder encodeObject:self.numberOfHolding forKey:@"numberOfHolding"];
    [aCoder encodeObject:self.gainOrLose forKey:@"gainOrLose"];
    [aCoder encodeObject:self.buyTime forKey:@"buyTime"];
    [aCoder encodeObject:self.sellPrice forKey:@"sellPrice"];
    [aCoder encodeObject:self.sellMount forKey:@"sellMount"];
    [aCoder encodeObject:self.gainOrLoseArray forKey:@"gainOrLoseArray"];
    [aCoder encodeObject:self.totalGain forKey:@"totalGain"];
    [aCoder encodeObject:self.sellStockDate forKey:@"sellStockDate"];
    [aCoder encodeObject:self.stockNumber forKey:@"stockNumber"];
}


@end
