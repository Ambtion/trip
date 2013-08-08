//
//  MapViewController.h
//  XQSearchPlaces
//
//  Created by iObitLXF on 5/17/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MASearchKit.h"

@interface UIProgressIndicator : UIActivityIndicatorView {
}

+ (struct CGSize)size;
- (int)progressIndicatorStyle;
- (void)setProgressIndicatorStyle:(int)fp8;
- (void)setStyle:(int)fp8;
- (void)setAnimating:(BOOL)fp8;
- (void)startAnimation;
- (void)stopAnimation;
@end

@interface UIProgressHUD : UIView {
    UIProgressIndicator *_progressIndicator;
    UILabel *_progressMessage;
    UIImageView *_doneView;
    UIWindow *_parentWindow;
    struct {
        unsigned int isShowing:1;
        unsigned int isShowingText:1;
        unsigned int fixedFrame:1;
        unsigned int reserved:30;
    } _progressHUDFlags;
}

- (id)_progressIndicator;
- (id)initWithFrame:(struct CGRect)fp8;
- (void)setText:(id)fp8;
- (void)setShowsText:(BOOL)fp8;
- (void)setFontSize:(int)fp8;
- (void)drawRect:(struct CGRect)fp8;
- (void)layoutSubviews;
- (void)showInView:(id)fp8;
- (void)hide;
- (void)done;
- (void)dealloc;
@end
@class MapViewController;
@protocol MapViewDelegate <NSObject>
@optional
- (void)mapViewControllerDidCancel:(MapViewController *)picker;
- (void)mapViewControllerDidSkip:(MapViewController *)picker;
- (void)mapViewControllerDidSeletedLocation:(NSString *)locationName;
@end

@interface MapSearchDisplayController : UISearchDisplayController

@end

@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,MASearchDelegate,UISearchDisplayDelegate>
{
    CLLocationManager               *locationManager;
    CLLocationCoordinate2D          newLocCoordinate;
    NSString                        *strType;
    
    UIProgressHUD                   *progressHUD;
    UITableView                     *mytable;
    NSMutableArray                  *_dataSource;
    BOOL select;
    UIImageView                     *backimageView;
    MASearch                        * maSearch;
    
    UILabel * addPlaceLable;
    UISearchBar * _searchBar;
    MapSearchDisplayController * _searchDisPlay;

}
@property (weak, nonatomic) IBOutlet UIImageView *bg_errorView;
@property (weak, nonatomic) IBOutlet  MKMapView *mapView;
@property (strong, nonatomic)  UIProgressHUD *progressHUD;
@property (nonatomic, weak) id <MapViewDelegate> delegate;


@end
