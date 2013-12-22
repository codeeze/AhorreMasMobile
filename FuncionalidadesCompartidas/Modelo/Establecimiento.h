//
//  Establecimiento.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/10/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EstablecimientoFoursquare;

@interface Establecimiento : NSObject

@property (strong, nonatomic) NSString *nombre;
@property (strong, nonatomic) NSString *direccion;
@property (strong, nonatomic) NSString *latitud;
@property (strong, nonatomic) NSString *longitud;
@property (strong, nonatomic) NSString *ultimoPrecio;
@property (assign, nonatomic) NSInteger establecimientoID;
@property (strong, nonatomic) NSString *foursquareID;

- (id)initConAtributos:(NSDictionary *)atributos;
- (id)initConEstablecimientoFoursquare:(EstablecimientoFoursquare *)estabFoursquare;

@end
