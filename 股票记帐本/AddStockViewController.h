//
//  addStockViewController.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/2.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddStockViewController;//只是通知代理协议addStockViewController对象的存在，与＃import不同
@class StockTradeTableViewCell;//只是通知代理协议addStockViewController对象的存在，与＃import不同
@class StockData;
@class SelectedStock;

@protocol addStockViewControllerDelegate <NSObject>

- (void)addStockViewControllerDidCancel:(AddStockViewController *)controller;
- (void)addStockViewController:(AddStockViewController *)controller didFinishAddingStockData:(StockData *)stockdata;

@end

@interface AddStockViewController : UIViewController

@property (weak, nonatomic)id<addStockViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameOfStock;
@property (weak, nonatomic) IBOutlet UITextField *numberOfStock;
@property (weak, nonatomic) IBOutlet UITextField *buyPrice;
@property (weak, nonatomic) IBOutlet UITextField *buyNumber;
@property (weak, nonatomic) NSString *buyTime;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *buyFee;
@property (strong, nonatomic) SelectedStock *selectedStock;

- (IBAction)cancle:(id)sender;
- (IBAction)Done:(id)sender;


@end
