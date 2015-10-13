//
//  addStockViewController.m
//  股票记帐本
//
//  Created by 施德胜 on 15/9/2.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import "addStockViewController.h"
#import "stockTradeTableViewCell.h"
#import "stockData.h"
#import "SelectedStock.h"

@interface addStockViewController ()


@end

@implementation addStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加股票";
//    if (self.selectedStock!=nil) {
        self.nameOfStock.text=self.selectedStock.name;
        self.numberOfStock.text=self.selectedStock.code;
    NSLog(@"elf.selectedStock.name%@",self.selectedStock.name);
    
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameOfStock resignFirstResponder];
    [self.buyNumber resignFirstResponder];
    [self.buyPrice resignFirstResponder];
    [self.numberOfStock resignFirstResponder];
    [self.buyFee resignFirstResponder];
}
- (void)showAlert:(NSString *)showMessage{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:showMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)cancle:(id)sender {
    [self.delegate addStockViewControllerDidCancel:self];
}

- (IBAction)Done:(id)sender {
    //设置时间格式
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yy年MM月dd日"];
    
    stockData *stockdata=[[stockData alloc]init];
    stockdata.nameOfStock=self.nameOfStock.text;
    stockdata.buyNumber=self.buyNumber.text;
    stockdata.buyFee=self.buyFee.text;
    stockdata.buyPrice=[NSString stringWithFormat:@"%.2f",[self.buyPrice.text floatValue]];
    stockdata.stockNumber=self.numberOfStock.text;
    stockdata.buyTime=[dateFormatter stringFromDate:[NSDate date]];
    
    if ([self.nameOfStock.text length]>0 &&[ self.numberOfStock.text length]>0 && [self isPureNumber:self.buyNumber.text ] && [self isPureNumber:self.buyPrice.text] && [self isPureNumber:self.buyFee.text]) {
        [self.delegate addStockViewController:self didFinishAddingStockData:stockdata ];
    }else{
        [self showAlert:@"请输入正确的值"];
    }
    
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
