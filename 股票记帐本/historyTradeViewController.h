//
//  historyTradeViewController.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/16.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "historyDataModel.h"


@interface historyTradeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) historyDataModel *historyDataModel;

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;



@end
