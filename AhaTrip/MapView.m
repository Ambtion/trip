//
//  MapVC.m
//  Line0New
//
//  Created by line0 on 13-4-22.
//  Copyright (c) 2013年 makeLaugh. All rights reserved.
//

#import "MapView.h"


@interface MapView () <MKMapViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) CLGeocoder  *geocoder;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIToolbar   *toolBar;

//显示提示
@property (strong, nonatomic) UILabel     *tipsLbl;

//显示将要设定的购物地址
@property (strong, nonatomic) UILabel     *shoppingAddressLbl;

//用户选择的购物地址和经纬度
@property (copy, nonatomic)   NSString    *shoppingAddress;
@property (strong, nonatomic) CLLocation  *shoppingLocation;

//是否自动更新位置标志位。
@property (assign, nonatomic) BOOL        autoUpdate;

//刷新位置按钮
@property (strong, nonatomic) UIButton    *updateLocationBtn;

@end


@implementation MapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addMapView];
        [self addNavigationBar];
        [self addSearchBar];
        [self addTipsLbl];
        [self addShoppingAddressLbl];
        [self addUpdateLocationBtn];
        
        self.geocoder = [[CLGeocoder alloc] init];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

- (void)addMapView
{
    //夫子庙纬度，若未定位到南京，则定位到夫子庙
//    CLLocationCoordinate2D coordinate ;
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 800, 800);
//    [self addAnnotationWithTitle:@"南京" subtitle:@"夫子庙" coordinate:coordinate];
//    
    self.mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    [self.mapView.userLocation setTitle:@"我的位置"];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:NO];
//    [self.mapView setRegion:region animated:YES];
//    [self.mapView setCenterCoordinate:coordinate animated:YES];
    [self addSubview:self.mapView];
    
    
    
    
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager.delegate=self;//设置代理
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    locationManager.distanceFilter=1000.0f;//设置距离筛选器
    [locationManager startUpdatingLocation];//启动位置管理器
    
    MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
    theRegion.center=[[locationManager location] coordinate];
      [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    theRegion.span.longitudeDelta = 0.01f;
    theRegion.span.latitudeDelta = 0.01f;
    [self.mapView setRegion:theRegion animated:YES];
}

- (void)addNavigationBar
{
//    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
//    [self addSubview:self.toolBar];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
//    UIBarButtonItem *spaceItem0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"位置管理" style:UIBarButtonItemStylePlain target:nil action:nil];
//    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(saveUserLocation:)];
//    [self.toolBar setItems:@[backItem, spaceItem0, titleItem, spaceItem1, saveItem]];
}

- (void)addSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, 320, 44)];
    [self.searchBar setBackgroundColor:[UIColor whiteColor]];
    [self.searchBar setTintColor:[UIColor whiteColor]];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"请输入定位点,如夫子庙"];
    [self addSubview:self.searchBar];
}

- (void)addTipsLbl
{
    self.tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 20)];
    [self.tipsLbl setFont:[UIFont systemFontOfSize:13]];
    [self.tipsLbl setTextAlignment:UITextAlignmentCenter];
    [self.tipsLbl setBackgroundColor:[[UIColor darkTextColor] colorWithAlphaComponent:0.4]];
    [self.tipsLbl setTextColor:[UIColor redColor]];
    [self.tipsLbl setText:@"长按1秒设定位置,设定新的位置会清空本地购物车！"];
    [self addSubview:self.tipsLbl];
}

- (void)addShoppingAddressLbl
{
    self.shoppingAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,50, 320, 20)];
    [self.shoppingAddressLbl setFont:[UIFont systemFontOfSize:13]];
    [self.shoppingAddressLbl setTextAlignment:UITextAlignmentCenter];
    [self.shoppingAddressLbl setBackgroundColor:[[UIColor darkTextColor] colorWithAlphaComponent:0.5]];
    [self.shoppingAddressLbl setTextColor:[UIColor whiteColor]];
    [self.shoppingAddressLbl setText:@"设定位置:"];
    [self addSubview:self.shoppingAddressLbl];
}

- (void)addUpdateLocationBtn
{
    self.updateLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.updateLocationBtn setFrame:CGRectMake(320 - 44, 200, 44, 44)];
    [self.updateLocationBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.updateLocationBtn addTarget:self action:@selector(updateLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.updateLocationBtn setShowsTouchWhenHighlighted:YES];
    [self.updateLocationBtn setImage:mImageByName(@"updateLocation") forState:UIControlStateNormal];
    [self addSubview:self.updateLocationBtn];
}


#pragma mark - Event

- (void)startUpdateLocation:(BOOL)autoUpdate
{
    self.autoUpdate = autoUpdate;
    [self.mapView setShowsUserLocation:YES];
}

- (void)updateLocation:(UIButton *)sender
{
    [self.mapView setShowsUserLocation:YES];
}

- (void)stopUpdateLocation
{
    [self.mapView setShowsUserLocation:NO];
}

- (void)back:(UIBarButtonItem *)sender
{
    [self setAlpha:1.0];
    [UIView animateWithDuration:1.0
                     animations:^
     {
         [self setAlpha:0.0];
     }
                     completion:^(BOOL finished)
     {
         [self setHidden:YES];
     }];
}

- (void)saveUserLocation:(UIBarButtonItem *)sender
{
//    [mUserDefaults setFloat:self.shoppingLocation.coordinate.latitude forKey:kShoppingLatitude];
//    [mUserDefaults setFloat:self.shoppingLocation.coordinate.longitude forKey:kShoppingLongitude];
//    [mUserDefaults setObject:self.shoppingAddress forKey:kShoppingAddress];
//    
//    [mNotificationCenter postNotificationName:kUpdateLocationFinished object:self.shoppingAddress];
//    [self back:nil];
//    
//    //更新位置后清空购物车
//    ShoppingCartModel *shoppingCartModel = [[ShoppingCartModel alloc] init];
//    [shoppingCartModel deleteAllShop];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchPoint = [gesture locationInView:self];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self];
        
        //判断触摸点的位置是否是在南京地区
                   CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            [self reverseGeocodeLocation:location isUserLocation:YES];
        
    }
}


#pragma mark - SearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *address = [NSString stringWithFormat:@"%@%@", kAddressPrefix, searchBar.text];
    
    [self.geocoder geocodeAddressString:address
                      completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for (CLPlacemark *placemark in placemarks)
         {
             [self addressForPlacemark:placemark];
             self.shoppingLocation = placemark.location;
             [self.shoppingAddressLbl setText:[NSString stringWithFormat:@"设定位置:%@", self.shoppingAddress]];
             
             if (placemark.subLocality && placemark.thoroughfare)
             {
                 CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                 [self addAnnotationWithTitle:@"设定位置" subtitle:self.shoppingAddress coordinate:coordinate];
                 [self.mapView setCenterCoordinate:coordinate];
             }
             else
             {
//                 MessageStatusBar *msgStatusBar = [MessageStatusBar sharedInstance];
//                 [msgStatusBar show];
//                 [msgStatusBar updateStatusMessage:@"没有找到该位置"];
//                 [msgStatusBar performSelector:@selector(hide) withObject:nil afterDelay:3];
             }
         }
     }];
    
    //友盟统计
//    [MobClick event:kSearchAddress];
}

//拼接地址
- (void)addressForPlacemark:(CLPlacemark *)placemark
{
    NSString *city = placemark.locality;
    NSString *subLocality = placemark.subLocality;
    NSString *thoroughfare = placemark.thoroughfare;
    NSString *subThoroughfare = placemark.subThoroughfare;
    if (subThoroughfare && thoroughfare)
    {
        self.shoppingAddress = [NSString stringWithFormat:@"%@%@%@%@", city, subLocality, thoroughfare, subThoroughfare];
    }
    else if (thoroughfare && !subThoroughfare)
    {
        self.shoppingAddress = [NSString stringWithFormat:@"%@%@%@", city, subLocality, thoroughfare];
    }
    else if (!thoroughfare && !subThoroughfare)
    {
        self.shoppingAddress = [NSString stringWithFormat:@"%@%@", city, subLocality];
    }
    else
    {
        self.shoppingAddress = [NSString stringWithFormat:@"%@", city];
    }
}


#pragma mark - Annotation

- (void)addAnnotationWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate
{
    NSArray *annotations = self.mapView.annotations;
    [self.mapView removeAnnotations:annotations];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    annotation.title = title;
    [annotation setSubtitle:subtitle];
    [self.mapView addAnnotation:annotation];
}


#pragma mark - Reverse GeocodeLocation To Address

- (void)reverseGeocodeLocation:(CLLocation *)location isUserLocation:(BOOL)userLocation
{
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for (MKPlacemark *placemark in placemarks)
         {
             [self addressForPlacemark:placemark];
             self.shoppingLocation = placemark.location;
             [self.shoppingAddressLbl setText:[NSString stringWithFormat:@"将要设定的地址为:%@", self.shoppingAddress]];
             
             if (!userLocation)
             {
                 [self addAnnotationWithTitle:@"设定位置" subtitle:self.shoppingAddress coordinate:placemark.location.coordinate];
             }
             else
             {
                 if (self.autoUpdate)
                 {
                     [self saveUserLocation:nil];
                 }
                 [self addAnnotationWithTitle:@"我的位置" subtitle:self.shoppingAddress coordinate:placemark.location.coordinate];
             }
         }
     }];
}


#pragma mark - MapView Delegate Method

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
        [mapView setRegion:region animated:YES];
        [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        [self performSelector:@selector(stopUpdateLocation) withObject:nil afterDelay:1];
        
        [self reverseGeocodeLocation:userLocation.location isUserLocation:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![[annotation title] isEqualToString:@"我的位置"])
    {
        static NSString *annotationId = @"myLocationAnnotationId";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationId];
        if (!annotationView)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationId];
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
            annotationView.pinColor = MKPinAnnotationColorGreen;
        }
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self.searchBar resignFirstResponder];
}


@end
