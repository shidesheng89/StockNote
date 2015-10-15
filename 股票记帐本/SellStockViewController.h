//
//  sellStockViewController.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/8.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SellStockViewController;
@class StockData;
@class DataModel;

@protocol sellStockViewControllerDelegate <NSObject>

- (void)sellStockViewController:(SellStockViewController *)controller didFinishAddingSellStock:(StockData*)stockdata;

@end

@interface SellStockViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


- (IBAction)Done:(id)sender;

@property(weak,nonatomic)id<sellStockViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *numberOfSell;
@property (weak, nonatomic) IBOutlet UITextField *priceOfSell;
@property (weak, nonatomic) IBOutlet UITextField *feeOfSell;
@property (strong,nonatomic) StockData *stockdata;
@property (strong,nonatomic) DataModel *dataModel;
@end
