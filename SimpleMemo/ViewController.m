//
//  ViewController.m
//  SimpleMemo
//
//  Created by Taiki Tada on 2014/01/24.
//  Copyright (c) 2014年 Taiki. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    Memo *memoObject = Memo.new;
    memoObject.title = @"いいい";
    DBManager *db = [DBManager sharedInstance];
    [db insertMemo: memoObject];
    
    NSArray *memo = [[DBManager sharedInstance] Memo];
   
    
    
    for (Memo *e in memo) {
		LOG(@">> %d", e.MemoId);
        LOG(@">> %@", e.title);
        LOG(@">> %@", e.created_at);
        LOG(@">> %@", e.updated_at);
	}
    
    
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
