//
//  NewPlaceViewController.m
//  AhaTrip
//
//  Created by xuwenjuan on 13-8-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "NewPlaceViewController.h"
#import "Constants.h"
@interface NewPlaceViewController ()

@end

@implementation NewPlaceAnnotation
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize title = _title;
@synthesize address = _address;

- (id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude {
	
    if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	
    CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	
    self.latitude = newCoordinate.latitude;
	self.longitude = newCoordinate.longitude;
}
- (NSString *)title
{
    return self.name;
}
- (NSString *)subtitle
{
    return self.address;
}
@end

@implementation NewPlaceViewController
@synthesize mapView;
@synthesize  delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavBar];
    [self addTabBar];
    [self setTextFiled];
}
- (void)addNavBar
{
    //加载topBar
    self.view.backgroundColor=mRGBColor(236, 235, 235);
    UIImageView* topBarImag =[[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 44)];
    topBarImag.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:topBarImag];
    [topBarImag setUserInteractionEnabled:YES];
    // 添加位置的label
    UILabel * addPlaceLable=[[UILabel alloc] initWithFrame:CGRectMake(15, 3, 100, 40)];
    addPlaceLable.text= @"添加新位置";
    addPlaceLable.font= [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    addPlaceLable.backgroundColor=[UIColor clearColor];
    addPlaceLable.textColor=[UIColor whiteColor];
    [self.view addSubview:addPlaceLable];
}
- (void)addTabBar
{
    //加载底部导航
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 20.f;
    UIImageView * backimageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, height-55, self.view.bounds.size.width, 55)];
    backimageView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:backimageView];
    
    //返回国家页的listmenu页的按钮
    UIButton * closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10,height - 44, 50, 44)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];
    
    //  返回主页的按钮
//    UIButton*closeAll=[UIButton buttonWithType:UIButtonTypeCustom];
//    [closeAll setFrame:CGRectMake(280 - 8, height - 40, 40, 40)];
//    closeAll.contentMode = UIViewContentModeScaleAspectFit;
//    [closeAll setImage:[UIImage imageNamed:@"bottom_back.png"] forState:UIControlStateNormal];
//    [closeAll addTarget:self action:@selector(closeBtnBackMenu:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:closeAll];
    
    UIButton* addButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setFrame:CGRectMake(280 - 8 - 20, height - 40, 60, 30)];
    addButton.contentMode = UIViewContentModeScaleAspectFit;
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.backgroundColor=mRGBColor(50, 200, 160);
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
}
- (void)addButtonClick:(UIButton *)button
{
    if([delegate respondsToSelector:@selector(newPlaceViewControllerButtonClick:address:Location:)])
        [delegate newPlaceViewControllerButtonClick:self.LocationNameFiled.text address:self.LocationAddressFiled.text Location:touchCoordinate];
}
- (void)closeBtnBackMenu:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)backButton:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ViewLife
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setMapViewsPerpoty];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setMapViewsPerpoty];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
}

- (void)setMapViewsPerpoty
{
    self.mapView.showsUserLocation = YES;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    UITapGestureRecognizer * longPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longGesTure:)];
    [self.mapView addGestureRecognizer:longPress];
    //开启GPS
    if(CLLocationManager.locationServicesEnabled) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设定为最佳精度
        locationManager.distanceFilter = 5.0f;//响应位置变化的最小距离(m)
        [locationManager startUpdatingLocation];
    }
}

- (void)longGesTure:(UIGestureRecognizer *)ges
{
    if (ges.state != UIGestureRecognizerStateBegan) {
        CGPoint point = [ges locationInView:self.mapView];
        touchCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        [self addAninotionWith:touchCoordinate];
    }
}
- (void)addAninotionWith:(CLLocationCoordinate2D )coordinate
{
    [self removeAllAnnotations];
    NewPlaceAnnotation *  annotation=[[NewPlaceAnnotation alloc] initWithLatitude:coordinate.latitude andLongitude:coordinate.longitude];
    annotation.name = [self.LocationNameFiled text];
    annotation.address = [self.LocationAddressFiled text];
    [self.mapView addAnnotation:annotation];
}
-(void)removeAllAnnotations
{
    id userAnnotation = self.mapView.userLocation;
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [annotations removeObject:userAnnotation];
    [self.mapView removeAnnotations:annotations];
}
#pragma mark LocationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    DLog();
	CGFloat lat = [newLocation coordinate].latitude;
	CGFloat lon	= [newLocation coordinate].longitude;
    
	CLLocationCoordinate2D theCenter;
	theCenter.latitude =lat;
	theCenter.longitude = lon;
    
	MKCoordinateRegion theRegin = self.mapView.region;
	theRegin.center = theCenter;
    
	MKCoordinateSpan theSpan;
	theSpan.latitudeDelta = 0.005;
	theSpan.longitudeDelta = 0.005;
	theRegin.span = theSpan;
    [self.mapView setRegion:theRegin];
    [self.mapView regionThatFits:theRegin];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	[locationManager stopUpdatingLocation];
	[locationManager stopUpdatingHeading];
	[[self.mapView viewForAnnotation:[self.mapView userLocation]] setTransform:CGAffineTransformIdentity];
}

#pragma mark SetTextFiled
- (void)setTextFiled
{
    [self.LocationNameFiled addTarget:self action:@selector(nameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.LocationAddressFiled addTarget:self action:@selector(addressdidEdit) forControlEvents:UIControlEventEditingDidEndOnExit];
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    ges.delegate = self;
    [self.view addGestureRecognizer:ges];
}
- (void)nameDidEndOnExit
{
    [self.LocationNameFiled resignFirstResponder];
    [self.LocationAddressFiled becomeFirstResponder];
}
- (void)addressdidEdit
{
    [self.LocationNameFiled resignFirstResponder];
    [self.LocationAddressFiled resignFirstResponder];
}
- (void)tapGesture:(UIGestureRecognizer *)ges
{
    [self addressdidEdit];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    CGRect rect = self.view.bounds;
    rect.origin.y = rect.size.height - 55.f;
    rect.size.height = 55.f;
    return ![[gestureRecognizer view] isKindOfClass:[UITextField class]] && ![[gestureRecognizer view] isKindOfClass:[MKMapView class]] && ![[gestureRecognizer view] isKindOfClass:[UIButton class]] && !CGRectContainsPoint(rect, point);
}
@end
