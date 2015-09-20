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
    stockdata.buyPrice=self.buyPrice.text;
    stockdata.buyTime=[dateFormatter stringFromDate:[NSDate date]];
//    stockdata.numberOfHolding=self.buyNumber.text;
//    stockdata.buyPriceAndNumebr=[NSString stringWithFormat:@"%@/%@",self.buyPrice.text,self.buyNumber.text];
    [self.delegate addStockViewController:self didFinishAddingStockData:stockdata ];
   
}

//@property (copy, nonatomic) NSString *nameOfStock;
//@property (copy, nonatomic) NSString *timeOfDeal;
//@property (copy, nonatomic) NSString *buyPriceAndNumebr;
//@property (copy, nonatomic) NSString *numberOfHolding;
//@property (copy, nonatomic) NSString *gainOrLose;


//Checklist *checklist = [[Checklist alloc] init];
//checklist.name = self.textField.text;
//checklist.iconName = _iconName;
//
//[self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
@end
