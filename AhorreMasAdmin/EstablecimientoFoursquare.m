//
//  FoursquareEstablishment.m
//  Precio Digital
//
//  Created by Javier Ramirez on 10/12/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import "EstablecimientoFoursquare.h"

@implementation EstablecimientoFoursquare

@synthesize direccion;
@synthesize longitud;
@synthesize latitud;
@synthesize nombre;
@synthesize fourSquareId;

+(NSArray *) establecimientosFoursquareConDiccionario:(NSDictionary *)diccionario
{
    NSMutableArray *establecimientosFoursquare = [NSMutableArray array];
    if (diccionario) {
        NSArray *establecimientos = [[diccionario objectForKey:@"response"] objectForKey:@"venues"];
        for (NSDictionary *establecimiento in establecimientos) {
            EstablecimientoFoursquare *establecimientoFoursquare = [[EstablecimientoFoursquare alloc] init];
            establecimientoFoursquare.fourSquareId = [establecimiento objectForKey:@"id"];
            establecimientoFoursquare.nombre = [establecimiento objectForKey:@"name"];
            NSDictionary *ubicacion = [establecimiento objectForKey:@"location"];
            if (ubicacion) {
                establecimientoFoursquare.latitud = [NSNumber numberWithDouble:[[ubicacion objectForKey:@"lat"] doubleValue]];
                establecimientoFoursquare.longitud = [NSNumber numberWithDouble:[[ubicacion objectForKey:@"lng"] doubleValue]];
                
                NSString *direccionCompleta = @"";
                NSString *direccion = [ubicacion objectForKey:@"address"];
                NSString *calle = [ubicacion objectForKey:@"crossStreet"];
                NSString *ciudad = [ubicacion objectForKey:@"city"];
                NSString *estado = [ubicacion objectForKey:@"state"];
                if (direccion) {
                    direccion = [direccion stringByAppendingString:@", "];
                    direccionCompleta = [direccionCompleta stringByAppendingString:direccion];
                }
                if (calle) {
                    calle = [calle stringByAppendingString:@", "];
                    direccionCompleta = [direccionCompleta stringByAppendingString:calle];
                }
                if (ciudad) {
                    ciudad = [ciudad stringByAppendingString:@", "];
                    direccionCompleta = [direccionCompleta stringByAppendingString:ciudad];
                }
                if (estado) {
                    estado = [estado stringByAppendingString:@", "];
                    direccionCompleta = [direccionCompleta stringByAppendingString:estado];
                }
                if (![direccionCompleta isEqualToString:@""]) {
                    direccionCompleta = [direccionCompleta substringToIndex:direccionCompleta.length-2];
                }
                establecimientoFoursquare.direccion = direccionCompleta;
            }
            [establecimientosFoursquare addObject:establecimientoFoursquare];
        }
    }
    return establecimientosFoursquare;
}

@end
