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

static NSString *cellIdentifier=@"cellIdentifier";
static NSString *tabCellIdentifier=@"tabCellIdentifier";

@interface selectedStockViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *allStockCode;
@property (strong, nonatomic) NSMutableArray *allStockName;
@end

@implementation selectedStockViewController{
    BOOL _isLoading;
    NSOperationQueue *_queue;
    int sectionNumber;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _queue = [[NSOperationQueue alloc] init];//试验，记得删
    [self getAllNameAndCode];
    
    self.tableView.rowHeight=44;
//    UINib *nib=[UINib nibWithNibName:@"selectedStockTableViewCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
//    UINib *tabNib=[UINib nibWithNibName:@"tabTableViewCell" bundle:nil];
//    [self.tableView registerNib:tabNib forCellReuseIdentifier:tabCellIdentifier];
    self.tableView.contentInset=UIEdgeInsetsMake(0.01, 0, 0, 0);//取消掉在heightForHeaderInSection设置的0.01
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.searchController.active) {
//        return [self.searchResults count];
//    }else{
//        return 0;
//    }
    if (section==0) {
        return 1;
    }else if(section==1){
        NSLog(@"numberOfRowsInSection%lu",(unsigned long)[self.searchResults count]);
        return [self.searchResults count];
    }else{
        return 0;
    }
//    return [self.searchResults count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01f;
    }else{
        return 2.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UINib *tabNib=[UINib nibWithNibName:@"tabTableViewCell" bundle:nil];
        [self.tableView registerNib:tabNib forCellReuseIdentifier:tabCellIdentifier];
        tabTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tabCellIdentifier forIndexPath:indexPath];
        return cell;
    }else if(indexPath.section==1){
        UINib *nib=[UINib nibWithNibName:@"selectedStockTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        selectedStockTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        SearchResults *searchResult=self.searchResults[indexPath.row];
        cell.name.text=searchResult.nameOfStock;
        cell.code.text=searchResult.stockCode;
        cell.price.text=[NSString stringWithFormat:@"%.2f",[searchResult.price floatValue]];
        float percent=[searchResult.percent floatValue];
        if (percent>0) {
            cell.percent.textColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:1];
            cell.percent.text=[NSString stringWithFormat:@"+%.2f%%",[searchResult.percent floatValue]*100];
        }else if (percent==0){
            cell.percent.textColor=[UIColor colorWithWhite:0 alpha:1];
            cell.percent.text=[NSString stringWithFormat:@"%.2f%%",[searchResult.percent floatValue]*100];
        }else if (percent<0){
            cell.percent.textColor=[UIColor colorWithRed:0 green:1 blue:0 alpha:1];
            cell.percent.text=[NSString stringWithFormat:@"%.2f%%",[searchResult.percent floatValue]*100];
        }
        NSLog(@"111");
        return cell;
    }else{
        return nil;
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




//- (NSString *)getSubstring:(NSString *)string parameter:(NSString *)parameterName{
//    //NSRegularExpression类里面调用表达的方法需要传递一个NSError的参数。下面定义一个
//    NSError *error;
//    
//    //http+:[^\\s]* 这个表达式是检测一个网址的。(?<=title\>).*(?=</title)截取html文章中的<title></title>中内文字的正则表达式
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=title\\>).*(?=</title)"options:0 error:&error];
//    
//    if (regex != nil) {
//        NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
//        
//        if (firstMatch) {
//            NSRange resultRange = [firstMatch rangeAtIndex:0];
//            
//            //从urlString当中截取数据
//            NSString *result=[urlString substringWithRange:resultRange];
//            //输出结果
//            NSLog(@"->%@<-",result);
//        }    
//        
//    }
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchResults=[[NSMutableArray alloc]initWithCapacity:20];

    [self performSearch];
    NSLog(@"numberOfRowsInSection111%lu",(unsigned long)[self.searchResults count]);
}

- (void)performSearch
{
    if ([self.searchBar.text length] > 0) {
        [_queue cancelAllOperations];
        NSMutableArray *searchURLKey=[[NSMutableArray alloc]initWithCapacity:20];
        [self.searchBar resignFirstResponder];
        for (NSInteger i=0; i<[self.allStockCode count]; i++) {
            NSString *tempCode=self.allStockCode[i];
            NSString *tempName=self.allStockName[i];
            NSString *newTempCode;
            if ([tempCode containsString:self.searchBar.text]||[tempName containsString:self.searchBar.text]) {
                if ([tempCode hasPrefix:@"sh"]) {
                    newTempCode=[tempCode stringByReplacingOccurrencesOfString:@"sh" withString:@"0"];
                }else{
                    newTempCode=[tempCode stringByReplacingOccurrencesOfString:@"sz" withString:@"1"];
                }
                [searchURLKey addObject:newTempCode];
            }
        }
        NSLog(@"count%lu",(unsigned long)[searchURLKey count]);
        for (NSInteger i=0; i<[searchURLKey count]&&i<4; i++) {
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
                NSLog(@"success");
                NSLog(@"%lu",(unsigned long)[self.searchResults count]);
                [self.tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self.tableView reloadData];
            }];
            [_queue addOperation:op];
            
        }
//        _isLoading = YES;
//        [self.tableView reloadData];
        
        [self.tableView reloadData];
    }
}
//- (NSComparisonResult)compareName:(SearchResult *)other
//{
//    return [self.name localizedStandardCompare:other.name];
//}

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
    SearchResults *results=[[SearchResults alloc]init];
    results.nameOfStock=dictionary[@"name"];
    results.stockCode=[NSString stringWithFormat:@"%@%@",dictionary[@"type"],dictionary[@"symbol"]];
    results.price=dictionary[@"price"];
    results.percent=dictionary[@"percent"];
    [self.searchResults addObject:results];
    NSLog(@"searchResults22%lu",(unsigned long)[_searchResults count]);
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
