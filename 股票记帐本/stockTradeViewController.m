//
//  stockTradeViewController.m
//  股票记帐本
//
//  Created by 施德胜 on 15/9/1.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import "stockTradeViewController.h"
#import "stockTradeTableViewCell.h"


static NSString *cellIdentifier=@"stockTradeTableViewCell";

@interface stockTradeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchData;


@end

@implementation stockTradeViewController{
    NSInteger _selectedIndexPathRow;
    NSUInteger _theMountOfSelling;
   
}
//- (id)initWithCoder:(NSCoder *)aDecoder{
//    if ((self=[super initWithCoder:aDecoder])) {
//        
//        self.stockData=[[stockData alloc]init];
//    }
//    return self;
//}

//总盈利设置
- (float)computeTotalGain{
    float _totalGainOrLoseValue = 0.0;
    for (NSUInteger i=0; i<[self.dataModel.Data count]; i++) {
        stockData *stockdata=self.dataModel.Data[i];
        _totalGainOrLoseValue=_totalGainOrLoseValue+[stockdata.gainOrLose floatValue];
    }
//    NSString *totalGain=[NSString stringWithFormat:@"%.0f",_totalGainOrLoseValue];
    return _totalGainOrLoseValue;
}
- (void)setTotalGainSignAndColor{
   float totalGainOrLoseValue=[self computeTotalGain];
    NSLog(@"totalGainOrLoseValue%f",totalGainOrLoseValue);
    if (totalGainOrLoseValue>0) {
        self.totalGain.text=[NSString stringWithFormat:@"+%.0f",totalGainOrLoseValue];
        self.totalGain.textColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    }else if (totalGainOrLoseValue==0){
        self.totalGain.text=[NSString stringWithFormat:@"%.0f",totalGainOrLoseValue];
        self.totalGain.textColor=[UIColor colorWithWhite:1 alpha:1];
    }else if (totalGainOrLoseValue<0){
        self.totalGain.text=[NSString stringWithFormat:@"%.0f",totalGainOrLoseValue];
        self.totalGain.textColor=[UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
    //初始化搜索栏
    _searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater=self;
    _searchController.dimsBackgroundDuringPresentation=NO;
    _searchController.hidesNavigationBarDuringPresentation=NO;
    _searchController.searchBar.frame=CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 40);
    self.tableview.tableHeaderView=self.searchController.searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView=(id)[self.view viewWithTag:1];
    tableView.rowHeight=80;
    UINib *nib=[UINib nibWithNibName:@"stockTradeTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    // Do any additional setup after loading the view.
    
    self.dataModel=[[DataModel alloc]init];
    self.historyDataModel=[[historyDataModel alloc]init];
    [self setTotalGainSignAndColor];
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
    NSString *searchString = [self.searchController.searchBar text];
    if (self.searchData!= nil) {
        [self.searchData removeAllObjects];
    }
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    //过滤数据
//    self.searchData= [NSMutableArray arrayWithArray:[self.dataModel.Data filteredArrayUsingPredicate:predicate]];
    self.searchData=[[NSMutableArray alloc]initWithCapacity:20];
    for (NSUInteger i=0;i<[self.dataModel.Data count];i++) {
        stockData *stockdata=self.dataModel.Data[i];
        if ([stockdata.nameOfStock containsString:searchString]) {
            [self.searchData addObject:self.dataModel.Data[i]];
        }
    }
    [self.tableview reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    stockTradeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    stockData *stockdata;
    if (self.searchController.active) {
        stockdata=self.searchData[indexPath.row];
    }else{
        stockdata=self.dataModel.Data[indexPath.row];
    }
    cell.nameOfStock.text=stockdata.nameOfStock;
    cell.buyPriceAndNumebr.text=[NSString stringWithFormat:@"%@/%@",stockdata.buyPrice,stockdata.buyNumber];//stockdata.buyPrice;
    cell.timeOfDeal.text=stockdata.buyTime;
    
    if (stockdata.numberOfHolding==nil) {
        cell.numberOfHolding.text=stockdata.buyNumber;
    }else{
        cell.numberOfHolding.text=stockdata.numberOfHolding;
    }
    
    //设置单只股票的盈亏格式
    if (stockdata.gainOrLose==nil) {
        cell.gainOrLose.text=@"0";
        cell.percentOfGainOrLose.text=@"0 %";
        cell.gainOrLose.textColor=[UIColor colorWithWhite:0 alpha:1];
        cell.percentOfGainOrLose.textColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    }else{
        float ValueOfGainOrLose=[stockdata.gainOrLose floatValue];
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
        
    }
//    if (stockdata.totalGain==nil) {
//        self.totalGain.text=@"0";
//    }else{
//        self.totalGain.text=stockdata.totalGain;
//    }
   
    
//        cell.nameOfStock.text=self.stockData.nameOfStock[indexPath.row];
//        cell.timeOfDeal.text=@"timeOfDeal";
//        cell.buyPriceAndNumebr.text=self.stockData.buyPriceAndNumebr[indexPath.row];
//        cell.numberOfHolding.text=@"numberOfHolding";
//        cell.gainOrLose.text=@"gainOrLose";

    return cell;
    
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    stockData *Data = self.dataModel.Data[indexPath.row];
    _selectedIndexPathRow=indexPath.row;
    
    [self performSegueWithIdentifier:@"sellStock" sender:Data];//跳转之后tableview内的数据依旧可以用
    //    Checklist *checklist=self.dataModel.lists[indexPath.row];
    //    [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
    
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



- (void)addStockViewControllerDidCancel:(addStockViewController *)controller{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)addStockViewController:(addStockViewController *)controller didFinishAddingStockData:(stockData *)stockdata{
    [self.dataModel.Data insertObject:stockdata atIndex:0];
//    [self.dataModel.Data addObject:stockdata];
    [self.dataModel saveData];
    [self.tableview reloadData];

   
    //添加时间
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sellStockViewController:(sellStockViewController *)controller didFinishAddingSellStock:(stockData *)stockdata{
//    NSUInteger integer=[self.dataModel.Data count]-1;
//    [self.dataModel.Data removeObjectAtIndex:integer];
//    [self.dataModel.Data addObject:stockdata];
    [self.dataModel.Data removeObjectAtIndex:_selectedIndexPathRow];
    [self.dataModel.Data insertObject:stockdata atIndex:_selectedIndexPathRow];
    
    if ([stockdata.numberOfHolding isEqualToString:@"0"]) {
        [self.historyDataModel.historyData insertObject:stockdata atIndex:0];
        [self.dataModel.Data removeObjectAtIndex:_selectedIndexPathRow];
        [self.historyDataModel saveHistoryData];
        [self.historyTradeViewController.historyTableView reloadData];
        
    }
    [self.dataModel saveData];
    [self setTotalGainSignAndColor];
    NSLog(@"111%@",self.dataModel);
   
}
//- (void)didFinishComputingTheMountOfSelling:(NSString *)numberOfSell{
//    _theMountOfSelling+=[numberOfSell integerValue];
//}
//- (void)addStockViewController:(addStockViewController *)controller didFinishAddNameOfStock:(UITextField *)nameOfStock didFinishAddNumberOfStock:(UITextField *)numberOfStock didFinishAddPriceOfStock:(UITextField *)priceOfStock didFinishAddBuyNumber:(UITextField *)buyNumber {
//    [self.stockData.nameOfStock addObject:nameOfStock.text];
//    NSString *buyPriceAndNumebr=[NSString stringWithFormat:@"%@/%@",priceOfStock.text,buyNumber.text];
//    [self.stockData.buyPriceAndNumebr addObject:buyPriceAndNumebr];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.tableview reloadData];
//    
//    [self saveData];
//}


//- (void)sellStockViewControllerDidCancel:(sellStockViewController *)controller{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addStock"]) {
        UINavigationController *navigationController=segue.destinationViewController;//新的视图控制器可以在segue.destinationViewController中找到
        addStockViewController *controller=(addStockViewController *)navigationController.topViewController;//为了获取addStockViewController对象，我们可以查看导航控制器的topViewController属性，该属性指向导航控制器的当前活跃界面
        controller.delegate=self;//一旦我们获得了到addStockViewController对象的引用，就需要将delegate属性设置为self(这样在addStockViewController中的self.delegate才是stockTradeViewController)，而self指的是stockTradeViewController
        
    }
    else if([segue.identifier isEqualToString:@"sellStock"]){
//        sellStockViewController *viewController = segue.destinationViewController;
//        viewController.stockdata = sender;
       
        sellStockViewController *controller=segue.destinationViewController;
        controller.delegate=self;
        controller.stockdata=sender;
        
//        UINavigationController *navigationController=segue.destinationViewController;//新的视图控制器可以在segue.destinationViewController中找到
//        sellStockViewController *controller=(sellStockViewController *)navigationController.topViewController;//为了获取addStockViewController对象，我们可以查看导航控制器的topViewController属性，该属性指向导航控制器的当前活跃界面
//        controller.delegate=self;//一旦我们获得了到AddItemViewController对象的引用，就需要将delegate属性设置为self，而self指的是stockTradeViewController
//        controller.sellData=sender;
//        NSIndexPath *indexPath=[self.tableview indexPathForCell:sender];//sender参数启示指的就是触发了该segue的控件，在这里就是table view cell中的细节显示按钮。通过它可以找到对应的nidex－path，然后获取要编辑的checklistitem对象的行编号
        
//        controller.itemToEdit=self.checklist.items[indexPath.row];
    }
//    UINavigationController *navigationController=segue.destinationViewController;
//    
//    ItemDetailViewController *controller=(ItemDetailViewController*)navigationController.topViewController;
//    
//    controller.delegate=self;
//    
//    NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];//sender参数启示指的就是触发了该segue的控件，在这里就是table view cell中的细节显示按钮。通过它可以找到对应的nidex－path，然后获取要编辑的checklistitem对象的行编号
//    
//    controller.itemToEdit=self.checklist.items[indexPath.row];
}
//-(void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist{
//    //与addItem方法类似，在AddItemViewController添加对象。我们只需要把新的对象添加到_items数组中就可以了。我们通知表视图有一个新的行，然后关闭add items界面
//    NSInteger newRowIndex=[self.dataModel.lists count];
//    [self.dataModel.lists addObject:checklist];
//    
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:newRowIndex inSection:0];
//    
//    NSArray *indexPaths=@[indexPath];
//    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    //通知additemviewcontroller，checklistsviewcontroller是它的代理
//    if ([segue.identifier isEqualToString:@"AddItem"]) {
//
//        UINavigationController *navigationController=segue.destinationViewController;//新的视图控制器可以在segue.destinationViewController中找到
//        
//        ItemDetailViewController *controller=(ItemDetailViewController*)navigationController.topViewController;//为了获取AddItemViewController对象，我们可以查看导航控制器的topViewController属性，该属性指向导航控制器的当前活跃界面
//        
//        controller.delegate=self;//一旦我们获得了到AddItemViewController对象的引用，就需要将deledgate属性设置为self，而self其实值得是checklistsviewcontroller
//        
//    }else if([segue.identifier isEqualToString:@"EditItem"]){
//        UINavigationController *navigationController=segue.destinationViewController;
//        
//        ItemDetailViewController *controller=(ItemDetailViewController*)navigationController.topViewController;
//        
//        controller.delegate=self;
//        
//        NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];//sender参数启示指的就是触发了该segue的控件，在这里就是table view cell中的细节显示按钮。通过它可以找到对应的nidex－path，然后获取要编辑的checklistitem对象的行编号
//        
//        controller.itemToEdit=self.checklist.items[indexPath.row];
//        
//    }
//    
//}

//- (NSString *)documentsDirectory{
//    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//NSDocumentDirectory表明查找Documents目录的路径，NSUserDomainMask表明讲搜素限制在应用的沙盒内
//    NSString *documentsDirectory=path[0];//每个应用只有一个Documents目录
//    NSLog(@"%@",documentsDirectory);
//    return documentsDirectory;
//}
//
//- (NSString *)dataFilePath{
//    //创建到checklists.plist的完整路径
//    return [[self documentsDirectory]stringByAppendingPathComponent:@"stockdata.plist"];
//}
//
//- (void)saveData{
//    NSMutableData *data=[[NSMutableData alloc]init];
//    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
//    [archiver encodeObject:self.stockData forKey:@"stockdata"];//_局部变量，self属性
//    [archiver finishEncoding];
//    [data writeToFile:[self dataFilePath] atomically:YES];
//    //获取sellData数组中的内容，然后分两步讲它转换成二进制数据块，然后写进到文件中，chapter13p5
//    
//    
//}
//- (void) loadData{
//    NSString *path=[self dataFilePath];
//    //检查沙盒中是否存在该文件
//    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
//        //当应用从沙河中找到path.plist文件时，我们无需创建一个新的数组，可以从该文件中加载整个数组和其中内容（savechecklistitem的逆向操作）
//        NSData *data=[[NSData alloc]initWithContentsOfFile:path];//将文件内容加载到nsdata对象中
//        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc]initForReadingWithData:data];//创建一个nskeyedunarchiver对象
//        self.stockData=[unarchiver decodeObjectForKey:@"stockdata"];
//        [unarchiver finishDecoding];
//    }else{
//        self.stockData=[[stockData alloc]init];
//    }
//}

@end
