//
//  ContentViewController.m
//  SimpleMemo
//
//  Created by taiki on 2/3/14.
//  Copyright (c) 2014 Taiki. All rights reserved.
//

#import "ContentViewController.h"
#import "DBManager.h"

@implementation ContentViewController
{
    UITextView *tv;
    UINavigationController *navigationController;
}

- (id)initWithMemo:(Memo *)memo{
	if(self = [super init]){
        self.memo = memo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"一覧へ戻る" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.rightBarButtonItem = nil;

    tv = [[UITextView alloc] init];
    tv.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tv.frame = self.view.frame;
    tv.text = self.memo.content;
    [tv becomeFirstResponder];
    
    [self.view addSubview:tv];
	// Do any additional setup after loading the view.
}

-(IBAction)back {
    
    [[self navigationController] popViewControllerAnimated:NO];

}

- (void)viewDidDisappear:(BOOL)animated
{
    DBManager *db = [DBManager sharedInstance];
    [db updateMemo:tv.text memoid:self.memo.MemoId];
}







@end
