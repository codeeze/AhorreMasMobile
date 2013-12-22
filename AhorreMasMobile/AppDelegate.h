//
//  AppDelegate.h
//  AhorreMasMobile
//
//  Created by Adalberto on 11/26/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"
#import "Establecimiento.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)mostrarMenuLateral;
- (void)agregarMenuMapa:(Establecimiento *)establecimiento;
- (void)quitarMenuMapa;
- (void)mostrarMenuMapa;
- (void)cambiarVistaFrontal:(UIViewController *)vistaFrontal;

@end
