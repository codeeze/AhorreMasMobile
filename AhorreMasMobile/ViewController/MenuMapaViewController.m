//
//  MenuMapaViewController.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/10/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "MenuMapaViewController.h"

CGFloat const kMetrosPorMilla = 1609.344f;
CGFloat const kZoomRegion = 0.5f;

@interface MenuMapaViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapa;
@property (weak, nonatomic) IBOutlet UIButton *botonWaze;

@end

@implementation MenuMapaViewController

@synthesize establecimiento = _establecimiento;
@synthesize mapa = _mapa;
@synthesize botonWaze = _botonWaze;
@synthesize coordinate = _coordinate;
@synthesize title;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mostrarEstablecimiento];
    [_botonWaze addTarget:self
                   action:@selector(goToWaze)
         forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)mostrarEstablecimiento {
    _coordinate.latitude = ([_establecimiento.latitud isKindOfClass:[NSString class]]) ?
    [_establecimiento.latitud doubleValue] : 10.3238f;
    _coordinate.longitude= ([_establecimiento.longitud isKindOfClass:[NSString class]]) ?
    [_establecimiento.longitud doubleValue] : -84.4271f;
    title = _establecimiento.nombre;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_coordinate,
                                                                   (kZoomRegion * kMetrosPorMilla),
                                                                   (kZoomRegion * kMetrosPorMilla));
    [_mapa setRegion:region animated:YES];
    [_mapa addAnnotation:self];
    [_mapa selectAnnotation:self animated:YES];
}

- (void)goToWaze {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]) {
        NSString *urlWaze = [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",
                             [_establecimiento.latitud doubleValue], [_establecimiento.longitud doubleValue]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlWaze]];
    } else {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
    }
}

@end
