//
//  SharedGlobalMemory.h
//  AhorreMasMobile
//
//  Created by Javier Ramirez on 12/16/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Establecimiento.h"

@interface SharedMemoriaGlobal : NSObject

@property Establecimiento *establecimiento;
@property NSString *categoria;
@property NSString *unidadMedida;

+(instancetype)instanciaCompartida;

@end
