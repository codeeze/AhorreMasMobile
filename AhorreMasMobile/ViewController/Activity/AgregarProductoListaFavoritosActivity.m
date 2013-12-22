//
//  AgregarProductoListaFavoritosActivity.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/17/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "AgregarProductoListaFavoritosActivity.h"

NSString * const kArregloListaFavoritosLlave = @"listaFavoritos";

@interface AgregarProductoListaFavoritosActivity() {
    NSNumber *productoID;
}

@end

@implementation AgregarProductoListaFavoritosActivity

- (NSString *)activityTitle {
    return @"Agregar a Mi Lista Favoritos";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"ListaFavoritos"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    productoID = [activityItems objectAtIndex:0];
}

- (void)performActivity {
    [self agregarProductoListaFavoritos:productoID];
    [self activityDidFinish:YES];
}

- (void)agregarProductoListaFavoritos:(NSNumber *)producto {
    NSUserDefaults *preferenciasUsuario = [NSUserDefaults standardUserDefaults];
    NSArray *arregloListaFavoritos = [preferenciasUsuario objectForKey:kArregloListaFavoritosLlave];
    NSMutableArray *arregloActualizado = (arregloListaFavoritos) ?
    [arregloListaFavoritos mutableCopy] : [NSMutableArray array];
    [arregloActualizado insertObject:producto atIndex:0];
    [preferenciasUsuario setObject:arregloActualizado
                            forKey:kArregloListaFavoritosLlave];
    [preferenciasUsuario synchronize];
}

@end
