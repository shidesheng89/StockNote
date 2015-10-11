//
//  selectedStockViewController.m
//  股票记帐本
//
//  Created by 施德胜 on 15/10/6.
//  Copyright © 2015年 施德胜. All rights reserved.
//

#import "selectedStockViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "SearchResults.h"
#import "selectedStockTableViewCell.h"
#import "tabTableViewCell.h"
#import "SearchResultTableViewCell.h"
#import "SelectedStock.h"

static NSString *cellIdentifier=@"cellIdentifier";
static NSString *tabCellIdentifier=@"tabCellIdentifier";
static NSString *searchCellIdentifier=@"searchCellIdentifier";

@interface selectedStockViewController ()

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *allStockCode;
@property (strong, nonatomic) NSMutableArray *allStockName;
@property (strong, nonatomic) NSMutableArray *selectedStockData;
@property (strong, nonatomic) NSMutableArray *selectedStockCode;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation selectedStockViewController{
    BOOL _selectedStockIsLoading;
    NSOperationQueue *_queue;
    int sectionNumber;
}

//状态栏颜色设置
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSelectedStockDate];
    _selectedStockIsLoading=YES;
    self.selectedStockCode=[[NSMutableArray alloc]initWithCapacity:20];
    self.selectedStockData=[[NSMutableArray alloc]initWithCapacity:20];
    _queue = [[NSOperationQueue alloc] init];//试验，记得删
    [self getAllNameAndCode];
    self.tableView.rowHeight=44;
    UINib *tabNib=[UINib nibWithNibName:@"tabTableViewCell" bundle:nil];
    [self.tableView registerNib:tabNib forCellReuseIdentifier:tabCellIdentifier];
    UINib *nib=[UINib nibWithNibName:@"selectedStockTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    UINib *searchResultsnib=[UINib nibWithNibName:@"SearchResultTableViewCell" bundle:nil];
    [self.tableView registerNib:searchResultsnib forCellReuseIdentifier:searchCellIdentifier];
//    UINib *nib=[UINib nibWithNibName:@"selectedStockTableViewCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
//    UINib *tabNib=[UINib nibWithNibName:@"tabTableViewCell" bundle:nil];
//    [self.tableView registerNib:tabNib forCellReuseIdentifier:tabCellIdentifier];
    self.tableView.contentInset=UIEdgeInsetsMake(0.01, 0, 0, 0);//取消掉在heightForHeaderInSection设置的0.01
    self.searchBar.tintColor=[UIColor whiteColor];
    self.searchBar.barTintColor=[UIColor colorWithRed:0/255.0 green:127/255.0 blue:236/255.0 alpha:1.0];
//    self.searchBar.barStyle=UIBarStyleBlack;
    //初始化搜索栏
//    _searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
////    _searchController.searchResultsUpdater=self;
//    _searchController.dimsBackgroundDuringPresentation=NO;
//    _searchController.hidesNavigationBarDuringPresentation=NO;
//    _searchController.searchBar.frame=CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 40);
//    self.tableView.tableHeaderView=self.searchController.searchBar;
//    _searchController.searchBar.placeholder=@"-输入证券名称-";
//    _searchController.searchBar.delegate=self;
    // Do any additional setup after loading the view.
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
            NSLog(@"numberOfRowsInSection%lu",(unsigned long)[self.searchResults count]);
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
        return 0;
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
        if (indexPath.section==0) {
            tabTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tabCellIdentifier forIndexPath:indexPath];
            return cell;
        }else if(indexPath.section==1){
            selectedStockTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            SelectedStock *selectedStock=self.selectedStockData[indexPath.row];
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
    //        UINib *nib=[UINib nibWithNibName:@"selectedStockTableViewCell" bundle:nil];
    //        [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
//    selectedStockTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    SearchResults *searchResult=self.searchResults[indexPath.row];
//    cell.name.text=searchResult.nameOfStock;
//    cell.code.text=searchResult.stockCode;
//    cell.percent.text=[NSString stringWithFormat:@"%.2f%%",[searchResult.percent floatValue]*100];
//    cell.price.text=[NSString stringWithFormat:@"%@",searchResult.price];
//    NSLog(@"111");
//    return cell;
    
}

#pragma mark - searchBarDelegate

-(void)addSelectedStock:(UIButton *)sender{
    SearchResults *searchResult=self.searchResults[sender.tag];
    [self.selectedStockCode addObject:searchResult.code];
    NSLog(@"n%lu",(unsigned long)[self.selectedStockCode count]);
    [self.searchBar resignFirstResponder];
    [self getSelectedStockDate];
    [self.tableView reloadData];
    _selectedStockIsLoading=YES;
    NSLog(@"add");
}

//- (IBAction)addSelectedStock:(id)sender {
//    self.StockViewController.selectedStockCode=[[NSMutableArray alloc]initWithCapacity:20];
//    NSString *tempCode=self.code.text;
//    [self.StockViewController.selectedStockCode addObject:tempCode];
//    NSLog(@"code%@",tempCode);
//    NSLog(@"tockcode%@",self.StockViewController.selectedStockCode);
//    [self.StockViewController.searchBar resignFirstResponder];
//    [self.StockViewController getSelectedStockDate];
//    [self.StockViewController.tableView reloadData];
//    NSLog(@"button");
//    
//}

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
- (void)getSelectedStockDate
{
    if ([self.selectedStockCode count] > 0) {
        [_queue cancelAllOperations];
        NSMutableArray *searchURLKey=[[NSMutableArray alloc]initWithCapacity:20];
        for (NSInteger i=0; i<[self.selectedStockCode count]; i++) {
            NSString *tempCode=self.selectedStockCode[i];
            NSString *newTempCode;
            
            if ([tempCode hasPrefix:@"sh"]) {
                newTempCode=[tempCode stringByReplacingOccurrencesOfString:@"sh" withString:@"0"];
            }else{
                newTempCode=[tempCode stringByReplacingOccurrencesOfString:@"sz" withString:@"1"];
            }
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
                [self.tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self.tableView reloadData];
            }];
            [_queue addOperation:op];
            
        }
        [self.tableView reloadData];
    }
}

- (UIBarPosition) positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionTopAttached;//The search bar is “attached” to the top of the screen
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
//    for (NSDictionary *resultDict in array) {
//        
//        searchResults *searchResult;
//        
//        NSString *wrapperType = resultDict[@"wrapperType"];
//        NSString *kind = resultDict[@"kind"];
//        
//        if ([wrapperType isEqualToString:@"track"]) {
//            searchResult = [self parseTrack:resultDict];
//        } else if ([wrapperType isEqualToString:@"audiobook"]) {
//            searchResult = [self parseAudioBook:resultDict];
//        } else if ([wrapperType isEqualToString:@"software"]) {
//            searchResult = [self parseSoftware:resultDict];
//        } else if ([kind isEqualToString:@"ebook"]) {
//            searchResult = [self parseEBook:resultDict];
//        }
//        
//        if (searchResult != nil) {
//            [_searchResults addObject:searchResult];
//        }
//    }
}

- (void)showNetworkError{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Whoops..."
                              message:@"There was an error reading from the iTunes Store. Please try again."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    
    [alertView show];
}



- (void)getAllNameAndCode{
    self.allStockCode=[[NSMutableArray alloc]initWithCapacity:20];
    self.allStockName=[[NSMutableArray alloc]initWithCapacity:20];
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"nameAndCode" ofType:@"txt"];
     NSString *string=[NSString stringWithContentsOfFile:filePath encoding:NSUTF16StringEncoding error:nil];
    NSArray *array=[string componentsSeparatedByString:@"\n"];
//    NSLog(@"%@",array);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
