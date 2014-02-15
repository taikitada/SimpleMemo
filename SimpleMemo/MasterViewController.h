//
//  MasterViewController.h
//  SimpleMemo
//
//  Created by taiki on 2/3/14.
//  Copyright (c) 2014 Taiki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface MasterViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *memosData;
@property (nonatomic, strong) DBManager *dm;

@end
