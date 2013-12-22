//
//  AppDelegate.m
//  AhorreMasMobile
//
//  Created by Adalberto on 11/26/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MenuMapaViewController.h"

@interface AppDelegate() <PKRevealing>

@property (nonatomic, strong, readwrite) PKRevealController *menuController;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [self cargarMenuLateral];
    return YES;
}

#pragma mark - PKRevealing methods

- (void)cargarMenuLateral {
    UIViewController *menuViewController =
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
     instantiateViewControllerWithIdentifier:@"menuViewController"];
    
    UINavigationController *frontViewController =
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
     instantiateViewControllerWithIdentifier:@"busquedaProductoViewController"];
    
    self.menuController = [PKRevealController revealControllerWithFrontViewController:frontViewController
                                                                   leftViewController:menuViewController];
    self.menuController.delegate = self;
    self.menuController.animationDuration = 0.25f;
	[self.menuController setMinimumWidth:220.0f
                            maximumWidth:220.0f
                       forViewController:menuViewController];
    self.window.rootViewController = self.menuController;
    [self.window makeKeyAndVisible];
}

- (void)mostrarMenuLateral {
    [self.menuController showViewController:self.menuController.leftViewController];
}

- (void)agregarMenuMapa:(Establecimiento *)establecimiento {
    UIViewController *menuMapaViewController =
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
     instantiateViewControllerWithIdentifier:@"menuMapaViewController"];
    ((MenuMapaViewController *)menuMapaViewController).establecimiento = establecimiento;
    [self.menuController setRightViewController:menuMapaViewController];
    [self.menuController setMinimumWidth:270.0f
                            maximumWidth:270.0f
                       forViewController:menuMapaViewController];
}

- (void)quitarMenuMapa {
    [self.menuController setRightViewController:nil];
}

- (void)mostrarMenuMapa {
    [self.menuController showViewController:self.menuController.rightViewController];
}

- (void)cambiarVistaFrontal:(UIViewController *)vistaFrontal {    
    [self.menuController setFrontViewController:vistaFrontal];
    [self.menuController resignPresentationModeEntirely:YES
                                               animated:YES
                                             completion:nil];
}

@end
