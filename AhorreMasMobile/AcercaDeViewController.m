//
//  AcercaDeViewController.m
//  AhorreMasMobile
//
//  Created by Javier Ramirez on 12/19/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "AcercaDeViewController.h"
#import "AppDelegate.h"

@interface AcercaDeViewController ()

- (IBAction)cargarSitioWebCodeeze:(id)sender;

@end

@implementation AcercaDeViewController

- (IBAction)mostrarMenu:(id)sender {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) mostrarMenuLateral];
}

- (IBAction)cargarSitioWebCodeeze:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.codeeze.net"]];
}

@end
