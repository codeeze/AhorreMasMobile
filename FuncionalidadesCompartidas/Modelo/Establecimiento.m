//
//  Establecimiento.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/10/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "Establecimiento.h"
#import "EstablecimientoFoursquare.h"

@implementation Establecimiento

@synthesize nombre = _nombre;
@synthesize direccion = _direccion;
@synthesize latitud = _latitud;
@synthesize longitud = _longitud;
@synthesize ultimoPrecio = _ultimoPrecio;
@synthesize establecimientoID = _establecimientoID;
@synthesize foursquareID = _foursquareID;

- (id)initConAtributos:(NSDictionary *)atributos {
    if (self = [super init]) {
        _establecimientoID = [[atributos valueForKeyPath:@"establecimientoID"] intValue];
        _nombre = [atributos valueForKeyPath:@"nombre"];
        _direccion = [atributos valueForKeyPath:@"direccion"];
        _latitud = [atributos valueForKeyPath:@"latitud"];
        _longitud = [atributos valueForKeyPath:@"longitud"];
        _ultimoPrecio = [atributos valueForKeyPath:@"ultimoPrecio"];
    }
    
    return self;
}


- (id)initConEstablecimientoFoursquare:(EstablecimientoFoursquare *)estabFoursquare
{
    if (self = [super init]) {
        _foursquareID = estabFoursquare.fourSquareId;
        _nombre = estabFoursquare.nombre;
        _direccion = estabFoursquare.direccion;
        _latitud = [NSString stringWithFormat:@"%@", estabFoursquare.latitud];
        _longitud = [NSString stringWithFormat:@"%@", estabFoursquare.longitud];
    }
    return self;
}

@end
