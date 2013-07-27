//
//  SPGooglePlacesAutocompleteViewController.h
//  SPGooglePlacesAutocomplete
//
//  Created by Stephen Poletto on 7/17/12.
//  Copyright (c) 2012 Stephen Poletto. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "AddMapPinViewController.h"
@class SPGooglePlacesAutocompleteQuery;

@interface SPGooglePlacesAutocompleteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate> {
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    
    BOOL shouldBeginEditing;
    MKCoordinateRegion _region;
    MKCoordinateSpan _span;
    
CLLocationCoordinate2D          newLocCoordinate;
    
    AddMapPinViewController*addPinCTL;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic)IBOutlet UIButton*addPin;
-(IBAction)addpin:(id)sender;
@end
