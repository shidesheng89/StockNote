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
//    if (self.nameOfStock.text!=nil&&self.buyNumber.text!=nil&&self.buyPrice.text!=nil&&self.numberOfStock.text!=nil) {
//        [self.delegate addStockViewController:self didFinishAddingStockData:stockdata ];
//    }else{
//        [self showAlert:@"请输入正确的值"];
//    }
    
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
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSString *newText=[theTextField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneButton.enabled=([self.nameOfStock.text length]>0&&[self.numberOfStock.text length]>0&&[self.buyNumber.text length]>0&&[self.buyPrice.text length]>0);
    NSLog(@"enabled%d",self.doneButton.enabled);
    return YES;
}
@end
