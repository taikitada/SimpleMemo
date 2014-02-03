//
//  DBManager.m
//  SimpleMemo
//
//  Created by Taiki Tada on 2014/01/24.
//  Copyright (c) 2014年 Taiki. All rights reserved.
//

#import "DBManager.h"

@interface DBManager()

@end

@implementation DBManager

static id _instance = nil;

+ (DBManager *)sharedInstance{

    @synchronized(self) {
        if (!_instance) {
            _instance = [[self alloc] init];
            [_instance initDBManager];
        }
    }
    return (DBManager *)_instance;
}

- (void)initDBManager{

    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    NSString *dbPath = [dir stringByAppendingPathComponent:@"data.sqlite"];
    
    BOOL needInitData = NO;
    if(![fm fileExistsAtPath:dbPath]){
        [self copyDataFile:@"data.sqlite"];
        needInitData = YES;
    }
    [self setDb:[FMDatabase databaseWithPath:dbPath]];
    
    [self alterTable];
    if(needInitData){
//        [self insertInitData];
    }
    
#ifdef DB_TRACE_ON
    [self.db setTraceExecution:YES];
#endif
}


- (BOOL)copyDataFile:(NSString *)fileName{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    NSString *from = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSString *to = [dir stringByAppendingPathComponent:fileName];

    NSError *error;
    if(![fm fileExistsAtPath:dir]){
        if(![fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error]){
//            LOG(@"%@", [error localizedDescription]);
            return NO;
        }
    }
    if(![fm copyItemAtPath:from toPath:to error:&error]){
//        LOG(@"[DB ERROR] %@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

- (void)alterTable{
    LOG_METHOD;
}

- (BOOL)open{
    if (![self.db open]) {
        LOG(@"Could not open db.");
        return NO;
    }
    return YES;
}

- (BOOL)beginTransaction{
    LOG(@"\nTransaction START");
    if(![self open]) return NO;
    [self.db beginTransaction];
    return YES;
}

- (void)commitTransaction{
    LOG(@"\nTransaction COMMIT");
    [self.db commit];
    [self.db close];
}

- (void)rollbackTransaction{
    LOG(@"\nTransaction ROLLBACK");
    [self.db rollback];
    [self.db close];
}

- (BOOL)insertMemo:(Memo *)memo{
    NSLog(@"called insertMemo");
    return [self insertMemo:memo withId:NO];
}

- (BOOL)insertMemo:(Memo *)memo withId:(BOOL)setId{
    LOG_METHOD;
    if(![self open]) return NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSDate* date = [NSDate date];
    NSString* dateStr = [formatter stringFromDate:date];
    //NSLog(@"Date:%@",dateStr);
    
    if(setId){
        [self.db executeUpdate:@"INSERT INTO memo (id, title, content, created_at, updated_at) VALUES(?, ?, ?, ?, ?)",
         @(memo.MemoId),
         memo.title,
         memo.content,
         dateStr,
         dateStr
         ];
    }else{
        [self.db executeUpdate:@"INSERT INTO memo (title, content, created_at, updated_at) VALUES(?, ?, ?, ?)",
         memo.title,
         memo.content,
         dateStr,
         dateStr];
    }
    
    if ([self.db hadError]) {
        LOG(@"Err %d: %@", [self.db lastErrorCode], [self.db lastErrorMessage]);
        [self rollbackTransaction];
        return NO;
    }
    return YES;
}

- (NSMutableArray *)Memo{
    LOG_METHOD;
	if(![self open]) return nil;
	NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:0];
    
    FMResultSet *rs = [self.db executeQuery:@"\
                       SELECT id, title, content, created_at, updated_at \
                       FROM memo \
                       ORDER BY updated_at ASC, id ASC\
                       "];
    
    @autoreleasepool {
        while ([rs next]) {
            
            
            Memo *memo = [[Memo alloc] init];
            memo.MemoId = [rs intForColumn:@"id"];
            NSLog(@"%d", memo.MemoId);
            NSString *title = [rs stringForColumn:@"title"];
            NSLog(@"%@",title);
            NSString *updated_at = [rs stringForColumn:@"updated_at"];
            NSLog(@"%@",updated_at);
            memo.updated_at = updated_at;
            NSString *created_at = [rs stringForColumn:@"created_at"];
            NSLog(@"%@",created_at);
            
            
            if([title rangeOfString:@"POCKET_"].location != NSNotFound){
                memo.title = LS(title);
            }else{
                memo.title = title;
            }
            [data addObject:memo];
        }
    }
	[rs close];
	[self.db close];
    
	if([data count] > 0){	
		return data;
	}
	return nil;
}

- (BOOL)deleteMemo:(Memo *)memo{
    return NO;
    
}

- (BOOL)updateMemo:(Memo *)memo{
    LOG_METHOD;
//	if(![self open]) return nil;
    
    return NO;
    
}







@end

