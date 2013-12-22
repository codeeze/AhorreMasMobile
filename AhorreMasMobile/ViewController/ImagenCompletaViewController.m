//
//  ImagenCompletaViewController.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/16/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "ImagenCompletaViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ImagenCompletaViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imagen;

- (IBAction)cerrarImagen:(id)sender;

@end

@implementation ImagenCompletaViewController

@synthesize urlImagen = _urlImagen;
@synthesize imagen = _imagen;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:_urlImagen];
    [_imagen setImageWithURL:url];
}

- (IBAction)cerrarImagen:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
