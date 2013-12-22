//
//  Utilities.h
//  Ahorre Mas Admin
//
//  Created by Javier Ramirez on 11/21/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilidades : NSObject

+ (NSDictionary *) diccionarioMedidas;
+ (NSInteger) idParaUnidadDeMedida:(NSString *)unidadDeMedida;
+ (NSString *) diminutivoParaUnidadDeMedida:(NSString *)unidadDeMedida;
+ (NSDictionary *) diccionarioImagenesCategorias;
+ (UIImage *) cortarImagen:(UIImage *)imagen dimensiones:(CGRect)rect;
+ (UIImage *) imagenParaMostrarEnFotoCeldaConTamano:(CGSize)tamanoCelda imagenOriginal:(UIImage *)imagen;
+ (void) guardarImagenDePrueba:(UIImage *)image nombre:(NSString *)nombre;
+ (CGPoint)indiceParaDiminutivoUnidadMedida:(NSString *)diminutivo enDiccionario:(NSDictionary *)dict;

@end
