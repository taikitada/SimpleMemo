//
//  MasterViewController.m
//  SimpleMemo
//
//  Created by taiki on 2/3/14.
//  Copyright (c) 2014 Taiki. All rights reserved.
//

#import "MasterViewController.h"
#import "TextAreaCell.h"
#import "ContentViewController.h"
#import "DBManager.h"


@implementation MasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIColor* color = [UIColor colorWithRed:0.855 green:0.647 blue:0.125 alpha:1.0];
    [[UIBarButtonItem appearanceWhenContainedIn:
    [UINavigationBar class], nil] setTintColor:color];
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButton_down:)];
    self.navigationItem.leftBarButtonItem = addButton;
    
    CGRect frame = CGRectMake(0, 0, 140.0, 20.0);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchBar.showsCancelButton = YES;
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchBar.placeholder = @"検索語句を入力";
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.tintColor = [UIColor colorWithRed:0.855 green:0.647 blue:0.125 alpha:1.0];

    
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"URL,Email", @"Phone", @"Date", nil];
    searchBar.showsScopeBar = YES;
    self.searchDisplayController.searchBar.barTintColor = [UIColor whiteColor];
    [searchBar sizeToFit];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.delegate = self;
    // UISearchBarを入れるためのコンテナViewをつくる
    UIView *searchBarContainer = [[UIView alloc] initWithFrame:searchBar.frame];
    
    [searchBarContainer addSubview:searchBar];
    
    // UINavigationBar上に、UISearchBarを追加
    self.tableView.tableHeaderView = searchBarContainer;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)addButton_down:(UIBarButtonItem *)sender
{
    NSLog(@"add button");
    DBManager *db = [DBManager sharedInstance];
    [db beginTransaction];
    int memoid = [db addMemo];
    [db commitTransaction];
    NSLog(@"add button end");
    Memo *memo = [[Memo alloc] init];
    memo.MemoId = memoid;
    NSLog(@"%d",memoid);
    
    ContentViewController *c = [[ContentViewController alloc] initWithMemo:memo];
    [self.navigationController pushViewController:c animated:NO];

}

- (void)viewDidAppear:(BOOL)animated
{   DBManager *db = [DBManager sharedInstance];
    db.memosData = [db Memo];
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSLog(@"called cellfor....");
    
    DBManager *db = [DBManager sharedInstance];
    Memo *memo = (Memo *)[db.memosData objectAtIndex:indexPath.row];
    //NSLog(@"%@",memo.content);
    
    cell.textLabel.text = memo.content;
    //cell.detailTextLabel.text = @"test";
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DBManager *db = [DBManager sharedInstance];
    NSInteger size;
    size = [db.memosData count];
    return size;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        DBManager *db = [DBManager sharedInstance];
        db.memosData = [db Memo];
        Memo *memo = (Memo *)[db.memosData objectAtIndex:indexPath.row];
        //NSLog(@"%d",memo.MemoId);
        [db deleteMemo:memo];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBManager *db = [DBManager sharedInstance];
    Memo *memo = (Memo *)[db.memosData objectAtIndex:indexPath.row];
    ContentViewController *c = [[ContentViewController alloc] initWithMemo:memo];
    [self.navigationController pushViewController:c animated:NO];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if(0 == searchText.length){
        DBManager *db = [DBManager sharedInstance];
        db.memosData = [db Memo];
        [self.tableView reloadData];
    }else{
        DBManager *db = [DBManager sharedInstance];
        [db searchMemo:searchText];
        for (NSInteger i = 0; i < [db.memosData count]; i++) {
            // 配列から要素を取得する
            Memo *memo = [db.memosData objectAtIndex:i];
            NSLog(@"%@", memo.content);
        }
        
    }
    [self.tableView reloadData];
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    DBManager *db = [DBManager sharedInstance];
    NSLog(@"called searchBar");
    db.memosData = [db selectMemos:selectedScope];
    [self.tableView reloadData];
}

@end
