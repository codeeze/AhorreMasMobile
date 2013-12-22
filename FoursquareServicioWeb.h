//
//  FoursquareServicioWeb.h
//  AhorreMasMobile
//
//  Created by Javier Ramirez on 12/11/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoursquareServicioWeb : NSObject

- (NSDictionary *) lugaresConLatitud:(double)latitud
                              Longitud:(double)longitud
                         RetornandoError:(NSError **)error;

- (NSDictionary *) infoDeLugarConId:(NSString *)idLugar
                         RetornandoError:(NSError **)error;

@end
