//
//  stockTradeTableViewCell.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/1.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface stockTradeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameOfStock;
@property (weak, nonatomic) IBOutlet UILabel *timeOfDeal;

@property (weak, nonatomic) IBOutlet UILabel *buyPriceAndNumebr;

@property (weak, nonatomic) IBOutlet UILabel *numberOfHolding;
@property (weak, nonatomic) IBOutlet UILabel *gainOrLose;
@property (weak, nonatomic) IBOutlet UILabel *percentOfGainOrLose;



@end
