//
//  busPointCell.h
//  xiche
//
//  Created by Apple on 14-12-5.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol busPointDelegate <NSObject>

-(void)createChatRoom:(NSString*)name;
@end

@interface busPointCell : UIView
@property (weak, nonatomic) IBOutlet UIImageView *ib_head;
@property(nonatomic,weak) id<busPointDelegate> delegate;
+(busPointCell*)getInstance;

@end
