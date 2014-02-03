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
    Memo *memoObject = Memo.new;
    memoObject.title = @"いいい";
    NSLog(@"%@", memoObject.title);
    [db insertMemo: memoObject];
    NSArray *memo = [[DBManager sharedInstance] Memo];
    for (Memo *e in memo) {
		NSLog(@">> %d", e.MemoId);
        XCTAssertEqualObjects(e.title, @"いいい", @"check set title");
        NSLog(@">> %@", e.title);
        NSLog(@">> %@", e.created_at);
        NSLog(@">> %@", e.updated_at);
	}
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
