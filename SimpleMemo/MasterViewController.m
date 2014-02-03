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

@implementation MasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIColor* color = [UIColor colorWithRed:0.855 green:0.647 blue:0.125 alpha:1.0];
    [[UIBarButtonItem appearanceWhenContainedIn:
      [UINavigationBar class], nil] setTintColor:color];
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButton_down:)];
    self.navigationItem.leftBarButtonItem = addButton;
    NSLog(@"%@", [[NSBundle mainBundle] bundlePath]);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    searchBar.placeholder = @"検索語句を入力";
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.showsCancelButton = NO;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    //searchBar.delegate = self;
    
    // UISearchBarを入れるためのコンテナViewをつくる
    UIView *searchBarContainer = [[UIView alloc] initWithFrame:searchBar.frame];
    [searchBarContainer addSubview:searchBar];
    
    // UINavigationBar上に、UISearchBarを追加
    self.navigationItem.titleView = searchBarContainer;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 200, 44);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)addButton_down:(UIBarButtonItem *)sender
{
    NSString *newData = @"";
    ContentViewController *contentviewcontroller = [[ContentViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:contentviewcontroller animated:NO];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[TextAreaCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    float cellheight  = cell.frame.size.height;
    NSLog(@"%f",cellheight);
    NSLog(@"%d",indexPath.row);
//NSString *str1 = (NSString *)[datacontroller objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = str1;
    //cell.detailTextLabel.text = @"test";
    
    return cell;
}


@end
