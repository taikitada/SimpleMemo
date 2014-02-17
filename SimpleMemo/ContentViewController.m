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
    LOG(@"%d",self.memo.MemoId);
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
    LOG(@"%@",tv.text);
    if (tv.text.length == 0){
    }else{
        LOG(@"make memo");
        LOG(@"%d",self.memo.MemoId);
        DBManager *db = [DBManager sharedInstance];
        if(self.memo.MemoId == -1){
            LOG(@"%d", self.memo.MemoId);
            Memo *memo = [[Memo alloc] init];
            memo.MemoId = [db addMemo];
            [db updateMemo:tv.text memoid:memo.MemoId];
            [db close];
        }else{
            [db updateMemo:tv.text memoid:self.memo.MemoId];
        }
        
    }
}







@end
