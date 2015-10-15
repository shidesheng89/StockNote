//
//  selectedStockViewController.m
//  股票记帐本
//
//  Created by 施德胜 on 15/10/6.
//  Copyright © 2015年 施德胜. All rights reserved.
//

#import "SelectedStockViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "SearchResults.h"
#import "SelectedStockTableViewCell.h"
#import "TabTableViewCell.h"
#import "SearchResultTableViewCell.h"
#import "SelectedStock.h"
#import "SelectedStockDataModel.h"

#import "AddStockViewController.h"
#import "StockTradeViewController.h"
#import "DataModel.h"

static NSString *cellIdentifier=@"cellIdentifier";
static NSString *tabCellIdentifier=@"tabCellIdentifier";
static NSString *searchCellIdentifier=@"searchCellIdentifier";

@interface SelectedStockViewController ()

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *allStockCode;
@property (strong, nonatomic) NSMutableArray *allStockName;
@property (strong, nonatomic) NSMutableArray *selectedStockData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) SelectedStockDataModel *selectedStockDataModel;
@property (strong, nonatomic) NSMutableArray *stockDataInRealTime;

@property (strong, nonatomic) StockTradeViewController *stockTradeViewController;
@property (strong, nonatomic) DataModel *dataModel;


@end

@implementation SelectedStockViewController{
    BOOL _selectedStockIsLoading;
    NSOperationQueue *_queue;
    int sectionNumber;
    BOOL _NetWorking;
}

- (IBAction)refresh:(id)sender {
    [self getSelectedStockDate];
    if (_NetWorking==NO) {
        [self showNetworkError];
    }
}

//状态栏颜色设置
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.selectedStockDataModel=[[SelectedStockDataModel alloc]init];
    _NetWorking=YES;
    [self getSelectedStockDate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.dataModel=[[DataModel alloc]init];
    self.title=@"自选股";
    NSLog(@"selected%@",self.selectedStockDataModel.selectedStockData);
    NSLog(@"numberOfRowsInSection1%lu",(unsigned long)[self.selectedStockData count]);
    
    _selectedStockIsLoading=YES;
    _queue = [[NSOperationQueue alloc] init];//AFNetworking线程初始化
    [self getAllNameAndCode];
    self.tableView.rowHeight=44;
    UINib *tabNib=[UINib nibWithNibName:@"tabTableViewCell" bundle:nil];
    [self.tableView registerNib:tabNib forCellReuseIdentifier:tabCellIdentifier];
    UINib *nib=[UINib nibWithNibName:@"selectedStockTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    UINib *searchResultsnib=[UINib nibWithNibName:@"SearchResultTableViewCell" bundle:nil];
    [self.tableView registerNib:searchResultsnib forCellReuseIdentifier:searchCellIdentifier];
    self.tableView.contentInset=UIEdgeInsetsMake(0.01, 0, 0, 0);//取消掉在heightForHeaderInSection设置的0.01
    self.searchBar.tintColor=[UIColor whiteColor];
//    self.searchBar.barTintColor=[UIColor colorWithRed:0/255.0 green:127/255.0 blue:236/255.0 alpha:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    //每次加载xib时，都初始化_queue
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_selectedStockIsLoading==YES) {
        return 2;
    }else{
    return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectedStockIsLoading==NO) {
        if ([self.searchResults count]<15) {
            return [self.searchResults count];
        }else{
            return 15;
        }
    }else{
        if (section==0) {
            return 1;
        }else if(section==1){
            NSLog(@"numberOfRowsInSection%lu",(unsigned long)[self.selectedStockData count]);
            return [self.selectedStockData count];
        }else{
            return 0;
        }
    }
//    return [self.searchResults count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_selectedStockIsLoading==NO) {
        return 0.01f;
    }else{
        if (section==0) {
            return 0.01f;
        }else{
            return 2.0f;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_selectedStockIsLoading==YES) {
        return 0.01f;
    }else{
        return 0.01f;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedStockIsLoading==NO) {
        SearchResultTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
        SearchResults *searchResult=self.searchResults[indexPath.row];
        cell.name.text=searchResult.name;
        cell.code.text=searchResult.code;
        cell.addSelectedStockButton.tag=indexPath.row;
        [cell.addSelectedStockButton addTarget:self action:@selector(addSelectedStock:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else{
        self.stockDataInRealTime=self.selectedStockData;
        [self.stockDataInRealTime sortUsingSelector:@selector(compareName:)];
//        [tempArray sortedArrayHint];
        if (indexPath.section==0) {
            TabTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tabCellIdentifier forIndexPath:indexPath];
            return cell;
        }else if(indexPath.section==1){
            SelectedStockTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            SelectedStock *selectedStock=self.stockDataInRealTime[indexPath.row];
            cell.name.text=selectedStock.name;
            cell.code.text=selectedStock.code;
            cell.price.text=[NSString stringWithFormat:@"%.2f",[selectedStock.price floatValue]];
            float percent=[selectedStock.percent floatValue];
            if (percent>0) {
                cell.percent.textColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:1];
                cell.percent.text=[NSString stringWithFormat:@"+%.2f%%",[selectedStock.percent floatValue]*100];
            }else if (percent==0){
                cell.percent.textColor=[UIColor colorWithWhite:0 alpha:1];
                cell.percent.text=[NSString stringWithFormat:@"%.2f%%",[selectedStock.percent floatValue]*100];
            }else if (percent<0){
                cell.percent.textColor=[UIColor colorWithRed:0 green:1 blue:0 alpha:1];
                cell.percent.text=[NSString stringWithFormat:@"%.2f%%",[selectedStock.percent floatValue]*100];
            }
            NSLog(@"111");
            return cell;
        }else{
            return nil;
        }
    }
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //多线程导致数组顺序不一致，重新排序
    [self.selectedStockDataModel.selectedStockData sortUsingSelector:@selector(compareName:)];
    [self.selectedStockDataModel.selectedStockData removeObjectAtIndex:indexPath.row];
    [self.stockDataInRealTime removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths=@[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.selectedStockDataModel saveData];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.selectedStockDataModel.selectedStockData sortUsingSelector:@selector(compareName:)];
    
    SelectedStock *selectedStock=self.selectedStockDataModel.selectedStockData[indexPath.row];
    NSLog(@"selectedStock%@",selectedStock);
    NSLog(@"selectedStock%@",selectedStock.name);
    [self performSegueWithIdentifier:@"addSelectedStock" sender:selectedStock];//跳转之后tableview内的数据依旧可以用
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedStockIsLoading==NO) {
        return nil;
    }else{
        return indexPath;
    }
}

#pragma mark - searchBarDelegate

-(void)addSelectedStock:(UIButton *)sender{
    BOOL addSelectedStock=YES;
    SearchResults *searchResult=self.searchResults[sender.tag];
    if (_NetWorking==NO) {
        [self showNetworkError];
    }else{
        for (NSInteger i=0; i<[self.selectedStockDataModel.selectedStockData count]; i++) {
            SearchResults *stockData=self.selectedStockDataModel.selectedStockData[i];
            NSString *code=stockData.code;
            if ([searchResult.code isEqualToString:code]){
                [self showReatAlert:stockData.name];
                addSelectedStock=NO;
                break;
            }
        }
        if (addSelectedStock==YES) {
            [self.selectedStockDataModel.selectedStockData addObject:searchResult];
            [self.searchBar resignFirstResponder];
            [self getSelectedStockDate];
            [self.tableView reloadData];
            [self.selectedStockDataModel saveData];
            _selectedStockIsLoading=YES;
        }
    }
}


-(void)showReatAlert:(NSString *)stockName{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"%@已在自选股中",stockName]
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    
    [alertView show];
    
}
- (void)showNetworkError{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"网络无法连接"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    
    [alertView show];
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    _selectedStockIsLoading=NO;
    self.searchResults=[[NSMutableArray alloc]initWithCapacity:20];
    [self.tableView reloadData];
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
    _selectedStockIsLoading=YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _selectedStockIsLoading=YES;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearch];
    NSLog(@"numberOfRowsInSection111%lu",(unsigned long)[self.searchResults count]);
}

- (void)performSearch
{
    if ([self.searchBar.text length] > 0) {
        self.searchResults=[[NSMutableArray alloc]initWithCapacity:20];
        
        for (NSInteger i=0; i<[self.allStockCode count]; i++) {
            SearchResults *searchResults=[[SearchResults alloc]init];
            NSString *tempCode=self.allStockCode[i];
            NSString *tempName=self.allStockName[i];
            if ([tempCode containsString:self.searchBar.text]||[tempName containsString:self.searchBar.text]) {
                searchResults.name=tempName;
                searchResults.code=tempCode;
                [self.searchResults addObject:searchResults];
            }
        }
        NSLog(@"%@",self.searchResults);
        [self.searchResults sortUsingSelector:@selector(compareName:)];
        [self.tableView reloadData];
    }
}

//直接search显示网络结果时使用
- (void)getSelectedStockDate{
    self.selectedStockData=[[NSMutableArray alloc]initWithCapacity:20];
    if ([self.selectedStockDataModel.selectedStockData count] > 0) {
        [_queue cancelAllOperations];
        NSMutableArray *searchURLKey=[[NSMutableArray alloc]initWithCapacity:20];
        for (NSInteger i=0; i<[self.selectedStockDataModel.selectedStockData count]; i++) {
            SearchResults *selectedStock=self.selectedStockDataModel.selectedStockData[i];
            NSString *tempCode=selectedStock.code;
            NSString *newTempCode;
            
            if ([tempCode hasPrefix:@"sh"]) {
                newTempCode=[tempCode stringByReplacingOccurrencesOfString:@"sh" withString:@"0"];
            }else{
                newTempCode=[tempCode stringByReplacingOccurrencesOfString:@"sz" withString:@"1"];
            }
            NSLog(@"%@",selectedStock.code);
            NSLog(@"%@",tempCode);
            NSLog(@"%@",newTempCode);
            [searchURLKey addObject:newTempCode];
        }
        NSLog(@"count%lu",(unsigned long)[searchURLKey count]);
        for (NSInteger i=0; i<[searchURLKey count]; i++) {
            NSString *URLKey=searchURLKey[i];
            NSString *codeKey=searchURLKey[i];
            NSString *URLString=[NSString stringWithFormat:@"http://api.money.126.net/data/feed/%@,money.api",URLKey];
            NSURL *URL = [NSURL URLWithString:URLString];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            //    op.responseSerializer = [AFJSONResponseSerializer serializer];
            op.responseSerializer = [AFHTTPResponseSerializer serializer];
            op.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"application/x-javascript",nil];//添加不支持的格式
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *string=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSString *substring=[self getSubstring:string];
                NSDictionary *dictionary=[self parseJSON:substring][codeKey];
                [self parseDictionary:dictionary];
                NSLog(@"nnnn%lu",(unsigned long)[self.selectedStockData count]);
                NSLog(@"%lu",(unsigned long)[self.searchResults count]);
                _NetWorking=YES;
                [self.tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                _NetWorking=NO;
                NSLog(@"Error: %@", error);
                [self.tableView reloadData];
            }];
            [_queue addOperation:op];
            
        }
        [self.tableView reloadData];
    }
}


//截取字符串
- (NSString *)getSubstring:(NSString *)string{
    NSRange startRange=[string rangeOfString:@"("];
    NSRange endRange=[string rangeOfString:@")"];
    NSString *substring=[string substringWithRange:NSMakeRange(startRange.location+1, endRange.location-startRange.location-1)];
    return substring;
}

- (NSString *)checkPrefix:(NSString *)string{
    if ([string hasPrefix:@"0"]) {
        return [NSString stringWithFormat:@"1%@",string];
    }else if ([string hasPrefix:@"6"]){
        return [NSString stringWithFormat:@"6%@",string];
    }else{
        return nil;
    }
}

- (NSDictionary *)parseJSON:(NSString *)jsonString{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];//使用NSJSONSerialization将json转换为 NSDictionary.
//    NSLog(@"resultObject%@",resultObject);
    if (resultObject == nil) {
//        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    //判断是否为NSDictionary
    if (![resultObject isKindOfClass:[NSDictionary class]]) {
//        NSLog(@"JSON Error: Expected dictionary");
        return nil;
    }
    
    return resultObject;
}

- (void)parseDictionary:(NSDictionary *)dictionary{
    SelectedStock *results=[[SelectedStock alloc]init];
    results.name=dictionary[@"name"];
    results.code=[NSString stringWithFormat:@"%@%@",dictionary[@"type"],dictionary[@"symbol"]];
    results.price=dictionary[@"price"];
    results.percent=dictionary[@"percent"];
    [self.selectedStockData addObject:results];

}




- (void)getAllNameAndCode{
    self.allStockCode=[[NSMutableArray alloc]initWithCapacity:20];
    self.allStockName=[[NSMutableArray alloc]initWithCapacity:20];
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"nameAndCode" ofType:@"txt"];
     NSString *string=[NSString stringWithContentsOfFile:filePath encoding:NSUTF16StringEncoding error:nil];
    NSArray *array=[string componentsSeparatedByString:@"\n"];
    NSEnumerator *arrayEnumerator=[array objectEnumerator];
    NSString *tempString;
    while (tempString =[arrayEnumerator nextObject]) {
        NSArray *tempArray=[tempString componentsSeparatedByString:@"\t"];
//        NSLog(@"%@",tempArray[0]);
//        NSLog(@"temparray%@",tempArray);
        NSString *code=[NSString stringWithFormat:@"%@",tempArray[0]];
        NSString *name=[NSString stringWithFormat:@"%@",tempArray[1]];
//        NSLog(@"code%@",code);
        [self.allStockCode addObject:code];
        [self.allStockName addObject:name];
       
    }
//    NSLog(@"allstockcode%@",self.allStockCode);
//    NSLog(@"allstockcode%@",self.allStockName);
//    NSLog(@"%@",self.allStockName[0]);
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addSelectedStock"]) {
        UINavigationController *navigationController=segue.destinationViewController;//新的视图控制器可以在segue.destinationViewController中找到
        AddStockViewController *controller=(AddStockViewController *)navigationController.topViewController;//为了获取addStockViewController对象，我们可以查看导航控制器的topViewController属性，该属性指向导航控制器的当前活跃界面
        controller.delegate=self;//一旦我们获得了到addStockViewController对象的引用，就需要将delegate属性设置为self(这样在addStockViewController中的self.delegate才是stockTradeViewController)，而self指的是stockTradeViewController
        controller.selectedStock=sender;
        
    }
}

#pragma mark 代理方法
- (void)addStockViewControllerDidCancel:(AddStockViewController *)controller{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)addStockViewController:(AddStockViewController *)controller didFinishAddingStockData:(StockData *)stockdata{
    [self.dataModel.Data insertObject:stockdata atIndex:0];
    [self.dataModel saveData];
//    [self performSegueWithIdentifier:@"showTrade" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
