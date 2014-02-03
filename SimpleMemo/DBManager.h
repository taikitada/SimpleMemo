//
//  DBManager.h
//  SimpleMemo
//
//  Created by Taiki Tada on 2014/01/24.
//  Copyright (c) 2014年 Taiki. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Memo.h"

@interface DBManager : NSObject

+ (DBManager *)sharedInstance;

@property (nonatomic, strong) FMDatabase *db;

- (void)initDBManager;
- (BOOL)beginTransaction;
- (void)commitTransaction;

- (BOOL)insertMemo:(Memo *)memo;
- (BOOL)deleteMemo:(Memo *)memo;
- (BOOL)updateMemo:(Memo *)memo;

- (NSMutableArray *)Memo;





@end
