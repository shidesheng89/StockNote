//
//  historySellStockViewController.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/17.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockData.h"
@interface HistorySellStockViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)StockData *stockdata;
@end
