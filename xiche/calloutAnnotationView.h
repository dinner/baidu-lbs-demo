//
//  calloutAnnotationView.h
//  xiche
//
//  Created by Apple on 14-12-5.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "BMKAnnotationView.h"
#import "busPointCell.h"
#import "BMapKit.h"

@interface calloutAnnotationView : BMKAnnotationView

//@property(retain,nonatomic) UIView* contentView;
@property(nonatomic,retain) busPointCell* busInfoCell;


@end
