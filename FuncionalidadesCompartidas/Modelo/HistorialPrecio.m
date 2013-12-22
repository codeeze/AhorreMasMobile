//
//  HistorialPrecio.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/12/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "HistorialPrecio.h"

@implementation HistorialPrecio

@synthesize precio = _precio;
@synthesize fecha = _fecha;
@synthesize fechaCorta = _fechaCorta;

- (id)initConAtributos:(NSDictionary *)atributos {
    if (self = [super init]) {
        _precio = [atributos valueForKeyPath:@"precio"];
        _fecha = [atributos valueForKeyPath:@"fechaHora"];
        
        NSLocale *localidad = [[NSLocale alloc] initWithLocaleIdentifier:@"es_CR"];
        NSDateFormatter *formatoFecha = [[NSDateFormatter alloc] init];
        [formatoFecha setLocale:localidad];
        [formatoFecha setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *fechaTemp = [formatoFecha dateFromString:_fecha];
        [formatoFecha setDateFormat:@"dd MMM yyyy"];
        _fechaCorta = [formatoFecha stringFromDate:fechaTemp];
    }
    
    return self;
}

@end
