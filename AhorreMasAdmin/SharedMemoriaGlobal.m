//
//  SharedGlobalMemory.m
//  AhorreMasMobile
//
//  Created by Javier Ramirez on 12/16/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "SharedMemoriaGlobal.h"

@implementation SharedMemoriaGlobal

static SharedMemoriaGlobal *instancia =nil;

+(instancetype)instanciaCompartida
{
    @synchronized(self)
    {
        if(instancia==nil)
        {
            
            instancia = [SharedMemoriaGlobal new];
        }
    }
    return instancia;
}

@end
