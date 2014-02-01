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
    NSLog(@"start_load");
    Memo *memoObject = Memo.new;
    memoObject.title = @"いいい";
    
    NSLog(@"%@", memoObject.title);
    DBManager *db = [DBManager sharedInstance];
    [db insertMemo: memoObject];
    
    NSArray *memo = [[DBManager sharedInstance] Memo];
   
    
    
    for (Memo *e in memo) {
		NSLog(@">> %d", e.MemoId);
        NSLog(@">> %@", e.title);
        NSLog(@">> %@", e.created_at);
        NSLog(@">> %@", e.updated_at);
	}
    
    
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
