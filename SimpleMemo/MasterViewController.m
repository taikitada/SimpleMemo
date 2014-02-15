//
//  MasterViewController.m
//  SimpleMemo
//
//  Created by taiki on 2/3/14.
//  Copyright (c) 2014 Taiki. All rights reserved.
//

#import "MasterViewController.h"
#import "ContentViewController.h"


@implementation MasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.dm = [DBManager sharedInstance];
        self.memosData = [self.dm Memo];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = @"削除";
    UIColor* color = [UIColor colorWithRed:0.855 green:0.647 blue:0.125 alpha:1.0];
    [[UIBarButtonItem appearanceWhenContainedIn:
    [UINavigationBar class], nil] setTintColor:color];
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"新規" style:UIBarButtonItemStyleBordered target:self action:@selector(addButton_down:)];
    self.navigationItem.leftBarButtonItem = addButton;
    
    CGRect frame = CGRectMake(0, 0, 140.0, 20.0);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:color];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchBar.placeholder = @"検索語句を入力";
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.tintColor = [UIColor colorWithRed:0.855 green:0.647 blue:0.125 alpha:1.0];

    
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"全て", @"URL,Email", @"電話番号", @"日付", nil];
    searchBar.showsScopeBar = YES;
    self.searchDisplayController.searchBar.barTintColor = [UIColor whiteColor];
    [searchBar sizeToFit];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
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
    Memo *memo = [[Memo alloc] init];
    memo.MemoId = -1;
                  
    ContentViewController *c = [[ContentViewController alloc] initWithMemo:memo];
    [self.navigationController pushViewController:c animated:NO];

}
- (void)viewDidAppear:(BOOL)animated{
    self.memosData = [self.dm Memo];
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Memo *memo = (Memo *)[self.memosData objectAtIndex:indexPath.row];
    //NSLog(@"%@",memo.content);
    
    cell.textLabel.text = memo.content;
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    NSArray *arr;
    arr = [memo.updated_at componentsSeparatedByString:@" "];
    
    cell.detailTextLabel.text = arr[0];
    UIFont *font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.font = font;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger size;
    size = [self.memosData count];
    NSLog(@"%ld",size);
    return size;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        Memo *memo = (Memo *)[self.memosData objectAtIndex:indexPath.row];
        [self.dm deleteMemo:memo];
        self.memosData = [self.dm Memo];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    Memo *memo = (Memo *)[self.memosData objectAtIndex:indexPath.row];
    ContentViewController *c = [[ContentViewController alloc] initWithMemo:memo];
    [self.navigationController pushViewController:c animated:NO];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if(0 == searchText.length){
        self.memosData = [self.dm Memo];
        [self.tableView reloadData];
    }else{
        [self.dm searchMemo:searchText];
        for (NSInteger i = 0; i < [self.memosData count]; i++) {
            // 配列から要素を取得する
            Memo *memo = [self.memosData objectAtIndex:i];
            NSLog(@"%@", memo.content);
        }
        
    }
    [self.tableView reloadData];
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    self.memosData = [self.dm selectMemos:selectedScope];
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.memosData = [self.dm Memo];
    searchBar.text = @"";
    [self.tableView endEditing:YES];
    [self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing)
    {
        self.editButtonItem.title = NSLocalizedString(@"キャンセル", @"キャンセル");
    }
    else
    {
        self.editButtonItem.title = NSLocalizedString(@"削除", @"削除");
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"削除";
}




@end
