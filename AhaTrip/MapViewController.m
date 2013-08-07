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
#import "PersonalViewController.h"
#import "Constants.h"
#import "LocationManager.h"
#import "SPGooglePlacesAutocompleteViewController.h"
#import "NewPlaceViewController.h"

#import "RequestManager.h"
#import "CLLocation+Sino.h"

#define span_Num 100

@implementation MapSearchDisplayController
- (void)setActive:(BOOL)visible animated:(BOOL)animated;
{
    if(self.active == visible) return;
    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    [super setActive:visible animated:animated];
    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    if (visible) {
        [self.searchBar becomeFirstResponder];
    } else {
        [self.searchBar resignFirstResponder];
    }
}
@end


@interface MapViewController ()
{
    NSMutableArray *_annotationList;
    PinAnnotation *_pinAnnotation;
	DetailsAnnotation *_detailsAnnotation;
    BOOL havePlaced;
}
@property(nonatomic,strong)NSMutableArray * searchArray;
@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize progressHUD;
@synthesize delegate;
@synthesize searchArray = _searchArray;

#pragma mark - AddViews
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initContainer];
    self.bg_errorView.backgroundColor = mRGBColor(235, 235, 235);
    [self.bg_errorView setHidden:YES];
    [self addtabView];
    [self addTabBar];
    [self addNavBar];
    [self.view bringSubviewToFront:self.bg_errorView];
}
- (void)initContainer
{
    titlearr = [NSMutableArray arrayWithCapacity:0];
    _annotationList = [NSMutableArray arrayWithCapacity:0];
    _searchArray = [NSMutableArray arrayWithCapacity:0];
}
- (void)addtabView
{
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 20.f;
    mytable=[[UITableView alloc] initWithFrame:CGRectMake(10 , 44, 300, height - 44 - 55) style:UITableViewStylePlain];
    mytable.delegate=self;
    mytable.dataSource=self;
    mytable.backgroundColor=[UIColor clearColor];
    mytable.separatorColor=[UIColor clearColor];
    [self.view addSubview: mytable];
    [self addSearchView];
}
- (void)addSearchView
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    _searchBar.barStyle = UIBarStyleBlack;
    _searchBar.placeholder = @" ";
    [_searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"search_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)]forState:UIControlStateNormal];
    [_searchBar setImage:[UIImage imageNamed:@"search_Icon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    mytable.tableHeaderView = _searchBar;
    _searchDisPlay = [[MapSearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisPlay.searchResultsDelegate = self;
    _searchDisPlay.searchResultsDataSource = self;
    _searchDisPlay.delegate = self;
}
- (void)setMapViews
{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    MKCoordinateRegion region= MKCoordinateRegionMakeWithDistance(newLocCoordinate,800,800);
    [self.mapView setRegion:region animated:YES];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    self.mapView.scrollEnabled = NO;
    self.mapView.zoomEnabled = NO;
    
    DLog();
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    //开启GPS
    if(CLLocationManager.locationServicesEnabled) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设定为最佳精度
        locationManager.distanceFilter = 5.0f;//响应位置变化的最小距离(m)
        [locationManager startUpdatingLocation];
    }

}
- (void)addTabBar
{
    //加载底部导航
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 20.f;
    backimageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, height-55, self.view.bounds.size.width, 55)];
    backimageView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:backimageView];
    
    //返回国家页的listmenu页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10,height-44, 50, 44)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenuList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];
    
    //跳过此步骤的按钮
    UIButton*tiaoguoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [tiaoguoBtn setFrame:CGRectMake(220,height - 44, 100, 44)];
    tiaoguoBtn.contentMode=UIViewContentModeScaleAspectFit;
    [tiaoguoBtn setTitle:@"跳过此步骤 >" forState:UIControlStateNormal];
    tiaoguoBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [tiaoguoBtn setTitleColor:mRGBColor(50, 200, 160) forState:UIControlStateNormal];
    [tiaoguoBtn addTarget:self action:@selector(tiaoguoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tiaoguoBtn];
}
- (void)addNavBar
{
    //加载topBar
    self.view.backgroundColor=mRGBColor(236, 235, 235);
    UIImageView*topBarImag=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 44)];
    topBarImag.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:topBarImag];
    // 添加位置的label
    UILabel*addPlaceLable=[[UILabel alloc] initWithFrame:CGRectMake(15, 3, 100, 40)];
    addPlaceLable.text=@"添加位置";
    addPlaceLable.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    addPlaceLable.backgroundColor=[UIColor clearColor];
    addPlaceLable.textColor=[UIColor whiteColor];
    [self.view addSubview:addPlaceLable];
    
    //添加搜索的btn
    //    UIButton*serchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [serchBtn setFrame:CGRectMake(250-15, 5, 80, 35)];
    //    serchBtn.backgroundColor=[UIColor redColor];
    //    [serchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    //    [serchBtn setImage:[UIImage imageNamed:@"serch.png"] forState:UIControlStateNormal];
    //    [serchBtn addTarget:self action:@selector(serchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:serchBtn];
}

#pragma mark Button-Action
-(void)serchBtnClick
{
    if ([delegate respondsToSelector:@selector(mapViewControllerDidSearch:)]) {
        [delegate mapViewControllerDidSearch:self];
    }
    //    NewPlaceViewController*newPlace=[[NewPlaceViewController alloc] init];
    //    [self presentViewController:newPlace animated:YES completion:nil];
    
//    SPGooglePlacesAutocompleteViewController *viewController = [[SPGooglePlacesAutocompleteViewController alloc] initWithNibName:@"SPGooglePlacesAutocompleteViewController" bundle:nil];
//    [self presentViewController:viewController animated:YES completion:nil];
}

//回到滤镜选项页
-(void)closeBtnBackMenuList
{
    if ([delegate respondsToSelector:@selector(mapViewControllerDidCancel:)])
        [delegate mapViewControllerDidCancel:self];
}

//跳过此步骤去到个人信息添加页
-(void)tiaoguoBtnClick
{    
    if ([delegate respondsToSelector:@selector(mapViewControllerDidSkip:)])
        [delegate mapViewControllerDidSkip:self];
    
    //    NSLog(@"跳过");
    //    PersonalViewController*personal=[[PersonalViewController alloc] initWithLatitude:@"" longitude:@"" placeName:nil image:mapImage singleCityId:@"" singleCityName:@"" cateryStr:@""];
    //    [self presentViewController:personal animated:YES completion:nil];
}

#pragma mark GetPlaceFromAutoNav
- (void)getPoiByAddressWithAutoNav
{
    if(!maSearch)
        maSearch = [[MASearch alloc] initWithSearchKey:@"b5646e547c5bc722d99bdd34795fcf11" Delegate:self];
    MAReverseGeocodingSearchOption * searchOption=[[MAReverseGeocodingSearchOption alloc] init];
    searchOption.config= @"SPAS";
    searchOption.roadNumber = @"0";
    searchOption.poiNumber = @"30";
    searchOption.range = @"2000";
    CLLocation * location = [[CLLocation alloc] initWithLatitude:newLocCoordinate.latitude longitude:newLocCoordinate.longitude];
    location = [location locationMarsFromEarth];
    searchOption.x = [NSString stringWithFormat:@"%.99g",location.coordinate.longitude];
    searchOption.y = [NSString stringWithFormat:@"%.99g",location.coordinate.latitude];
    [maSearch reverseGeocodingSearchWithOption:searchOption];
}

- (void)reverseGeocodingSearch:(MAReverseGeocodingSearchOption *)geoCodingSearchOption Result:(MAReverseGeocodingSearchResult *)result
{
    if ([geoCodingSearchOption isKindOfClass:[MAReverseGeocodingSearchOption class]]) {
//        DLog(@"LLLLLLLLLLLLL%d",result.resultArray.count);
//        for (int i = 0; i<result.resultArray.count; i++)
//        {
//            MAReverseGeocodingInfo* revResult = [result.resultArray objectAtIndex:i];
//            MAProvince* revProvince = revResult.province;
//            NSLog(@"province name : %@",revProvince.name);
//            MACity* revCity = revResult.city;
//            NSLog(@"city name : %@",revCity.name);
//            MADistrict* revDistrict = revResult.district;
//            NSLog(@"district name : %@",revDistrict.name);
//            for (int k=0; k< revResult.pois.count; k++) {
//                MAPOI* poi = [revResult.pois objectAtIndex:k];
//                NSLog(@"%dpoi name : %@",k,poi.name);
//                NSLog(@"poi address : %@",poi.address);
//                NSLog(@"poi type : %@",poi.type);
//                NSLog(@"poi distance: %@",poi.distance);
//            }
//        }
        if (result.resultArray.count) {
            MAReverseGeocodingInfo* revResult = [result.resultArray objectAtIndex:0];
            if (revResult && revResult.pois.count)
                [self placeThePinsByPiosArray:revResult.pois];
        }else{
            [self.bg_errorView setHidden:NO];
        }       
    }
}

#pragma mark GetPlaceFromGoogle
-(void)googlePlace
{
    [RequestManager getGooglePlaceWithRadius:2000 latitude:newLocCoordinate.latitude longitude:newLocCoordinate.latitude placeType:@"" placeContainName:@"" success:^(NSData *data) {
        NSMutableArray *placeMuAry = [XMLHelper useNSXMLParserDelegateToGetResult:data];
        if (placeMuAry.count>0)
            [self placeThePinsByAnnotationAry:placeMuAry annoType:@""];
        
    } failure:^(NSString *error) {
        [self.bg_errorView setHidden:NO];
    }];
}

//放置位置指示针【方法2】
-(void)placeThePinsByAnnotationAry:(NSMutableArray *)aPlaceAry  annoType:(NSString *)aType
{
    [titlearr removeAllObjects];
    NSLog(@"Place pins by using  [mMapView addAnnotations:annoAry]");
    
    [self removeAllAnnotations];
    [_annotationList removeAllObjects];
    [_annotationList addObjectsFromArray:aPlaceAry];
    [titlearr addObjectsFromArray:aPlaceAry];
    [mytable reloadData];
    for (int i=0; i<[aPlaceAry count]; i++) {
        PlaceDetailVO *place = [aPlaceAry objectAtIndex:i];
        CLLocationCoordinate2D coor;
        coor.latitude = [place.pLatStr floatValue];
        coor.longitude = [place.pLngStr floatValue];
        PinAnnotation *pinAnno = [[PinAnnotation alloc]initWithLatitude: coor.latitude andLongitude:coor.longitude];
        pinAnno.type = aType;
        pinAnno.tag = i+100;
        [self.mapView addAnnotation:pinAnno];
    }
    [self.mapView setHidden:NO];
}

- (void)placeThePinsByPiosArray:(NSArray *)array
{
    [titlearr removeAllObjects];
    NSLog(@"Place pins by using  [mMapView addAnnotations:annoAry]");
    
    [self removeAllAnnotations];
    [_annotationList removeAllObjects];
    [_annotationList addObjectsFromArray:array];
    [titlearr addObjectsFromArray:array];
    [mytable reloadData];
    for (int i=0; i< [array count]; i++) {
        MAPOI *poi = [array objectAtIndex:i];
        CLLocationCoordinate2D coor;
        coor.longitude = [[poi x] doubleValue];
        coor.latitude = [[poi y] doubleValue];
        PinAnnotation *pinAnno = [[PinAnnotation alloc]initWithLatitude: coor.latitude andLongitude:coor.longitude];
        pinAnno.type = poi.type;
        pinAnno.tag = i+100;
        [self.mapView addAnnotation:pinAnno];
    }
}

#pragma mark - AnnotationsMethod
-(void)removeAllAnnotations
{
    id userAnnotation = self.mapView.userLocation;
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [annotations removeObject:userAnnotation];
    [self.mapView removeAnnotations:annotations];
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
        [_mapView   addAnnotation:annotation];
    }
}

#pragma mark - MapViewDelegate
//选中MKAnnotationView
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
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
        
    }
}

//选中完MKAnnotationView
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (_detailsAnnotation&& ![view isKindOfClass:[DetailsAnnotation class]]) {
        if (_detailsAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _detailsAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_detailsAnnotation];
            _detailsAnnotation = nil;
        }
    }
}

//设置MKAnnotation上的annotationView
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
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

#pragma mark CLLocationManagerDelegate
// 用户位置更新后，会调用此函数
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    DLog();
    newLocCoordinate = [newLocation coordinate];
	CGFloat lat = newLocCoordinate.latitude;
	CGFloat lon	= newLocCoordinate.longitude;
    
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
    if (!havePlaced) {
        havePlaced = YES;
        [self getPoiByAddressWithAutoNav];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	[locationManager stopUpdatingLocation];
	[locationManager stopUpdatingHeading];
	[[self.mapView viewForAnnotation:[self.mapView userLocation]] setTransform:CGAffineTransformIdentity];
    [self.bg_errorView setHidden:NO];
}
#pragma mark SerachDelegate
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    DLog();
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setNeedsLayout];
}
- (void)searchDataWithString:(NSString *)searchString
{
    [_searchArray removeAllObjects];
    for (MAPOI * poi in titlearr) {
        NSString * string = poi.name;
        if ([string rangeOfString:_searchBar.text].length != 0) {
            [_searchArray addObject:poi];
        }
    }
}
- (void)fixTableViewFrame:(UITableView *)tableView
{
    //防止searchDisControler调整tableview 宽度为320
    CGRect rect = tableView.frame;
    rect.origin.x = 10;
    rect.size.width = 300;
    tableView.frame = rect;
}

#pragma mark TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != mytable) {
        return 44;
    }
    return indexPath.row ? 44 : 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != mytable) {
        return _searchArray.count;
    }
    return titlearr.count ? titlearr.count + 1 : 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * topicCell = @"TopicCell";
    static NSString *mapCell = @"MapCell";
    NSInteger index = indexPath.row - 1;
    NSMutableArray * sourceArray = nil;
    if (tableView == mytable) {
        sourceArray = titlearr;
        if (!indexPath.row) {
            UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mapCell];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mapCell];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:self.mapView];
            }
            return cell;
        }
        index --;
    }else{
        sourceArray = _searchArray;
    }
    
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:topicCell];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicCell];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = mRGBColor(50, 200, 160);
        
        UILabel*citylabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 2, 240, 40)];
        citylabel.tag = 1000;
        citylabel.font=[UIFont systemFontOfSize:18.f];
        citylabel.textColor=[UIColor blackColor];
        citylabel.backgroundColor=[UIColor clearColor];
        [cell addSubview:citylabel];
        
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bgView.image = [[UIImage imageNamed:@"rect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 150, 20, 150)];
        cell.backgroundView = bgView;
        UIImageView*img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 300, 1)];
        img.image=[UIImage imageNamed:@"line.png"];
        img.tag = 10000;
        [cell.contentView addSubview:img];
    }
    UIView * view = [cell viewWithTag:10000];
    view.hidden = titlearr.count - 1 != indexPath.row;
    UILabel*cityLabel=(UILabel*)[cell viewWithTag:1000];
    MAPOI * poi = [sourceArray objectAtIndex:index];
    cityLabel.text = poi.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    PlaceDetailVO *place = [titlearr objectAtIndex:indexPath.row];
//    CLLocationCoordinate2D coor;
//    coor.latitude = [place.pLatStr floatValue];
//    coor.longitude = [place.pLngStr floatValue];
    
    //
    ////       PersonalViewController*personCTL=[[PersonalViewController alloc] initWithLatitude:place.pLatStr longitude:place.pLngStr placeName:place.pNameStr image:mapImage];
    //     PersonalViewController*personCTL=[[PersonalViewController alloc] initWithLatitude:place.pLatStr longitude:place.pLngStr placeName:place.pNameStr image:mapImage singleCityId:self.singleCityId singleCityName:self.singleCityName cateryStr:self.cateryStr];
    ////     [personCTL Latitude:place.pLatStr longitude:place.pLngStr placeName:place.pNameStr];
    //    personCTL.longtitude=place.pLatStr;
    //    personCTL.latitude=place.pLngStr;
    //    personCTL.placeName=place.pNameStr;
    //    NSLog(@"%@%@%@",personCTL.latitude,personCTL.longtitude,personCTL.placeName);
    //    [self presentModalViewController:personCTL animated:YES];
}

@end
