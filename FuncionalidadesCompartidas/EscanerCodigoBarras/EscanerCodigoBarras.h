//
//  EscanerCodigoBarras.h
//  AhorreMasMobile
//
//  Created by Adalberto on 11/26/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol EscanerCodigoBarrasDelegate

@required
- (void)codigoEncontrado:(NSString *)codigo;

@end

@interface EscanerCodigoBarras : UIView

@property (weak, nonatomic) id<EscanerCodigoBarrasDelegate> delegate;

- (void)crearEscaner;
- (void)crearEscanerConTexto:(NSString *)texto;
- (void)iniciarEscaner;
- (void)detenerEscaner;

@end


