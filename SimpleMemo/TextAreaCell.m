//
//  TextAreaCell.m
//  SimpleMemo
//
//  Created by taiki on 2/3/14.
//  Copyright (c) 2014 Taiki. All rights reserved.
//

#import "TextAreaCell.h"

@interface TextAreaCell()

@property (nonatomic, strong) UITextView *tv;

@end

@implementation TextAreaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //self.tv = [[UITextView alloc] initWithFrame:CGRectInset(self.bounds, 100, 10)];
        self.tv.userInteractionEnabled =YES;
        //self.tv.text = @"hogehoge";
        
        [self.contentView addSubview:self.tv];
    }
    return self;
}




@end
