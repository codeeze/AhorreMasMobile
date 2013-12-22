//
//  Producto.h
//  Ahorre Mas Admin
//
//  Created by Javier Ramirez on 11/18/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Producto : NSObject

@property NSString *nombre;
@property NSString *marca;
@property NSString *modelo;
@property NSString *codigoBarras;
@property NSString *categoria;
@property NSString *unidadMedida;
@property NSString *urlImagen;
@property NSString *valorMax;
@property NSString *valorMin;
@property UIImage *imagen;
@property NSInteger productoID;
@property float cantidad;

- (id)initConCodigoBarras:(NSString *)codigoBarras;
- (id)initConAtributos:(NSDictionary *)atributos;

@end
