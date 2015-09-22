//
//  sellStockViewController.m
//  股票记帐本
//
//  Created by 施德胜 on 15/9/8.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import "sellStockViewController.h"
#import "stockData.h"
#import "DataModel.h"


@interface sellStockViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation sellStockViewController{
    NSInteger _mountOfBuy;
     
   
}
-(void)dismissKeyBoard{
    [self.numberOfSell resignFirstResponder];
    [self.priceOfSell resignFirstResponder];
    [self.feeOfSell resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.tableView addGestureRecognizer:tapGesture];
    self.title=self.stockdata.nameOfStock;

    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark tableView相关方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    cell.textLabel.text=self.stockdata.sellData[indexPath.row];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@  手续费：%@",self.stockdata.sellStockDate[indexPath.row],self.stockdata.sellFee[indexPath.row]];
    cell.detailTextLabel.textColor=[UIColor colorWithWhite:0 alpha:0.7];
    cell.textLabel.font=[UIFont systemFontOfSize:15];

    return cell;
}

- (NSString *)sellStockDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (IBAction)Done:(id)sender {
    
    [self.stockdata.sellPrice insertObject:self.priceOfSell.text atIndex:0];
    [self.stockdata.sellMount insertObject:self.numberOfSell.text atIndex:0];
    [self.stockdata.sellFee insertObject:self.feeOfSell.text atIndex:0];
    //计算持股数量
    NSNumber *totalSell=[self.stockdata.sellMount valueForKeyPath:@"@sum.floatValue"];
    _mountOfBuy=[self.stockdata.buyNumber integerValue];
    NSInteger MountOfHolding=_mountOfBuy-[totalSell integerValue];
    //计算单次交易盈亏数目
    float buyPriceValue=[self.stockdata.buyPrice floatValue];
    float sellPriceValue=[self.priceOfSell.text floatValue];
    float sellFee=[self.feeOfSell.text floatValue];
    NSInteger sellMOunt=[self.numberOfSell.text integerValue];
    NSString *gain=[NSString stringWithFormat:@"%.0f",(sellPriceValue-buyPriceValue)*sellMOunt-sellFee];
    if (![self isPureNumber:self.priceOfSell.text ] || ![self isPureNumber:self.numberOfSell.text]) {
        [self.stockdata.sellPrice removeObjectAtIndex:0];
        [self.stockdata.sellMount removeObjectAtIndex:0];
        [self.stockdata.sellFee removeObjectAtIndex:0];
        [self showAlert:@"请输入正确的值"];
    }else{
        if (MountOfHolding>=0) {
            //计算单只股票的盈亏
            [self.stockdata.gainOrLoseArray insertObject:gain atIndex:0];
            NSNumber *gainOrLose=[self.stockdata.gainOrLoseArray valueForKeyPath:@"@sum.floatValue"];
            self.stockdata.gainOrLose=[NSString stringWithFormat:@"%@",gainOrLose];
            
            self.stockdata.numberOfHolding=[NSString stringWithFormat:@"%ld",(long)MountOfHolding];
            NSString *selldata=[NSString stringWithFormat:@"以%@元每股卖出%@股,盈利 %@",self.priceOfSell.text,self.numberOfSell.text,gain];
            [self.stockdata.sellData insertObject:selldata atIndex:0];
            [self.stockdata.sellStockDate insertObject:[self sellStockDate] atIndex:0];
            
            [self.delegate sellStockViewController:self didFinishAddingSellStock:self.stockdata];
            [self.tableView reloadData];
            //清空文本框
            self.priceOfSell.text=@"";
            self.numberOfSell.text=@"";
            self.feeOfSell.text=@"";
            
        }else{
            [self.stockdata.sellPrice removeObjectAtIndex:0];
            [self.stockdata.sellMount removeObjectAtIndex:0];
            [self.stockdata.sellFee removeObjectAtIndex:0];
            [self showAlert:@"请输入正确的卖出数量"];
            
        }
    }
    [self dismissKeyBoard];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showAlert:(NSString *)showMessage{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:showMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

//判断是否为数字
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)isPureNumber:(NSString *)string{
    if ([self isPureFloat:string]||[self isPureFloat:string]) {
        return YES;
    }else{
        return NO;
    }
}

@end
