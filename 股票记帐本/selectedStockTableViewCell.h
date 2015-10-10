//
//  selectedStockTableViewCell.h
//  股票记帐本
//
//  Created by 施德胜 on 15/10/6.
//  Copyright © 2015年 施德胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectedStockTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *percent;

@end
