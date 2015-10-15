//
//  SearchResultTableViewCell.h
//  股票记帐本
//
//  Created by 施德胜 on 15/10/11.
//  Copyright © 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedStockViewController.h"

@interface SearchResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (strong, nonatomic)SelectedStockViewController *StockViewController;

@property (weak, nonatomic) IBOutlet UIButton *addSelectedStockButton;

@end
