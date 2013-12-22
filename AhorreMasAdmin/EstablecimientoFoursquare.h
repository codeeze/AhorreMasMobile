//
//  FoursquareEstablishment.h
//  Precio Digital
//
//  Created by Javier Ramirez on 10/12/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstablecimientoFoursquare : NSObject

@property (nonatomic, retain) NSString * fourSquareId;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * direccion;

+(NSArray *) establecimientosFoursquareConDiccionario:(NSDictionary *)diccionario;

@end
