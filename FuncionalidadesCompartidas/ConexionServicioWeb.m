//
//  ConexionServicioWeb.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/5/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "ConexionServicioWeb.h"
#import "Reachability.h"

static NSString * const kURLServicioWeb = @"http://54.205.51.233/dal2013/";

@implementation ConexionServicioWeb

+ (instancetype)clienteCompartido {
    static ConexionServicioWeb *cliente = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        cliente = [[ConexionServicioWeb alloc] initWithBaseURL:[NSURL URLWithString:kURLServicioWeb]];
        [cliente setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
    });
    
    return cliente;
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSString *mensajeError = @"No hay conexion a internet. Intente de nuevo más tarde";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message:mensajeError delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return nil;
    } else {
        return [super POST:URLString parameters:parameters success:success failure:failure];
    }
}


- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSString *mensajeError = @"No hay conexion a internet. Intente de nuevo más tarde";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message:mensajeError delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return nil;
    } else {
        return [super GET:URLString parameters:parameters success:success failure:failure];
    }
}



@end
