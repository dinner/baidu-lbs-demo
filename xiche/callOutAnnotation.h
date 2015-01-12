//
//  callOutAnnotation.h
//  xiche
//
//  Created by Apple on 14-12-4.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "BMKAnnotationView.h"
#import "myPointCell.h"

@interface callOutAnnotation : BMKAnnotationView

@property(nonatomic,retain) UIView* contentView;
@property(nonatomic,retain) myPointCell* photoInfoView;

@end
