//
//  sellStockViewController.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/8.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class sellStockViewController;
@class stockData;
@class DataModel;

@protocol sellStockViewControllerDelegate <NSObject>


- (void)sellStockViewController:(sellStockViewController *)controller didFinishAddingSellStock:(stockData*)stockdata;

//- (void)didFinishComputingTheMountOfSelling:(NSString *)numberOfSell;

@end

@interface sellStockViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


- (IBAction)Done:(id)sender;

@property(weak,nonatomic)id<sellStockViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *numberOfSell;
@property (weak, nonatomic) IBOutlet UITextField *priceOfSell;
//@property (strong,nonatomic) NSMutableArray *sellData;
//@property (strong,nonatomic) sellData *selldata;
@property (strong,nonatomic) stockData *stockdata;
@property (strong,nonatomic) DataModel *dataModel;
@end
