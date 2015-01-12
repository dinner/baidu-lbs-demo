//
//  CalloutMapAnnotation.h
//  xiche
//
//  Created by Apple on 14-12-5.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface CalloutMapAnnotation : NSObject<BMKAnnotation>

@property(nonatomic) CLLocationDegrees latitude;
@property(nonatomic) CLLocationDegrees longitude;
@property(retain,nonatomic) NSDictionary *locationInfo;//callout吹出框要显示的各信息
- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;

@end
