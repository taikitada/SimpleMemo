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
        
        self.tv = [[UITextView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10)];
        self.tv.userInteractionEnabled =YES;
        
        [self.contentView addSubview:self.tv];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"I'm a button" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}


@end
