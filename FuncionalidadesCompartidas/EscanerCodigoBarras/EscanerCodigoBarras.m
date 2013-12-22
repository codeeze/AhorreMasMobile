//
//  EscanerCodigoBarras.m
//  AhorreMasMobile
//
//  Created by Adalberto on 11/26/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "EscanerCodigoBarras.h"

float const kGuiaEscanerAncho = 250.0f;
float const kGuiaEscanerAlto = 125.0f;
float const kCodigoBarraImagenAncho = 32.5f;
float const kCodigoBarraImagenAlto = 22.0f;
float const kCodigoBarraImagenMargenH = 6.0f;
float const kCodigoBarraImagenMargenV = 20.0f;
float const kEscanerAyudaAncho = 200.0f;
float const kEscanerAyudaAlto = 35.0f;
float const kEscanerAyudaMargenH = 10.0f;
float const kEscanerAyudaMargenV = 13.0f;
float const kEscanerAyudaLetra = 14.0f;
float const kEstatusBarNavigationBarAlto = 64.0f;

@interface EscanerCodigoBarras() <AVCaptureMetadataOutputObjectsDelegate>

@property (strong) AVCaptureSession *sesionCapturaVideo;

@end

@implementation EscanerCodigoBarras

@synthesize sesionCapturaVideo = _sesionCapturaVideo;
@synthesize delegate = _delegate;

#pragma mark - Initialization methods

- (void)dealloc {
    [self detenerEscaner];
}

#pragma mark - EscanerCodigoBarras methods

- (void)crearEscaner {
    [self crearEscanerConTexto:@"Apunte la cámara a un código de barras para buscar un producto"];
}

- (void)crearEscanerConTexto:(NSString *)texto {
    [self iniciarSesionCapturaVideo];
    [self agregarCapasVista:self.frame
               conTextoGuia:texto];
}

- (void)iniciarEscaner {
    [self.sesionCapturaVideo startRunning];
}

- (void)detenerEscaner {
    [self.sesionCapturaVideo stopRunning];
}

- (void)iniciarSesionCapturaVideo {
    @try {
        // Seteo de la sesión de captura de códigos de barra.
        self.sesionCapturaVideo = [[AVCaptureSession alloc] init];
        AVCaptureDevice *dispositivoCapturaVideo = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:dispositivoCapturaVideo
                                                                                 error:&error];
        if (videoInput) {
            [self.sesionCapturaVideo addInput:videoInput];
        } else {
            NSLog(@"Error: %@", error);
        }
        
        // Adjuntar a la sesión los tipos de datos.
        AVCaptureMetadataOutput *salidaMetadata = [[AVCaptureMetadataOutput alloc] init];
        [self.sesionCapturaVideo addOutput:salidaMetadata];
        [salidaMetadata setMetadataObjectsDelegate:self
                                             queue:dispatch_get_main_queue()];
        [salidaMetadata setMetadataObjectTypes:@[AVMetadataObjectTypeEAN8Code,
                                                 AVMetadataObjectTypeEAN13Code]];
    }
    @catch (NSException *exception) {
        NSLog(@"AVCaptureDevice exception: %@", exception.reason);
    }
    @finally {
        // Do nothing.
    }
}

- (void)agregarCapasVista:(CGRect)frame
             conTextoGuia:(NSString *)textoGuia {
    // Adjuntar vista previa a la interfaz.
    AVCaptureVideoPreviewLayer *capaVistaPrevia = [[AVCaptureVideoPreviewLayer alloc]
                                                   initWithSession:self.sesionCapturaVideo];
    capaVistaPrevia.frame = frame;
    [self.layer addSublayer:capaVistaPrevia];
    
    // Adjuntar a la vista la guía visual para el escaner.
    UIImageView *guiaEscaner = [[UIImageView alloc] initWithImage:
                                [UIImage imageNamed:@"barcodeGuide"]];
    float altoTotalGuia = kGuiaEscanerAlto + kEscanerAyudaAlto + kEscanerAyudaMargenV;
    [guiaEscaner setFrame:CGRectMake(((self.superview.bounds.size.width - kGuiaEscanerAncho) / 2),
                                     ((self.superview.bounds.size.height - kEstatusBarNavigationBarAlto - altoTotalGuia) / 2),
                                     kGuiaEscanerAncho,
                                     kGuiaEscanerAlto)];
    [self addSubview:guiaEscaner];
    
    // Adjuntar la imagen de la ayuda para el escaner.
    UIImageView *codigoBarra = [[UIImageView alloc] initWithImage:
                                [UIImage imageNamed:@"barcode"]];
    [codigoBarra setFrame:CGRectMake((guiaEscaner.frame.origin.x + kCodigoBarraImagenMargenH),
                                     (guiaEscaner.frame.origin.y + kGuiaEscanerAlto + kCodigoBarraImagenMargenV),
                                     kCodigoBarraImagenAncho,
                                     kCodigoBarraImagenAlto)];
    [self addSubview:codigoBarra];
    
    // Adjuntar el texto de ayuda del escaner.
    UILabel *escanerAyuda = [[UILabel  alloc] initWithFrame:
                             CGRectMake(codigoBarra.frame.origin.x + kCodigoBarraImagenAncho + kEscanerAyudaMargenH,
                                        (guiaEscaner.frame.origin.y + kGuiaEscanerAlto + kEscanerAyudaMargenV),
                                        kEscanerAyudaAncho,
                                        kEscanerAyudaAlto)];
    [escanerAyuda setText:textoGuia];
    [escanerAyuda setFont:[UIFont fontWithName:@"HelveticaNeue-Thin"
                                          size:kEscanerAyudaLetra]];
    [escanerAyuda setNumberOfLines:0];
    [escanerAyuda setTextColor:[UIColor whiteColor]];
    [self addSubview:escanerAyuda];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataObject *metadataObjeto in metadataObjects) {
        AVMetadataMachineReadableCodeObject *objectoLeido = (AVMetadataMachineReadableCodeObject *)metadataObjeto;
        
        if([metadataObjeto.type isEqualToString:AVMetadataObjectTypeEAN8Code] ||
           [metadataObjeto.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            [self.delegate codigoEncontrado:objectoLeido.stringValue];
            break;
        }
    }
}

@end
