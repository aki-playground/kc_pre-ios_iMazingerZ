//
//  AOAMazingerViewController.m
//  iMazingerZ
//
//  Created by Akixe on 6/3/16.
//  Copyright © 2016 AOA. All rights reserved.
//

#import "AOAMazingerViewController.h"
@import MessageUI;
@interface AOAMazingerViewController ()<MKMapViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) id<MKAnnotation> model;
@end

@implementation AOAMazingerViewController

-(id) initWithAnnotationObject:(id<MKAnnotation>) model
{
    if(self = [super initWithNibName:nil bundle:nil]){
        _model = model;
    }

    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mapView addAnnotation:self.model];
    
    MKCoordinateRegion regionSpain = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 100000, 100000);
    MKCoordinateRegion regionMazinger = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 200, 200);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mapView setRegion:regionSpain animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mapView setRegion:regionMazinger animated:YES];
        });
    });
    self.mapView.delegate = self;
    
}
- (IBAction)vectorial:(id)sender {
    self.mapView.mapType = MKMapTypeStandard;
}
- (IBAction)satellite:(id)sender {
    self.mapView.mapType = MKMapTypeSatellite;
}
- (IBAction)hybrid:(id)sender {
    self.mapView.mapType = MKMapTypeHybrid;
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *pinReuseId = @"pinId";
    MKPinAnnotationView *pinView =(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReuseId];
    
    if (pinView == nil){
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinReuseId];
        
        //Color
        pinView.pinColor = MKPinAnnotationColorPurple;
        //Mostrar popup
        pinView.canShowCallout = YES;
        
        UIImageView *imgMazingerView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"mazinger.png"]];
        pinView.rightCalloutAccessoryView = imgMazingerView;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [btn    addTarget: nil
                   action: nil
         forControlEvents: UIControlEventTouchUpInside];
        
        pinView.leftCalloutAccessoryView = btn;
    }
    return pinView;
}

-(void)                 mapView:(MKMapView *)mapView
                 annotationView:(MKAnnotationView *)view
  calloutAccessoryControlTapped:(UIControl *)control
{
    MKMapSnapshotOptions *options = [MKMapSnapshotOptions new];
    options.region = self.mapView.region;
    options.mapType = MKMapTypeHybrid;
    
    MKMapSnapshotter *shotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [shotter startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error");
        } else {
            //Enviar por email
            MFMailComposeViewController *mailVC = [MFMailComposeViewController new];

            [mailVC setSubject:self.model.title];
            mailVC.mailComposeDelegate = self;
            
            
            NSData *image = UIImageJPEGRepresentation(snapshot.image, 0.6);
            [mailVC addAttachmentData:image
                             mimeType:@"image/jpeg"
                             fileName:@"sombraMazingerEnDescampao.jpg"];
            
            [self presentViewController:mailVC
                               animated:YES
                             completion:nil];
        }
    }];
}

#pragma mark - MFMailComposeViewControllerDelegate

-(void) mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
