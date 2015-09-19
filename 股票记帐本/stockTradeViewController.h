//
//  stockTradeViewController.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/1.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addStockViewController.h"
#import "stockData.h"
#import "sellStockViewController.h"
#import "DataModel.h"
#import "historyDataModel.h"
#import "historyTradeViewController.h"

@interface stockTradeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,addStockViewControllerDelegate,sellStockViewControllerDelegate,UISearchDisplayDelegate>

//@property (nonatomic,strong) stockData *stockData;

@property (strong, nonatomic) DataModel *dataModel;
@property (strong, nonatomic) historyDataModel *historyDataModel;
@property (strong, nonatomic) historyTradeViewController *historyTradeViewController;
@property (weak, nonatomic) IBOutlet UILabel *totalGain;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
