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

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchBar.placeholder = @"検索語句を入力";
    
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.tintColor = [UIColor colorWithRed:0.855 green:0.647 blue:0.125 alpha:1.0];
    searchBar.showsScopeBar = YES;
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"URL,Email", @"Phone", @"Date", nil];
    self.searchDisplayController.searchBar.barTintColor = [UIColor whiteColor];

    searchBar.showsCancelButton = NO;
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
{
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
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *item = [searchData objectAtIndex:indexPath.row];
        NSLog(@"%@",item);
    }else{
    DBManager *db = [DBManager sharedInstance];
    Memo *memo = (Memo *)[db.memosData objectAtIndex:indexPath.row];
    NSLog(@"%@",memo.content);
    
    cell.textLabel.text = memo.content;
    //cell.detailTextLabel.text = @"test";
    }
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // セルの内容はNSArray型の「items」にセットされているものとする
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        //検索キーワードが入力されている場合の処理.
        return [searchData count];
    }else{
    DBManager *db = [DBManager sharedInstance];
    NSInteger size;
    [db initDBManager];
    size = [db.memosData count];
    return size;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        DBManager *db = [DBManager sharedInstance];
        Memo *memo = (Memo *)[db.memosData objectAtIndex:indexPath.row];
        NSLog(@"%d",memo.MemoId);
        [db deleteMemo:memo];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBManager *db = [DBManager sharedInstance];
    Memo *memo = (Memo *)[db.memosData objectAtIndex:indexPath.row];
    NSLog(@"%@", memo.content);
    ContentViewController *c = [[ContentViewController alloc] initWithMemo:memo];
    [self.navigationController pushViewController:c animated:NO];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (void)filterContentForSearchText:(NSString*)searchString scope:(NSString*)scope {
    [searchData removeAllObjects];
    DBManager *db = [DBManager sharedInstance];
    NSMutableArray *memos = [db Memo];
    
    for(Memo *memo in memos) {
        NSRange range = [memo.content rangeOfString:searchString
                                     options:NSCaseInsensitiveSearch];
        if(range.length > 0)
            [searchData addObject:memo.content];
        NSLog(@"%@",memo.content);
    }
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString {
    [self filterContentForSearchText: searchString
                               scope: [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    NSLog(@"called search...");
    return YES;
}

@end
