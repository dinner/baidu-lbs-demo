//
//  CalloutMapAnnotation.m
//  xiche
//
//  Created by Apple on 14-12-5.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation


- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon{
    if (self = [super init]) {
        self.latitude = lat;
        self.longitude = lon;
    }
    return self;
}
-(CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}


@end
