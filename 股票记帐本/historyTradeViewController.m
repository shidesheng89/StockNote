//
//  historyTradeViewController.m
//  股票记帐本
//
//  Created by 施德胜 on 15/9/16.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import "historyTradeViewController.h"
#import "historyStockTradeTableViewCell.h"

#import "historySellStockViewController.h"

static NSString *cellIdentifier=@"stockTradeTableViewCell";

@interface historyTradeViewController ()
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchData;

@end

@implementation historyTradeViewController

//点击该界面时刷新数据
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.historyDataModel=[[historyDataModel alloc]init];
    [self.historyTableView reloadData];
    [self setTotalGainSignAndColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView=(id)[self.view viewWithTag:100];
    tableView.rowHeight=80;
    UINib *nib=[UINib nibWithNibName:@"historyStockTradeTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    
    
    
    //初始化搜索栏
    _searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater=self;
    _searchController.dimsBackgroundDuringPresentation=NO;
    _searchController.hidesNavigationBarDuringPresentation=NO;
    _searchController.searchBar.frame=CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 40);
//    _searchController.searchBar.barTintColor=[UIColor colorWithRed:0/255.0 green:127/255.0 blue:236/255.0 alpha:1.0f];
    self.historyTableView.tableHeaderView=self.searchController.searchBar;
    _searchController.searchBar.placeholder=@"-输入股票名称-";
    
    self.title=@"历 史";
    
//    self.historyDataModel=[[historyDataModel alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.searchData count];
    }else{
        return [self.historyDataModel.historyData count];
    }
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [self.searchController.searchBar text];
    if (self.searchData!= nil) {
        [self.searchData removeAllObjects];
    }
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    //过滤数据
    //    self.searchData= [NSMutableArray arrayWithArray:[self.dataModel.Data filteredArrayUsingPredicate:predicate]];
    self.searchData=[[NSMutableArray alloc]initWithCapacity:20];
    for (NSUInteger i=0;i<[self.historyDataModel.historyData count];i++) {
        stockData *stockdata=self.historyDataModel.historyData[i];
        if ([stockdata.nameOfStock containsString:searchString]) {
            [self.searchData addObject:self.historyDataModel.historyData[i]];
        }
    }
    [self.historyTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    historyStockTradeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    stockData *stockdata;
    if (self.searchController.active) {
        stockdata=self.searchData[indexPath.row];
    }else{
        stockdata=self.historyDataModel.historyData[indexPath.row];
    }
    cell.nameOfStock.text=stockdata.nameOfStock;
    cell.buyPriceAndNumebr.text=[NSString stringWithFormat:@"%@/%@",stockdata.buyPrice,stockdata.buyNumber];
    cell.timeOfDeal.text=stockdata.buyTime;
    cell.gainOrLose.text=stockdata.gainOrLose;
    cell.stockNumer.text=stockdata.stockNumber;
    //设置单只股票历史收益
    float ValueOfGainOrLose=[stockdata.gainOrLose floatValue]-[stockdata.buyFee floatValue];
    float ValueOfStock=[stockdata.buyPrice floatValue]*[stockdata.buyNumber integerValue];
    float percentOfGainOrLose=ValueOfGainOrLose/ValueOfStock*100;
    if (ValueOfGainOrLose>0) {
        cell.gainOrLose.text=[NSString stringWithFormat:@"+%.0f",ValueOfGainOrLose];
        cell.gainOrLose.textColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        cell.percentOfGainOrLose.text=[NSString stringWithFormat:@"+%.2f%%",percentOfGainOrLose];
        cell.percentOfGainOrLose.textColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        
    }else if (ValueOfGainOrLose==0){
        cell.gainOrLose.text=[NSString stringWithFormat:@"%.0f",ValueOfGainOrLose];
        cell.gainOrLose.textColor=[UIColor colorWithWhite:0 alpha:1];
        cell.percentOfGainOrLose.text=[NSString stringWithFormat:@"%.2f%%",percentOfGainOrLose];
        cell.percentOfGainOrLose.textColor=[UIColor colorWithWhite:0 alpha:1];
    }else if (ValueOfGainOrLose<0){
        cell.gainOrLose.text=[NSString stringWithFormat:@"%.0f",ValueOfGainOrLose];
        cell.gainOrLose.textColor=[UIColor colorWithRed:0 green:1 blue:0 alpha:1];
        cell.percentOfGainOrLose.text=[NSString stringWithFormat:@"%.2f%%",percentOfGainOrLose];
        cell.percentOfGainOrLose.textColor=[UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    stockData *stockdata=self.historyDataModel.historyData[indexPath.row];
    [self performSegueWithIdentifier:@"sellStockHistory" sender:stockdata];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.historyDataModel.historyData removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths=@[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.historyDataModel saveHistoryData];
    [self setTotalGainSignAndColor];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"sellStockHistory"]) {
        historySellStockViewController *controller=segue.destinationViewController;
        controller.stockdata=sender;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark 自定义方法
//总盈利设置
- (float)computeTotalGain:(NSMutableArray*)dataArray{
    float _totalGainOrLoseValue = 0.0;
    for (NSUInteger i=0; i<[dataArray count]; i++) {
        stockData *stockdata=dataArray[i];
        _totalGainOrLoseValue=_totalGainOrLoseValue+[stockdata.gainOrLose floatValue]-[stockdata.buyFee floatValue];
    }
    return _totalGainOrLoseValue;
}


- (void)setTotalGainSignAndColor{
    self.totalGain.text=@"0";
    self.totalGain.textColor=[UIColor colorWithWhite:0 alpha:1];
    float totalGainOrLoseValue=[self computeTotalGain:self.historyDataModel.historyData];
    if (totalGainOrLoseValue>0) {
        self.totalGain.text=[NSString stringWithFormat:@"+%.0f",totalGainOrLoseValue];
        self.totalGain.textColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    }else if (totalGainOrLoseValue==0){
        self.totalGain.text=[NSString stringWithFormat:@"%.0f",totalGainOrLoseValue];
        self.totalGain.textColor=[UIColor colorWithWhite:0 alpha:1];
    }else if (totalGainOrLoseValue<0){
        self.totalGain.text=[NSString stringWithFormat:@"%.0f",totalGainOrLoseValue];
        self.totalGain.textColor=[UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    }
}

@end
