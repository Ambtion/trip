//
//  MapViewController.m
//  XQSearchPlaces
//
//  Created by iObitLXF on 5/17/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//


//Google Places Api Type:https://developers.google.com/places/documentation/supported_types

#import "MapViewController.h"
#import "MapCell.h"
#import "PinAnnotation.h"
#import "DetailsAnnotation.h"
#import "DetailsAnnotationView.h"
#import "XMLHelper.h"
#import "PlaceDetailVO.h"
#import "DetailsViewController.h"
#import "JSONKit.h"
#import "PersonalViewController.h"
#import "NetworkState.h"
#import "Constants.h"
#import "PersonalViewController.h"
#import "LocationManager.h"
#import "SPGooglePlacesAutocompleteViewController.h"
#define span_Num 100
//#define PlaceURLString @"https://maps.googleapis.com/maps/api/place/search/xml?location=%f,%f&radius=%f&types=%@&name=%@&sensor=true&key=AIzaSyBHvxjcnxJNzgukGhgtO65qyxV5aX7DXvg"   //key 需自己在google api申请替换
//NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/xml?location=%f,%f&radius=500&types=%@&sensor=true&key=％@",location.latitude,location.longitude,type,key];
#define PlaceURLString @"https://maps.googleapis.com/maps/api/place/search/xml?location=%f,%f&radius=%f&types=%@&name=%@&sensor=true&key=AIzaSyBHvxjcnxJNzgukGhgtO65qyxV5aX7DXvg"   //key 需自己在google api申请替换


@interface MapViewController ()

{
    NSMutableArray *_annotationList;
    
    PinAnnotation *_pinAnnotation;
	DetailsAnnotation *_detailsAnnotation;
    
    BOOL havePlaced;
}

@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize progressHUD;
@synthesize mapImage;
@synthesize strType;
@synthesize delegate;
@synthesize singleCityName,singleCityId,cateryStr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
      titlearr=[NSMutableArray array];
    
    
     _annotationList = [[NSMutableArray alloc] init];

    self.mapView.showsUserLocation = YES;
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(newLocCoordinate,800,800);
    [self.mapView setRegion:region animated:YES];
    [self.mapView setCenterCoordinate:newLocCoordinate animated:YES];
    
    

    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    //开启GPS
    if(CLLocationManager.locationServicesEnabled) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设定为最佳精度
        locationManager.distanceFilter = 5.0f;//响应位置变化的最小距离(m)
        [locationManager startUpdatingLocation];
    }

   
    
    
    
    
    mytable=[[UITableView alloc] initWithFrame:CGRectMake(10, 210+44, self.view.frame.size.width-20, self.view.bounds.size.height-210-44) style:UITableViewStylePlain];
    mytable.delegate=self;
    mytable.dataSource=self;
    
    //    [mytable reloadData];
    [self.view addSubview: mytable];
    //    加载底部导航
    backimageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, self.view.bounds.size.height)];
    backimageView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:backimageView];
    //    返回国家页的listmenu页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10, self.view.frame.size.height-44, 50, 44)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenuList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];

    //跳过此步骤的按钮
    UIButton*tiaoguoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [tiaoguoBtn setFrame:CGRectMake(220, self.view.frame.size.height-44, 100, 44)];
    tiaoguoBtn.contentMode=UIViewContentModeScaleAspectFit;
//    [tiaoguoBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [tiaoguoBtn setTitle:@"跳过此步骤" forState:UIControlStateNormal];
    [tiaoguoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [tiaoguoBtn addTarget:self action:@selector(tiaoguoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tiaoguoBtn];

    
    //   加载topBar
    
   self.view.backgroundColor=mRGBColor(236, 235, 235);
   UIImageView*topBarImag=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 44)];
    topBarImag.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:topBarImag];

//添加位置的label
    UILabel*addPlaceLable=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 40)];
    addPlaceLable.text=@"添加位置";
    addPlaceLable.backgroundColor=[UIColor clearColor];
    addPlaceLable.textColor=[UIColor whiteColor];
    [self.view addSubview:addPlaceLable];
    
//添加搜索的btn
    UIButton*serchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [serchBtn setFrame:CGRectMake(250-20, 2, 80, 35)];
//    [serchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [serchBtn setImage:[UIImage imageNamed:@"serch.png"] forState:UIControlStateNormal];
    [serchBtn addTarget:self action:@selector(serchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serchBtn];
    
}
//跳到搜索页的click
-(void)serchBtnClick{
  
    SPGooglePlacesAutocompleteViewController *viewController = [[SPGooglePlacesAutocompleteViewController alloc] initWithNibName:@"SPGooglePlacesAutocompleteViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];





}
//回到滤镜选项页
-(void)closeBtnBackMenuList{

//    [self dismissModalViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
[self.delegate mapViewControllerDidCancel:self];

}
//跳过此步骤去到个人信息添加页
-(void)tiaoguoBtnClick{


    NSLog(@"跳过");
    PersonalViewController*personal=[[PersonalViewController alloc] initWithLatitude:@"" longitude:@"" placeName:nil image:mapImage singleCityId:@"" singleCityName:@"" cateryStr:@""];
    [self presentViewController:personal animated:YES completion:nil];


}

-(void)tap{
   
        if (select) {
            mytable.hidden=YES;
                       select=NO;
        }else{
            mytable.hidden=NO;
        
            select=YES;
        }
        
  
    
    
    
    
    
}




-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - action

//-(void)clickMapCellButton:(ButtonType)aType placeDetails:(PlaceDetailVO *)aVO
//{
//
//    if (aType == ButtonType_More) {
//        DetailsViewController *vc = [[DetailsViewController alloc]init];
//        vc.placeDetailVO = aVO;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if(aType == ButtonType_Distance)
//    {
//    
//    }
//    else if(aType == ButtonType_More)
//    {
//        
//    }
//    
//
//}



#pragma mark - PlaceSearch
-(void)googlePlace
{
   
        strType=@"";
   
        [self accessGooglePlaceAPI:2000 latitude:newLocCoordinate.latitude longitude:newLocCoordinate.longitude placeType:strType placeContainName:@""];
        NSLog(@"%@",strType);


    
    

    
}

-(void)accessGooglePlaceAPI:(CGFloat)radius latitude:(CGFloat)lat longitude:(CGFloat)lon placeType:(NSString *)type placeContainName:(NSString *)name
{
   
    NSString *urlString = [NSString stringWithFormat:PlaceURLString,lat,lon,radius,type,name];    
    NSURL *googlePlacesURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *xmlData = [NSData dataWithContentsOfURL:googlePlacesURL];
    
//    
//    //【 使用use NSXMLParserDelegate】
     NSMutableArray *placeMuAry = [XMLHelper useNSXMLParserDelegateToGetResult:xmlData];
    NSLog(@"%@",placeMuAry);
    if (placeMuAry.count>0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self placeThePinsByAnnotationAry:placeMuAry annoType:type];
            
        });
        

    }

    
}

#pragma mark - methods

-(void)removeAllAnnotations
{
    id userAnnotation = self.mapView.userLocation;
    
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [annotations removeObject:userAnnotation];
    
    [self.mapView removeAnnotations:annotations];
}

//放置位置指示针【方法2】
-(void)placeThePinsByAnnotationAry:(NSMutableArray *)aPlaceAry  annoType:(NSString *)aType
{
     [titlearr removeAllObjects];
    NSLog(@"Place pins by using  [mMapView addAnnotations:annoAry]");
    
    [self hideProgressIndicator];
    
    [self removeAllAnnotations];
    [_annotationList removeAllObjects];
       [_annotationList addObjectsFromArray:aPlaceAry];
    NSLog(@"%d",_annotationList.count);
    [titlearr addObjectsFromArray:aPlaceAry];
    NSLog(@"%@%d",titlearr,titlearr.count);
    [mytable reloadData];
    for (int i=0; i<[aPlaceAry count]; i++) {
        PlaceDetailVO *place = [aPlaceAry objectAtIndex:i];
        CLLocationCoordinate2D coor;
        NSLog(@"%@",place.pNameStr);
        coor.latitude = [place.pLatStr floatValue];
        coor.longitude = [place.pLngStr floatValue];
         PinAnnotation *pinAnno = [[PinAnnotation alloc]initWithLatitude: coor.latitude andLongitude:coor.longitude];
        pinAnno.type = aType;
       
        pinAnno.tag = i+100;
         [self.mapView addAnnotation:pinAnno];
        
       
      
    }
}

-(void)setAnnotionsWithList:(NSArray *)list
{
  
    for (NSDictionary *dic in list) {
        
        CLLocationDegrees latitude=[[dic objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude=[[dic objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,span_Num ,span_Num );
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        [_mapView setRegion:adjustedRegion animated:YES];
        
        PinAnnotation *  annotation=[[PinAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
//        annotation.coordinate=location;
        [_mapView   addAnnotation:annotation];
    }
}

- (void)showProgressIndicator:(NSString *)text {
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	self.view.userInteractionEnabled = FALSE;
	if(!progressHUD) {
		CGFloat w = 160.0f, h = 120.0f;
		progressHUD = [[UIProgressHUD alloc] initWithFrame:CGRectMake((self.view.frame.size.width-w)/2, (self.view.frame.size.height-h)/2, w, h)];
		[progressHUD setText:text];
		[progressHUD showInView:self.view];
	}
}

- (void)hideProgressIndicator {
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	self.view.userInteractionEnabled = TRUE;
	if(progressHUD) {
		[progressHUD hide];
		self.progressHUD = nil;
        
	}
}

#pragma mark - 

//选中MKAnnotationView
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
        if (_detailsAnnotation) {
            [mapView removeAnnotation:_detailsAnnotation];
            _detailsAnnotation = nil;
        }
        _detailsAnnotation = [[DetailsAnnotation alloc]
                               initWithLatitude:view.annotation.coordinate.latitude
                               andLongitude:view.annotation.coordinate.longitude];
        PinAnnotation *anno = (PinAnnotation *)view.annotation;
        _detailsAnnotation.tag = anno.tag;
        
        [mapView addAnnotation:_detailsAnnotation];
        
       
        
        [mapView setCenterCoordinate:_detailsAnnotation.coordinate animated:YES];
	}
    else{
//        if([delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)]){
//            [delegate customMKMapViewDidSelectedWithInfo:@"点击至之后你要在这干点啥"];
//        }
    }
}

//选中完MKAnnotationView
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (_detailsAnnotation&& ![view isKindOfClass:[DetailsAnnotation class]]) {
        if (_detailsAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _detailsAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_detailsAnnotation];
            _detailsAnnotation = nil;
        }
    }
}

//设置MKAnnotation上的annotationView
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[DetailsAnnotation class]]) {
        
        DetailsAnnotationView *annotationView = [[DetailsAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"DetailsAnnotationView"];
        DetailsAnnotation *anno = annotation;
        PlaceDetailVO *place = [_annotationList objectAtIndex:anno.tag-100];
        
        MapCell  *cell = [MapCell getInstanceWithNibWithBlock:^(ButtonType aType) {
//            [self clickMapCellButton:aType placeDetails:place];
        }];
      
        cell.placeDetailVO = place;
        [cell toAppearItemsView];
        
        [annotationView.contentView addSubview:cell];
        
        return annotationView;
	} else if ([annotation isKindOfClass:[PinAnnotation class]]) {
        
        MKAnnotationView *annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"PinAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"PinAnnotation"];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"dot.png"];
        }
		
		return annotationView;
    }
	return nil;
}
- (void)resetAnnitations:(NSArray *)data
{
    [_annotationList removeAllObjects];
    [_annotationList addObjectsFromArray:data];
    [self setAnnotionsWithList:_annotationList];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

// 用户位置更新后，会调用此函数
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   
    newLocCoordinate = [newLocation coordinate];
	CGFloat lat = newLocCoordinate.latitude;
	CGFloat lon	= newLocCoordinate.longitude;
    
	CLLocationCoordinate2D theCenter;
	theCenter.latitude =lat;
	theCenter.longitude = lon;
    
//    MKCoordinateRegion theRegin = self.mapView.region;
//	theRegin.center=theCenter;
	MKCoordinateRegion theRegin = self.mapView.region;
	theRegin.center=theCenter;

	MKCoordinateSpan theSpan;
	theSpan.latitudeDelta = 0.1;
	theSpan.longitudeDelta = 0.1;
	theRegin.span = theSpan;
    [self.mapView setRegion:theRegin animated:YES];
    [self.mapView regionThatFits:theRegin];
    
    CGPoint userPoint = [self.mapView convertCoordinate:newLocCoordinate toPointToView:self.mapView];
    CGPoint convertPoint = CGPointMake(userPoint.x, userPoint.y);
    CLLocationCoordinate2D coordinate2D = [self.mapView convertPoint:convertPoint toCoordinateFromView:self.mapView];
    [self.mapView setCenterCoordinate:coordinate2D animated:YES];
    
    if (!havePlaced) {
        havePlaced = !havePlaced;
        [self googlePlace];
    }
//    [self googlePlace];
//    [mytable reloadData];
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	[locationManager stopUpdatingLocation];
	[locationManager stopUpdatingHeading];
	
	[[self.mapView viewForAnnotation:[self.mapView userLocation]] setTransform:CGAffineTransformIdentity];
	
}

#pragma table delegate/datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
     NSLog(@"%d",titlearr.count);
    return titlearr.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *topicCell = @"TopicCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:topicCell];
    if(!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicCell];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel*citylabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        citylabel.tag=1000;
//        citylabel.text=@"women";
        [cell addSubview:citylabel];
        
        
        
    }
    UILabel*cityLabel=(UILabel*)[cell viewWithTag:1000];
    
    PlaceDetailVO *place = [titlearr objectAtIndex:indexPath.row];
    CLLocationCoordinate2D coor;
    coor.latitude = [place.pLatStr floatValue];
    coor.longitude = [place.pLngStr floatValue];
    cityLabel.text=place.pNameStr;
    NSLog(@"%@",place.pNameStr);
    
    
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlaceDetailVO *place = [titlearr objectAtIndex:indexPath.row];
    CLLocationCoordinate2D coor;
    coor.latitude = [place.pLatStr floatValue];
    coor.longitude = [place.pLngStr floatValue];
   
//       PersonalViewController*personCTL=[[PersonalViewController alloc] initWithLatitude:place.pLatStr longitude:place.pLngStr placeName:place.pNameStr image:mapImage];
     PersonalViewController*personCTL=[[PersonalViewController alloc] initWithLatitude:place.pLatStr longitude:place.pLngStr placeName:place.pNameStr image:mapImage singleCityId:self.singleCityId singleCityName:self.singleCityName cateryStr:self.cateryStr];
//     [personCTL Latitude:place.pLatStr longitude:place.pLngStr placeName:place.pNameStr];
    personCTL.longtitude=place.pLatStr;
    personCTL.latitude=place.pLngStr;
    personCTL.placeName=place.pNameStr;
    NSLog(@"%@%@%@",personCTL.latitude,personCTL.longtitude,personCTL.placeName);
    [self presentModalViewController:personCTL animated:YES];


}

@end
