//
//  SelectedStockDataModel.h
//  股票记帐本
//
//  Created by 施德胜 on 15/10/11.
//  Copyright © 2015年 施德胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedStockDataModel : NSObject

@property (strong,nonatomic) NSMutableArray *selectedStockData;

- (void)saveData;
//- (NSComparisonResult)compareName:(SelectedStockDataModel *)other;
@end
