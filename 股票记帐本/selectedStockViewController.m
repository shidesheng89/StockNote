//
//  selectedStockViewController.m
//  股票记帐本
//
//  Created by 施德胜 on 15/10/6.
//  Copyright © 2015年 施德胜. All rights reserved.
//

#import "selectedStockViewController.h"

static NSString *cellIdentifier=@"cellIdentifier";

@interface selectedStockViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation selectedStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchBar=_searchBar;
//    self.tableView.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=@"1";
    return cell;
}

#pragma mark searchBar
- (UIBarPosition) positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionTopAttached;//The search bar is “attached” to the top of the screen
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
