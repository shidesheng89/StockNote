//
//  historyTradeViewController.m
//  股票记帐本
//
//  Created by 施德胜 on 15/9/16.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import "historyTradeViewController.h"
#import "stockTradeTableViewCell.h"
#import "stockData.h"
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
    [self.historyTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView=(id)[self.view viewWithTag:100];
    tableView.rowHeight=80;
    UINib *nib=[UINib nibWithNibName:@"stockTradeTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    self.historyDataModel=[[historyDataModel alloc]init];
    
    //初始化搜索栏
    _searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater=self;
    _searchController.dimsBackgroundDuringPresentation=NO;
    _searchController.hidesNavigationBarDuringPresentation=NO;
    _searchController.searchBar.frame=CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 40);
    self.historyTableView.tableHeaderView=self.searchController.searchBar;
    
//    self.historyDataModel=[[historyDataModel alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"%lu",(unsigned long)[self.historyDataModel.historyData count]);
    if (self.searchController.active) {
        return [self.searchData count];
    }else{
        return [self.historyDataModel.historyData count];
    }
//    return 10;
    
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
    stockTradeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    stockData *stockdata;
    if (self.searchController.active) {
        stockdata=self.searchData[indexPath.row];
    }else{
        stockdata=self.historyDataModel.historyData[indexPath.row];
    }
    cell.nameOfStock.text=stockdata.nameOfStock;
    cell.buyPriceAndNumebr.text=[NSString stringWithFormat:@"%@/%@",stockdata.buyPrice,stockdata.buyNumber];
    cell.timeOfDeal.text=stockdata.buyTime;
    cell.numberOfHolding.text=stockdata.numberOfHolding;
    cell.gainOrLose.text=stockdata.gainOrLose;
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    cell.textLabel.text=@"111";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    stockData *stockdata=self.historyDataModel.historyData[indexPath.row];
    [self performSegueWithIdentifier:@"sellStockHistory" sender:stockdata];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"sellStockHistory"]) {
        historySellStockViewController *controller=segue.destinationViewController;
        controller.stockdata=sender;
        
//        UINavigationController *navigationController=segue.destinationViewController;//新的视图控制器可以在segue.destinationViewController中找到
//        historySellStockViewController *controller=(historySellStockViewController *)navigationController.topViewController;
//        controller.stockdata=sender;
        
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

@end
