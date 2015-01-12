//
//  ViewController.m
//  xiche
//
//  Created by Apple on 14-12-3.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "BMapKit.h"
#import "calloutAnnotationView.h"
#import "CustomPointAnnotation.h"
#import "CalloutMapAnnotation.h"
//#import "RCIM.h"

bool bIsLocSuc;//是否定位成功
@interface ViewController ()<BMKMapViewDelegate,BMKCloudSearchDelegate,BMKLocationServiceDelegate,busPointDelegate>
{
    BMKMapView* mapView;
    BMKCloudSearch* search;
    BMKLocationService* location;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = CGRectMake(0, 0, 320, 450);
    mapView = [[BMKMapView alloc] initWithFrame:rect];
    [self.view addSubview:mapView];
    mapView.showsUserLocation= YES;
    bIsLocSuc = NO;
    //搜索
    search = [[BMKCloudSearch alloc] init];
    search.delegate = self;
    //服务
    location = [[BMKLocationService alloc] init];//开始定位
    [location startUserLocationService];
    mapView.showsUserLocation = NO;
    mapView.userTrackingMode = BMKUserTrackingModeFollow;
    mapView.showsUserLocation = YES;
    [_ib_tview setEditable:false];
    [_ib_tview setTintColor:[UIColor blackColor]];
}
-(void)viewWillAppear:(BOOL)animated{
    [mapView viewWillAppear];
    mapView.delegate = self;
    location.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [mapView viewWillDisappear];
    mapView.delegate = nil;
    location.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回云检索结果回调
- (void)onGetCloudPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:mapView.annotations];
    [mapView removeAnnotations:array];
    if (error == BMKErrorOk) {
        BMKCloudPOIList* result = [poiResultList objectAtIndex:0];
        for (int i = 0; i < result.POIs.count; i++) {
            BMKCloudPOIInfo* poi = [result.POIs objectAtIndex:i];
//            BMKPointAnnotation* item = [[BMKPointAnnotation alloc] init];
//            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){ poi.longitude,poi.latitude};
//            item.coordinate = pt;
//            item.title = poi.title;
//            [mapView addAnnotation:item];
            NSDictionary* dic = poi.customDict;
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){ poi.longitude,poi.latitude};
            NSLog(@"%f %f",poi.longitude,poi.latitude);
            CustomPointAnnotation* pointAnnoatation = [[CustomPointAnnotation alloc] init];
            pointAnnoatation.title = poi.title;
            pointAnnoatation.coordinate = pt;
            pointAnnoatation.pointCallOutInfo = dic;
            [mapView addAnnotation:pointAnnoatation];
        }
    } else {
        NSLog(@"error ==%d",error);
    }
}
//
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    [mapView updateLocationData:userLocation];
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    if (!bIsLocSuc) {//定位未成功
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray* placeMarks,NSError* error){
        for (CLPlacemark* placemark in placeMarks) {
            NSDictionary* dic =placemark.addressDictionary;
            NSString* strCity = dic[@"City"];
            NSString* strStreet = dic[@"Street"];
            NSString* strStree = [NSString stringWithFormat:@"%@%@",strCity,strStreet];
            [_ib_tview setText:strStree];
            bIsLocSuc = YES;//定位成功
        }
    }];
    }
}
//根据返回的anotation对应的展示view
- (BMKAnnotationView *)mapView:(BMKMapView *)map viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CalloutMapAnnotation* ann = (CalloutMapAnnotation*)annotation;
        calloutAnnotationView* calloutAnnoatationView = (calloutAnnotationView*)[map dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
        //否则创建新的calloutView
        if (!calloutAnnoatationView) {
            calloutAnnoatationView = [[calloutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"];
//            busPointCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"busPointCell" owner:self options:nil] objectAtIndex:0];
//            cell.ib_head.layer.cornerRadius = 34.0f;
//            cell.ib_head.layer.masksToBounds = YES;
//            cell.delegate = self;
//            [calloutAnnoatationView.contentView addSubview:cell];
//            calloutAnnoatationView.busInfoCell = cell;
        }
        return calloutAnnoatationView;
    }
    else{//custom annotation
        BMKPinAnnotationView* annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        UIImage* image = [UIImage imageNamed:@"head.png"];
        annotationView.image = [self reSizeImage:image toSize:CGSizeMake(40, 50)];
        [annotationView setAnimatesDrop:YES];
        return annotationView;
    }
}
//点击annotation
-(void)mapView:(BMKMapView *)map didSelectAnnotationView:(BMKAnnotationView *)view{
    CustomPointAnnotation *annn = (CustomPointAnnotation*)view.annotation;
    CalloutMapAnnotation *_calloutMapAnnotation;
    if ([view.annotation isKindOfClass:[CustomPointAnnotation class]]) {
        //如果点到了这个marker点，什么也不做
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        //如果当前显示着calloutview，又触发了select方法，删除这个calloutview annotation
        if (_calloutMapAnnotation) {
            [map removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation=nil;
            
        }
        //创建搭载自定义calloutview的annotation
        _calloutMapAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude] ;
        
        //把通过marker(ZNBCPointAnnotation)设置的pointCalloutInfo信息赋值给CalloutMapAnnotation
        _calloutMapAnnotation.locationInfo = annn.pointCallOutInfo;
        
        [map addAnnotation:_calloutMapAnnotation];
        [map setCenterCoordinate:view.annotation.coordinate animated:YES];
    }
}
//点击除annotation以外的点
-(void)mapView:(BMKMapView *)map didDeselectAnnotationView:(BMKAnnotationView *)view{
    
//    if (view&&![view isKindOfClass:[CalloutMapAnnotation class]]) {
//        CalloutMapAnnotation* pCallView = (CalloutMapAnnotation*)view;
//        if (pCallView.coordinate.latitude == view.annotation.coordinate.latitude&&
//            pCallView.coordinate.longitude == view.annotation.coordinate.longitude) {
//            [map removeAnnotation:pCallView];
//            pCallView = nil;
//        }
//    }
}

//缩放图片
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}
//附近的车
- (IBAction)btNearCar:(id)sender {
    BMKCloudLocalSearchInfo *cloudLocalSearch = [[BMKCloudLocalSearchInfo alloc] init];
    cloudLocalSearch.ak = @"pjzXs0beL65WCNiRvtLrOe5X";
    cloudLocalSearch.geoTableId = 87197;
    cloudLocalSearch.pageIndex = 0;
    cloudLocalSearch.pageSize = 8;
    //
    cloudLocalSearch.region = @"成都市";
    cloudLocalSearch.keyword = @"洗车";
    BOOL flag = [search localSearchWithSearchInfo:cloudLocalSearch];
    if (flag) {
        NSLog(@"本地云检索成功");
    }
    else{
        NSLog(@"本地云检索失败");
    }
}
//聊天
- (IBAction)btChat:(id)sender {
    // 连接融云服务器。
//    [RCIM connectWithToken:@"91TB4K+Mb8TsukkIL5GpT83M5zFgHBLtnxORiCSZozEJercO5VVEEwX4UD42Dls/4tcJwAWNhLo=" completion:^(NSString *userId) {
//        // 此处处理连接成功。
//        NSLog(@"Login successfully with userId: %@.", userId);
//        
//        RCChatListViewController *chatListViewController = [[RCIM sharedRCIM]createConversationList:^(){
//            // 创建 ViewController 后，调用的 Block，可以用来实现自定义行为。
//        }];
//        
//        // 把客服聊天视图控制器添加到导航栈。
//        [self.navigationController pushViewController:chatListViewController animated:YES];
//        
//    } error:^(RCConnectErrorCode status) {
//        // 此处处理连接错误。
//        NSLog(@"Login failed.");
//    }];
}
#pragma mark busPointDelegate
-(void)createChatRoom:(NSString *)name{
//    // 连接融云服务器。
//    [RCIM connectWithToken:@"91TB4K+Mb8TsukkIL5GpT83M5zFgHBLtnxORiCSZozEJercO5VVEEwX4UD42Dls/4tcJwAWNhLo=" completion:^(NSString *userId) {
//        // 此处处理连接成功。
//        NSLog(@"Login successfully with userId: %@.", userId);
//        
//        // 创建单聊视图控制器。
//        RCChatViewController *chatViewController = [[RCIM sharedRCIM]createPrivateChat:name title:@"自问自答" completion:^(){
//            // 创建 ViewController 后，调用的 Block，可以用来实现自定义行为。
//        }];
//        
//        // 把单聊视图控制器添加到导航栈。
//        [self.navigationController pushViewController:chatViewController animated:YES];
//        
//    } error:^(RCConnectErrorCode status) {
//        // 此处处理连接错误。
//        NSLog(@"Login failed.");
//    }];
}




@end
