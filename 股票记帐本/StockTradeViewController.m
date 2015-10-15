//
//  stockTradeViewController.m
//  股票记帐本
//
//  Created by 施德胜 on 15/9/1.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import "StockTradeViewController.h"
#import "StockTradeTableViewCell.h"
#import "StockData.h"


static NSString *cellIdentifier=@"stockTradeTableViewCell";

@interface StockTradeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchData;


@end

@implementation StockTradeViewController{
    NSInteger _selectedIndexPathRow;
    NSUInteger _theMountOfSelling;

   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataModel=[[DataModel alloc]init];
    [self.tableview reloadData];
    [self setTotalGainSignAndColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView=(id)[self.view viewWithTag:1];
    tableView.rowHeight=80;
    UINib *nib=[UINib nibWithNibName:@"stockTradeTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    self.title=@"交 易";
    
    // Do any additional setup after loading the view.
    
    
    self.historyDataModel=[[HistoryDataModel alloc]init];
    
    
    //初始化搜索栏
    _searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater=self;
    _searchController.dimsBackgroundDuringPresentation=NO;
    _searchController.hidesNavigationBarDuringPresentation=NO;
    _searchController.searchBar.frame=CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 40);
    self.tableview.tableHeaderView=self.searchController.searchBar;
//    _searchController.searchBar.barTintColor=[UIColor colorWithRed:0/255.0 green:127/255.0 blue:236/255.0 alpha:1.0f];
    _searchController.searchBar.placeholder=@"-输入股票名称-";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.searchData count];
    }else{
        return [self.dataModel.Data count];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"111111");
    NSString *searchString = [self.searchController.searchBar text];
    if (self.searchData!= nil) {
        [self.searchData removeAllObjects];
    }
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    //过滤数据
//    self.searchData= [NSMutableArray arrayWithArray:[self.dataModel.Data filteredArrayUsingPredicate:predicate]];
    self.searchData=[[NSMutableArray alloc]initWithCapacity:20];
    for (NSUInteger i=0;i<[self.dataModel.Data count];i++) {
        StockData *stockdata=self.dataModel.Data[i];
        if ([stockdata.nameOfStock containsString:searchString]) {
            [self.searchData addObject:self.dataModel.Data[i]];
        }
    }
    [self.tableview reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StockTradeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];//forIndexPath:indexPath lets the table view be a bit smarter,但只有当使用nib文件时有效
    StockData *stockdata;
    if (self.searchController.active) {
        stockdata=self.searchData[indexPath.row];
    }else{
        stockdata=self.dataModel.Data[indexPath.row];
    }
    cell.nameOfStock.text=stockdata.nameOfStock;
    cell.buyPriceAndNumebr.text=[NSString stringWithFormat:@"%@/%@",stockdata.buyPrice,stockdata.buyNumber];
    cell.timeOfDeal.text=stockdata.buyTime;
    cell.stockNumber.text=stockdata.stockNumber;
    
    if (stockdata.numberOfHolding==nil) {
        cell.numberOfHolding.text=stockdata.buyNumber;
    }else{
        cell.numberOfHolding.text=stockdata.numberOfHolding;
    }
    
    //设置单只股票的盈亏格式
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
    
    StockData *Data = self.dataModel.Data[indexPath.row];
    _selectedIndexPathRow=indexPath.row;
    
    [self performSegueWithIdentifier:@"sellStock" sender:Data];//跳转之后tableview内的数据依旧可以用
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataModel.Data removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.dataModel saveData];
    [self setTotalGainSignAndColor];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark 代理方法
- (void)addStockViewControllerDidCancel:(AddStockViewController *)controller{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)addStockViewController:(AddStockViewController *)controller didFinishAddingStockData:(StockData *)stockdata{
    [self.dataModel.Data insertObject:stockdata atIndex:0];
    [self.dataModel saveData];
    [self.tableview reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sellStockViewController:(SellStockViewController *)controller didFinishAddingSellStock:(StockData *)stockdata{
    [self.dataModel.Data removeObjectAtIndex:_selectedIndexPathRow];
    [self.dataModel.Data insertObject:stockdata atIndex:_selectedIndexPathRow];
    
    if ([stockdata.numberOfHolding isEqualToString:@"0"]) {
        [self.historyDataModel.historyData insertObject:stockdata atIndex:0];
        [self.dataModel.Data removeObjectAtIndex:_selectedIndexPathRow];
        [self.historyDataModel saveHistoryData];
    }
    [self.dataModel saveData];
    [self setTotalGainSignAndColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addStock"]) {
        UINavigationController *navigationController=segue.destinationViewController;//新的视图控制器可以在segue.destinationViewController中找到
        AddStockViewController *controller=(AddStockViewController *)navigationController.topViewController;//为了获取addStockViewController对象，我们可以查看导航控制器的topViewController属性，该属性指向导航控制器的当前活跃界面
        controller.delegate=self;//一旦我们获得了到addStockViewController对象的引用，就需要将delegate属性设置为self(这样在addStockViewController中的self.delegate才是stockTradeViewController)，而self指的是stockTradeViewController
        
    }
    else if([segue.identifier isEqualToString:@"sellStock"]){
        SellStockViewController *controller=segue.destinationViewController;
        controller.delegate=self;
        controller.stockdata=sender;
    }
}

#pragma mark 自定义方法
//总盈利设置
- (float)computeTotalGain:(NSMutableArray*)dataArray{
    float _totalGainOrLoseValue = 0.0;
    for (NSUInteger i=0; i<[dataArray count]; i++) {
        StockData *stockdata=dataArray[i];
        _totalGainOrLoseValue=_totalGainOrLoseValue+[stockdata.gainOrLose floatValue]-[stockdata.buyFee floatValue];
    }
    return _totalGainOrLoseValue;
}

- (void)setTotalGainSignAndColor{
    self.totalGain.text=@"0";
    self.totalGain.textColor=[UIColor colorWithWhite:0 alpha:1];
    float totalGainOrLoseValue=[self computeTotalGain:self.dataModel.Data];
    NSLog(@"totalGainOrLoseValue%f",totalGainOrLoseValue);
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
