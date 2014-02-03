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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;

    tv = [[UITextView alloc] init];
    tv.frame = self.view.frame;
    //tv.text = [datacontroller getSelectedData];
    [tv becomeFirstResponder];
    
    [self.view addSubview:tv];
	// Do any additional setup after loading the view.
}

-(IBAction)back {
        
    
    [[self navigationController] popViewControllerAnimated:NO];
    
    
}



@end
