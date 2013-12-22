//
//  Utilities.m
//  Ahorre Mas Admin
//
//  Created by Javier Ramirez on 11/21/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import "Utilidades.h"
#import <objc/runtime.h>

@implementation Utilidades

+ (NSString *) diminutivoParaUnidadDeMedida:(NSString *)unidadDeMedida
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DiminutivosUnidades" ofType:@"plist"];
    NSDictionary *diminutivos = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    return [diminutivos objectForKey:unidadDeMedida];
}

+ (NSInteger) idParaUnidadDeMedida:(NSString *)unidadDeMedida
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"IdentificadoresUnidades" ofType:@"plist"];
    NSDictionary *ids = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    return [[ids objectForKey:unidadDeMedida] integerValue];
}


+ (NSDictionary *) diccionarioMedidas
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"UnidadesPorCategoria" ofType:@"plist"];
    return [[NSDictionary alloc] initWithContentsOfFile:filePath];
}

+ (NSDictionary *) diccionarioImagenesCategorias
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ImagenesCategorias" ofType:@"plist"];
    return [[NSDictionary alloc] initWithContentsOfFile:filePath];
}


+ (UIImage *) cortarImagen:(UIImage *)imagen dimensiones:(CGRect)rect
{
    imagen = [Utilidades arreglarOrientacionDeImagen:imagen];
    CGImageRef imageRef = CGImageCreateWithImageInRect(imagen.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:imagen.scale orientation:imagen.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}


//Codigo tomado de http://stackoverflow.com/questions/8915630/ios-uiimageview-how-to-handle-uiimage-image-orientation
+ (UIImage *)arreglarOrientacionDeImagen:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *) imagenParaMostrarEnFotoCeldaConTamano:(CGSize)tamanoCelda imagenOriginal:(UIImage *)imagen
{
    CGSize tamanoImagen = imagen.size;
    double escalaCelda = tamanoCelda.width / tamanoCelda.height;
    double alturaResultante = tamanoImagen.width / escalaCelda;
    double yResultante = (tamanoImagen.height - alturaResultante)/2;
    CGRect dimensiones = CGRectMake(0, yResultante, tamanoImagen.width, alturaResultante);
    return [Utilidades cortarImagen:imagen dimensiones:dimensiones];
}

+ (void) guardarImagenDePrueba:(UIImage *)image nombre:(NSString *)nombre
{
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    // New Folder is your folder name
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *fileName = [stringPath stringByAppendingFormat:@"/%@", nombre];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    [data writeToFile:fileName atomically:YES];
}


+ (CGPoint)indiceParaDiminutivoUnidadMedida:(NSString *)diminutivo enDiccionario:(NSDictionary *)dict
{
    NSInteger objectx = 0;
    NSInteger objecty = 0;
    
    for (id key in dict) {
        objecty = 0;
        NSArray *arrayForKey = [dict objectForKey:key];
        for (NSString *unidad in arrayForKey) {
            if ([diminutivo isEqualToString:unidad]) {
                return CGPointMake(objectx, objecty);
            }
            objecty++;
        }
        objectx++;
    }
    
    return CGPointZero; // i.e. NSIntegerMax
}


@end
