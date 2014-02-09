//
//  MasterViewController.h
//  SimpleMemo
//
//  Created by taiki on 2/3/14.
//  Copyright (c) 2014 Taiki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
    NSArray *originalData;
    NSMutableArray *searchData;
}

@property (nonatomic, strong) NSMutableArray *memosData;

@end
