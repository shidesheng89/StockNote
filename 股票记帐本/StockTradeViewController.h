//
//  stockTradeViewController.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/1.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddStockViewController.h"

#import "SellStockViewController.h"
#import "DataModel.h"
#import "HistoryDataModel.h"
#import "HistoryTradeViewController.h"

@interface StockTradeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,addStockViewControllerDelegate,sellStockViewControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating>

@property (strong, nonatomic) DataModel *dataModel;
@property (strong, nonatomic) HistoryDataModel *historyDataModel;
@property (strong, nonatomic) HistoryTradeViewController *historyTradeViewController;
@property (weak, nonatomic) IBOutlet UILabel *totalGain;

@end
