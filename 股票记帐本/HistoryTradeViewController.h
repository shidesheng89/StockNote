//
//  historyTradeViewController.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/16.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryDataModel.h"
#import "StockData.h"


@interface HistoryTradeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>

@property (strong, nonatomic) HistoryDataModel *historyDataModel;

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
//@property (strong, nonatomic) stockData *stockData;
@property (weak, nonatomic) IBOutlet UILabel *totalGain;



@end
