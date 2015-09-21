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
@interface addStockViewController ()

@end

@implementation addStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加股票";
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameOfStock resignFirstResponder];
    [self.buyNumber resignFirstResponder];
    [self.buyPrice resignFirstResponder];
    [self.numberOfStock resignFirstResponder];
}
- (void)showAlert:(NSString *)showMessage{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:showMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)cancle:(id)sender {
    [self.delegate addStockViewControllerDidCancel:self];
}

- (IBAction)Done:(id)sender {
//    [self.delegate addStockViewController:self didFinishAddNameOfStock:self.nameOfStock didFinishAddNumberOfStock:self.numberOfStock didFinishAddPriceOfStock:self.priceOfStock didFinishAddBuyNumber:self.buyNumber];
    //设置时间格式
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yy年MM月dd日"];
    
    stockData *stockdata=[[stockData alloc]init];
    stockdata.nameOfStock=self.nameOfStock.text;
    stockdata.buyNumber=self.buyNumber.text;
    stockdata.buyPrice=[NSString stringWithFormat:@"%.2f",[self.buyPrice.text floatValue]];
    stockdata.stockNumber=self.numberOfStock.text;
    stockdata.buyTime=[dateFormatter stringFromDate:[NSDate date]];
//    stockdata.numberOfHolding=self.buyNumber.text;
//    stockdata.buyPriceAndNumebr=[NSString stringWithFormat:@"%@/%@",self.buyPrice.text,self.buyNumber.text];
    
    if ([self.nameOfStock.text length]>0 &&[ self.numberOfStock.text length]>0 && [self isPureNumber:self.buyNumber.text ] && [self isPureNumber:self.buyPrice.text]) {
        [self.delegate addStockViewController:self didFinishAddingStockData:stockdata ];
    }else{
        [self showAlert:@"请输入正确的值"];
    }
    
//    [self.delegate addStockViewController:self didFinishAddingStockData:stockdata ];
    
   
}



//- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
////    NSString *newText=[theTextField.text stringByReplacingCharactersInRange:range withString:string];
//  
//    self.doneButton.enabled=([self.nameOfStock.text length]>0 &&[ self.numberOfStock.text length]>0 && [self isPureNumber:self.buyNumber.text ] && [self isPureNumber:self.buyPrice.text]);
//    return YES;
//}

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
