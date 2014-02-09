//
//  ContentViewController.h
//  SimpleMemo
//
//  Created by taiki on 2/3/14.
//  Copyright (c) 2014 Taiki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memo.h"

@interface ContentViewController : UIViewController

@property (nonatomic, strong) Memo *memo;

- (id)initWithMemo:(Memo *)memo;

@end
