//
//  busPointCell.m
//  xiche
//
//  Created by Apple on 14-12-5.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "busPointCell.h"

@implementation busPointCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(busPointCell*)getInstance{
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"busPointCell" owner:self options:nil];
    busPointCell* pView = (busPointCell*)[array objectAtIndex:0];
    pView.ib_head.layer.masksToBounds = YES;
    pView.ib_head.layer.cornerRadius = 35.0f;
    pView.ib_head.userInteractionEnabled = YES;
    return pView;
}
//聊天按钮点击
- (IBAction)chatClicked:(id)sender {
    [self.delegate createChatRoom:@"erbi"];
}

@end
