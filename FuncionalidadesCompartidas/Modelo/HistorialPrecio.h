//
//  HistorialPrecio.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/12/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistorialPrecio : NSObject

@property (strong, nonatomic) NSString *precio;
@property (strong, nonatomic) NSString *fecha;
@property (strong, nonatomic) NSString *fechaCorta;

- (id)initConAtributos:(NSDictionary *)atributos;

@end
