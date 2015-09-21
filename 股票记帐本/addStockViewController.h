//
//  addStockViewController.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/2.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class addStockViewController;//只是通知代理协议addStockViewController对象的存在，与＃import不同
@class stockTradeTableViewCell;//只是通知代理协议addStockViewController对象的存在，与＃import不同
@class stockData;

@protocol addStockViewControllerDelegate <NSObject>

- (void)addStockViewControllerDidCancel:(addStockViewController *)controller;
//- (void)addStockViewController:(addStockViewController *)controller didFinishAddNameOfStock:(UITextField *)nameOfStock didFinishAddNumberOfStock:(UITextField *)NumberOfStock didFinishAddPriceOfStock:(UITextField *)priceOfStock didFinishAddBuyNumber:(UITextField *)buyNumberk;

- (void)addStockViewController:(addStockViewController *)controller didFinishAddingStockData:(stockData *)stockdata;
@end

@interface addStockViewController : UIViewController

@property (weak, nonatomic)id<addStockViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameOfStock;
@property (weak, nonatomic) IBOutlet UITextField *numberOfStock;
@property (weak, nonatomic) IBOutlet UITextField *buyPrice;
@property (weak, nonatomic) IBOutlet UITextField *buyNumber;
@property (weak, nonatomic) NSString *buyTime;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)cancle:(id)sender;
- (IBAction)Done:(id)sender;


@end
