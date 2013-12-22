//
//  FoursquareServicioWeb.m
//  AhorreMasMobile
//
//  Created by Javier Ramirez on 12/11/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "FoursquareServicioWeb.h"

NSString *const kFoursquareIdCliente = @"JARU1155IIMDMRXKBIVA4115SXIJMXIL1RYULSYHJQ42KPZ4";
NSString *const kFoursquareContrasenaCliente = @"OH4F5OASWTAVPNO2M3STDBWTQSHWFTU1QIUTLKWBMI3G1RU4";

@implementation FoursquareServicioWeb

- (NSDictionary *) lugaresConLatitud:(double)latitud
                            Longitud:(double)longitud
                     RetornandoError:(NSError **)error
{
    NSString *latLong = [NSString stringWithFormat:@"%f,%f", latitud, longitud];
    NSString *parametros = [NSString stringWithFormat:@"venues/search?ll=%@&client_id=%@&client_secret=%@", latLong, kFoursquareIdCliente, kFoursquareContrasenaCliente];
    return [self solicitudFoursquareConParametros:parametros RetornandoError:error];
}

- (NSDictionary *) infoDeLugarConId:(NSString *)idLugar
                    RetornandoError:(NSError **)error
{
    NSString *parametros = [NSString stringWithFormat:@"venues/%@?client_id=%@&client_secret=%@", idLugar, kFoursquareIdCliente, kFoursquareContrasenaCliente];
    return [self solicitudFoursquareConParametros:parametros RetornandoError:error];
}


- (NSDictionary *)solicitudFoursquareConParametros:(NSString *)parametros RetornandoError:(NSError **)error
{
    NSDateFormatter *formato = [[NSDateFormatter alloc] init];
    [formato setDateFormat:@"yyyyMMdd"];
    NSString *version = [formato stringFromDate:[NSDate date]];
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/%@&v=%@", parametros, version];
    NSData *data = [self getRequestWithURL:url ReturningError:error];
    NSDictionary *foursquareDict = nil;
    if (data) {
        foursquareDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
    }
    return foursquareDict;
}

- (NSData *) getRequestWithURL:(NSString *)url ReturningError:(NSError **)error
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSURLResponse *urlResponse = nil; // Metadatos del request se almacenan acá
    return [NSURLConnection sendSynchronousRequest:request
                                 returningResponse:&urlResponse
                                             error:error];
}

@end
