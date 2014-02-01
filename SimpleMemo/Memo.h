//
//  Memo.h
//  SimpleMemo
//
//  Created by Taiki Tada on 2014/01/25.
//  Copyright (c) 2014年 Taiki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Memo : NSObject

@property int MemoId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;

@end
