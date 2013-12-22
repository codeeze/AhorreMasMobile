//
//  Producto.m
//  Ahorre Mas Admin
//
//  Created by Javier Ramirez on 11/18/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import "Producto.h"

@implementation Producto

@synthesize unidadMedida = _unidadMedida;
@synthesize cantidad = _cantidad;
@synthesize categoria = _categoria;
@synthesize codigoBarras = _codigoBarras;
@synthesize imagen = _imagen;
@synthesize marca = _marca;
@synthesize modelo = _modelo;
@synthesize nombre = _nombre;
@synthesize productoID = _productoID;
@synthesize urlImagen = _urlImagen;
@synthesize valorMax = _valorMax;
@synthesize valorMin = _valorMin;

- (id)initConCodigoBarras:(NSString *)codigoBarras
{
    self = [super init];
    if (self) {
        _codigoBarras = codigoBarras;
    }
    return self;
}

- (id)initConAtributos:(NSDictionary *)atributos {
    if (self = [super init]) {
        _productoID = [[atributos valueForKeyPath:@"productoID"] intValue];
        _nombre = [atributos valueForKeyPath:@"nombre"];
        _categoria = [atributos valueForKeyPath:@"categoria"];
        _codigoBarras = [atributos valueForKeyPath:@"codigoBarras"];
        _marca = [atributos valueForKeyPath:@"marca"];
        _modelo = [atributos valueForKeyPath:@"modelo"];
        _cantidad = [[atributos valueForKeyPath:@"cantidad"] floatValue];
        _unidadMedida = [atributos valueForKeyPath:@"unidadMedida"];
        _urlImagen = [atributos valueForKeyPath:@"foto"];
        _valorMin = [atributos valueForKeyPath:@"minimo"];
        _valorMax = [atributos valueForKeyPath:@"maximo"];
    }
    
    return self;
}

@end
