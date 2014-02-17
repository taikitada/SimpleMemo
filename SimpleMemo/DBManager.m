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
    LOG(@"called sharedInstance");

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
    LOG(@"%@",dir);
    
    BOOL needInitData = NO;
    if(![fm fileExistsAtPath:dbPath]){
        [self copyDataFile:@"data.sqlite"];
        needInitData = YES;
    }
    [self setDb:[FMDatabase databaseWithPath:dbPath]];
    [self open];
    
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
            LOG(@"%@", [error localizedDescription]);
            return NO;
        }
    }
    if(![fm copyItemAtPath:from toPath:to error:&error]){
        LOG(@"[DB ERROR] %@", [error localizedDescription]);
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

- (BOOL)close{
    if (![self.db close]) {
        LOG(@"Could not close db.");
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
    [self open];
    LOG(@"\nTransaction COMMIT");
    [self.db commit];
    [self.db close];
}

- (void)rollbackTransaction{
    [self open];
    LOG(@"\nTransaction ROLLBACK");
    [self.db rollback];
    [self.db close];
}

- (BOOL)insertMemo:(Memo *)memo{
    return [self insertMemo:memo withId:NO];
}

- (BOOL)insertMemo:(Memo *)memo withId:(BOOL)setId{
    LOG_METHOD;
    if(![self open]) return NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSDate* date = [NSDate date];
    NSString* dateStr = [formatter stringFromDate:date];
    //LOG(@"Date:%@",dateStr);
    
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

- (int)addMemo{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSDate* date = [NSDate date];
    NSString* dateStr = [formatter stringFromDate:date];
    if(![self open]) return NO;
    [self.db executeUpdate:@"INSERT INTO memo (title, content, created_at, updated_at) VALUES(?, ?, ?, ?)",
     @"タイトル",
     @"",
     dateStr,
     dateStr
     ];
    long long lastid = [self.db lastInsertRowId];
    //LOG(@"%lld", lastid);
    return (int) lastid;
}

- (NSMutableArray *)Memo{
    LOG_METHOD;
	if(![self open]) return nil;
	NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:0];
    
    FMResultSet *rs = [self.db executeQuery:@"\
                       SELECT id, title, content, created_at, updated_at \
                       FROM memo \
                       ORDER BY updated_at DESC, id ASC\
                       "];
    
    @autoreleasepool {
        while ([rs next]) {
            
            Memo *memo = [[Memo alloc] init];
            memo.MemoId = [rs intForColumn:@"id"];
            memo.title = [rs stringForColumn:@"title"];
            memo.content = [rs stringForColumn:@"content"];
            memo.updated_at = [rs stringForColumn:@"updated_at"];
            memo.created_at = [rs stringForColumn:@"created_at"];
            
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

- (void)searchMemo:(NSString *)searchtext{
    LOG_METHOD;
	[self open];
	NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *srchtxt = [[NSString alloc]init] ;
    srchtxt = [srchtxt stringByAppendingString:@"%%"];
    srchtxt = [srchtxt stringByAppendingString:searchtext];
    srchtxt = [srchtxt stringByAppendingString:@"%%"];
    
    FMResultSet *rs = [self.db executeQuery:@"\
                       SELECT id, title, content, created_at, updated_at \
                       FROM memo \
                       WHERE content like ?\
                       ORDER BY updated_at DESC, id ASC",
                       srchtxt];
    
    @autoreleasepool {
        while ([rs next]) {
            LOG(@"called loop");
            
            Memo *memo = [[Memo alloc] init];
            memo.MemoId = [rs intForColumn:@"id"];
            memo.title = [rs stringForColumn:@"title"];
            memo.content = [rs stringForColumn:@"content"];
            memo.updated_at = [rs stringForColumn:@"updated_at"];
            memo.created_at = [rs stringForColumn:@"created_at"];
            
            [data addObject:memo];
        }
    }
	[rs close];
	[self.db close];
    self.memosData = data;
}

- (void)replaceSelectedData:(NSString *)text memoid:(int)id{
    //LOG(@"%@",text);
    //LOG(@"%d",id);
    
}

- (BOOL)deleteMemo:(Memo *)memo{
    if(![self open]) return NO;
    [self.db beginTransaction];
    [self.db executeUpdate:@"DELETE FROM memo where id =?",
     @(memo.MemoId)];
    [self.db commit];
    [self.db close];
    self.memosData = [self Memo];
    return YES;
    
}

- (void)deleteDB{
    if(![self open]) LOG(@"Can't Open Database");
    [self.db executeUpdate:@"DELETE FROM memo"];
    [self.db close];
    
}

- (BOOL)updateMemo:(Memo *)memo{
    LOG_METHOD;
//	if(![self open]) return nil;
    
    return NO;
    
}

- (NSMutableArray *)selectMemos:(NSInteger)selectedID{
    if(![self open]) return nil;
    LOG(@"in selectMemos");
    NSMutableArray *memos = [[NSMutableArray alloc] initWithCapacity:0];
    [self.db setTraceExecution:YES];
    NSString *match_type;
    LOG(@"%ld",selectedID);
    if(selectedID == 1){
        match_type = @"url";
    }else if (selectedID == 2){
        match_type = @"tel";
    }else if(selectedID == 3){
        match_type = @"date";
    }else {
        match_type = @"";
    }
    LOG(@"%@", match_type);
    NSString *srcmatch;
    srcmatch = @"%";
    srcmatch = [srcmatch stringByAppendingString:match_type];
    srcmatch = [srcmatch stringByAppendingString:@"%"];
    LOG(@"%@",srcmatch);
    
    FMResultSet *rs = [self.db executeQuery:@"\
                       SELECT id, title, content, created_at, updated_at, match_type \
                       FROM memo \
                       WHERE match_type like ?\
                       ORDER BY updated_at DESC, id ASC",
                       srcmatch];
    @autoreleasepool {
        while ([rs next]) {
            LOG(@"called loop");
            
            Memo *memo = [[Memo alloc] init];
            memo.MemoId = [rs intForColumn:@"id"];
            memo.title = [rs stringForColumn:@"title"];
            memo.content = [rs stringForColumn:@"content"];
            memo.updated_at = [rs stringForColumn:@"updated_at"];
            memo.created_at = [rs stringForColumn:@"created_at"];
            
            [memos addObject:memo];
        }
    }
    if(selectedID == 0){
        memos = [self Memo];
    }
    return memos;
    
}

- (BOOL)updateMemo:(NSString *)content memoid:(int)MemoID{
    LOG_METHOD;
    if(![self open]) return NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSDate* date = [NSDate date];
    NSString* dateStr = [formatter stringFromDate:date];
    //LOG(@"%d",MemoID);
    
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate|NSTextCheckingTypeAddress|
                                    NSTextCheckingTypeLink|
                                    NSTextCheckingTypePhoneNumber|NSTextCheckingTypeTransitInformation
                                                                   error:nil];
    
    
    //チェックでマッチした結果がまとめて返ってくる
    NSMutableArray *match_types = [[NSMutableArray alloc] init];
    NSArray *matches = [linkDetector matchesInString:content
                                             options:0
                                               range:NSMakeRange(0,[content length])];
    
    //結果を1件ずつ比較する
    for (NSTextCheckingResult *match in matches) {
        //Linkにマッチしたら
        if ([match resultType] == NSTextCheckingTypeLink) {
            [match_types addObject:@("url")];
        } else if ([match resultType] == NSTextCheckingTypePhoneNumber) {
            [match_types addObject:@("tel")];
        } else if([match resultType] == NSTextCheckingTypeDate){
            [match_types addObject:@("date")];
        } else if ([match resultType] == NSTextCheckingTypeAddress){;
        }
    }
    NSString *str = [match_types componentsJoinedByString:@","];
   
    LOG(@"content:%@",content);
    LOG(@"date:%@",dateStr);
    LOG(@"match_types:%@",str);

    [self.db executeUpdate:@"UPDATE memo SET content = ?, match_type = ?, updated_at = ? WHERE id = ?",
     content,
     str,
     dateStr,
     @(MemoID)];
    self.memosData = [self Memo];
    /*
    if ([self.db hadError]) {
        LOG(@"Err %d: %@", [self.db lastErrorCode], [self.db lastErrorMessage]);
        [self rollbackTransaction];
        return NO;
    }
     */
    return YES;
}









@end

