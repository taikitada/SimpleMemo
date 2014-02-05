//
//  SimpleMemoModelTests.m
//  SimpleMemoModelTests
//
//  Created by taiki on 2/2/14.
//  Copyright (c) 2014 Taiki. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DBManager.h"

@interface SimpleMemoModelTests : XCTestCase

@end

@implementation SimpleMemoModelTests

- (void)setUp
{
    [super setUp];
    
    

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    DBManager *db = [DBManager sharedInstance];
    [db deleteDB];
    Memo *memoInstance = Memo.new;
    memoInstance.title = @"タイトル";
    memoInstance.content = @"内容です。";
    [db insertMemo: memoInstance];
    memoInstance.title = @"タイトル1";
    memoInstance.content = @"内容2です。";
    [db insertMemo: memoInstance];
    
    NSArray *memo = [db Memo];
    int count = 0;
    for (Memo *e in memo) {
		NSLog(@">> %d", e.MemoId);
        if(count==0){
        XCTAssertEqualObjects(e.title, @"タイトル", @"check set title");
        }else{
        XCTAssertEqualObjects(e.title, @"タイトル1", @"check set title");
        }
        NSLog(@">> %@", e.title);
        NSLog(@">> %@", e.created_at);
        NSLog(@">> %@", e.updated_at);
        count++;
    }
    NSMutableArray *titles = [db MemoTitles];
    for (NSString *title in titles) {
        NSLog(@"%@",title);
    };
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
