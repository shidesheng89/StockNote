//
//  historySellStockViewController.m
//  股票记帐本
//
//  Created by 施德胜 on 15/9/17.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import "historySellStockViewController.h"

@interface historySellStockViewController ()

@end

@implementation historySellStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.stockdata.nameOfStock;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.stockdata.sellData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier=@"cellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    //    stockData *stockdata=self.dataModel.Data[indexPath.row];
    cell.textLabel.text=self.stockdata.sellData[indexPath.row];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@  手续费：%@",self.stockdata.sellStockDate[indexPath.row],self.stockdata.sellFee[indexPath.row]];
    cell.detailTextLabel.textColor=[UIColor colorWithWhite:0 alpha:0.7];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
