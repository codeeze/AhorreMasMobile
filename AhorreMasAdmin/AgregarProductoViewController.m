//
//  AgregarProductoViewController.m
//  Ahorre Mas Admin
//
//  Created by Javier Ramirez on 11/19/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import "AgregarProductoViewController.h"
#import "ValorCell.h"
#import "FotoCell.h"
#import "CantidadCell.h"
#import "CodigoBarrasCell.h"
#import "PrecioCell.h"
#import "Utilidades.h"
#import "CategoriasViewController.h"
#import "Producto.h"
#import "RegistroPrecio.h"
#import "UnidadMedidaPickerCell.h"
#import "EstablecimientoFoursquare.h"
#import "Establecimiento.h"
#import "SharedMemoriaGlobal.h"
#import "AgregarProductos.h"
#import "UIImageView+AFNetworking.h"

NSString *const kAgregarProductoCategoriaSegue = @"AgregarProductoCategoriaSegue";
NSString *const kAgregarProductoEstablecimientoSegue = @"AgregarProductoEstablecimientoSegue";

NSString *const kSeleccionCellIdentifier = @"SeleccionCell";

NSInteger const kAgregarProductoSecciones = 2;

NSInteger const kAgregarProductoSeccionInfoProducto = 0;
NSInteger const kAgregarProductoSeccionPrecioEstablecimiento = 1;

NSInteger const kAgregarProductoSeccionInfoProductoFilas = 7;
NSInteger const kAgregarProductoSeccionPrecioEstablecimientoFilas = 2;

NSInteger const kAgregarProductoFilaFotoProducto = 0;
NSInteger const kAgregarProductoFilaCodigoBarras = 1;
NSInteger const kAgregarProductoFilaNombre = 2;
NSInteger const kAgregarProductoFilaMarca = 3;
NSInteger const kAgregarProductoFilaModelo = 4;
NSInteger const kAgregarProductoFilaCategoria = 5;
NSInteger const kAgregarProductoFilaCantidad = 6;
NSInteger const kAgregarProductoFilaUnidadMedida = 7;

NSInteger const kAgregarProductoFilaEstablecimiento = 0;
NSInteger const kAgregarProductoFilaPrecio = 1;

float const kAgregarProductoAlturaCeldaFotoProducto = 200.0f;

NSString *const kUnidadDeMedidaPorDefecto = @"Unidades";

@interface AgregarProductoViewController ()

@property RegistroPrecio *registroPrecio;
@property SharedMemoriaGlobal *variablesGlobales;
@property NSDictionary *diccionarioMedidas;
@property NSInteger numeroDeFilasSeccionInfoProducto;
@property BOOL estaMostrandoPickerMedidas;
@property BOOL estaCargandoImagenProducto;

@property UIImage *fotoCelda;
@property UIImageView *fotoImageView;
@property UITextField *nombreTextField;
@property UITextField *marcaTextField;
@property UITextField *modeloTextField;
@property UITextField *cantidadTextField;
@property UITextField *precioTextField;
@property UIPickerView *medidaPicker;
@property UIButton *botonUnidadMedida;

@end

@implementation AgregarProductoViewController

@synthesize variablesGlobales;
@synthesize producto;
@synthesize estaMostrandoPickerMedidas;
@synthesize registroPrecio;
@synthesize diccionarioMedidas;
@synthesize numeroDeFilasSeccionInfoProducto;

@synthesize fotoImageView;
@synthesize nombreTextField;
@synthesize marcaTextField;
@synthesize modeloTextField;
@synthesize cantidadTextField;
@synthesize precioTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    variablesGlobales = [SharedMemoriaGlobal instanciaCompartida];
    numeroDeFilasSeccionInfoProducto = kAgregarProductoSeccionInfoProductoFilas;
    registroPrecio = [[RegistroPrecio alloc] init];
    registroPrecio.producto = producto;
    diccionarioMedidas = [Utilidades diccionarioMedidas];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manejarTap:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    //Quito el espacio vacio al inicio del tableview
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
}


- (void)cargarImagenProducto {
    if ([producto.urlImagen isKindOfClass:[NSString class]] &&
        ![producto.urlImagen isEqualToString:@""]) {
        _estaCargandoImagenProducto = YES;
        NSURL *urlImagen = [NSURL URLWithString:producto.urlImagen];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlImagen];
        __weak typeof(self) weakSelf = self;
        [fotoImageView setImageWithURLRequest:urlRequest
                               placeholderImage:[UIImage imageNamed:@"CameraPlaceholder"]
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             weakSelf.producto.imagen = image;
             UIImage *imagenRecortada = [Utilidades imagenParaMostrarEnFotoCeldaConTamano:weakSelf.fotoImageView.intrinsicContentSize
                                                                           imagenOriginal:image];
             weakSelf.fotoCelda = imagenRecortada;
             [weakSelf.fotoImageView setImage:imagenRecortada];
             weakSelf.estaCargandoImagenProducto = NO;
         }
                                      failure:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kAgregarProductoSecciones;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger filas = 0;
    if (section == kAgregarProductoSeccionInfoProducto) {
        filas = numeroDeFilasSeccionInfoProducto;
    } else if (section == kAgregarProductoSeccionPrecioEstablecimiento) {
        filas = kAgregarProductoSeccionPrecioEstablecimientoFilas;
    }
    return filas;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat alto = 40.0f;
    if (section == kAgregarProductoSeccionInfoProducto) {
        alto = 0.0f;
    }
    return alto;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float alto = 44.0f;
    
    if (indexPath.section == kAgregarProductoSeccionInfoProducto) {
        if (indexPath.row == kAgregarProductoFilaFotoProducto) {
            alto = kAgregarProductoAlturaCeldaFotoProducto;
        } else if (indexPath.row == kAgregarProductoFilaUnidadMedida) {
            alto = 112.0f;
        }
    }
    
    return alto;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titulo = nil;
    if (section == kAgregarProductoSeccionPrecioEstablecimiento) {
        titulo = @"Precio";
    }
    return titulo;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *defaultCell;
    
    switch (indexPath.section) {
        case kAgregarProductoSeccionInfoProducto:
            if (indexPath.row == kAgregarProductoFilaFotoProducto) {
                FotoCell *cell = [tableView dequeueReusableCellWithIdentifier:kFotoCellIdentifier
                                                                         forIndexPath:indexPath];
                fotoImageView = cell.fotoProducto;
                if (producto.imagen) {
                    if (_fotoCelda) {
                        cell.fotoProducto.image = _fotoCelda;
                    } else {
                        CGRect frame = cell.fotoProducto.frame;
                        frame.size.height = kAgregarProductoAlturaCeldaFotoProducto;
                        cell.fotoProducto.image = [Utilidades imagenParaMostrarEnFotoCeldaConTamano:frame.size
                                                                                     imagenOriginal:producto.imagen];
                    }
                } else {
                    [self cargarImagenProducto];
                }
                defaultCell = cell;
            }
            else if (indexPath.row == kAgregarProductoFilaCodigoBarras) {
                CodigoBarrasCell *cell = [tableView dequeueReusableCellWithIdentifier:kCodigoBarrasCellIdentifier
                                                                         forIndexPath:indexPath];
                cell.codigoBarrasLabel.text = registroPrecio.producto.codigoBarras;
                defaultCell = cell;
            }
            else if (indexPath.row == kAgregarProductoFilaNombre) {
                ValorCell *cell = [tableView dequeueReusableCellWithIdentifier:kValorCellIdentifier
                                                       forIndexPath:indexPath];
                nombreTextField = cell.textField;
                cell.textField.placeholder = @"Nombre";
                if (producto.nombre) {
                    cell.textField.text = producto.nombre;
                }
                defaultCell = cell;
            } else if (indexPath.row == kAgregarProductoFilaMarca) {
                ValorCell *cell = [tableView dequeueReusableCellWithIdentifier:kValorCellIdentifier
                                                                         forIndexPath:indexPath];
                marcaTextField = cell.textField;
                cell.textField.placeholder = @"Marca";
                if (producto.marca) {
                    cell.textField.text = producto.marca;
                }
                defaultCell = cell;
            } else if (indexPath.row == kAgregarProductoFilaModelo) {
                ValorCell *cell = [tableView dequeueReusableCellWithIdentifier:kValorCellIdentifier
                                                                         forIndexPath:indexPath];
                modeloTextField = cell.textField;
                cell.textField.placeholder = @"Modelo (Opcional)";
                if (producto.modelo) {
                    cell.textField.text = producto.modelo;
                }
                defaultCell = cell;
            } else if (indexPath.row == kAgregarProductoFilaCantidad) {
                CantidadCell *cell = [tableView dequeueReusableCellWithIdentifier:kCantidadCellIdentifier
                                                                         forIndexPath:indexPath];
                [cell.unidadButton addTarget:self action:@selector(mostrarPickerMedidas:) forControlEvents:UIControlEventTouchUpInside];
                _botonUnidadMedida = cell.unidadButton;
                //Obtengo la ultima unidad de medida seleccionada por el usuario
                NSString *unidadMedidaGuardada = variablesGlobales.unidadMedida;
                //Si ya tengo la unidad de medida del producto
                if (producto.unidadMedida) {
                    [cell.unidadButton setTitle:[Utilidades diminutivoParaUnidadDeMedida:producto.unidadMedida] forState:UIControlStateNormal];
                } else if (unidadMedidaGuardada) { //Sino muestro la ultima seleccionada
                    producto.unidadMedida = unidadMedidaGuardada;
                    [cell.unidadButton setTitle:[Utilidades diminutivoParaUnidadDeMedida:producto.unidadMedida] forState:UIControlStateNormal];
                } else {
                    producto.unidadMedida = kUnidadDeMedidaPorDefecto;
                }
                cantidadTextField = cell.cantidadTextField;
                if (producto.cantidad) {
                    cell.cantidadTextField.text = [NSString stringWithFormat:@"%i", (int)producto.cantidad];
                } else if (producto.unidadMedida) {
                    cell.cantidadTextField.text = nil;
                }
                defaultCell = cell;
            } else if (indexPath.row == kAgregarProductoFilaCategoria) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeleccionCellIdentifier
                                                                         forIndexPath:indexPath];
                cell.textLabel.text = @"Categoria";
                //Obtengo la ultima categoria seleccionada por el usuario
                NSString *categoriaGuardada = variablesGlobales.categoria;
                if (producto.categoria) {
                    cell.detailTextLabel.text = producto.categoria;
                } else if (categoriaGuardada) {
                    producto.categoria = categoriaGuardada;
                    cell.detailTextLabel.text = categoriaGuardada;
                }
                defaultCell = cell;
            } else if (indexPath.row == kAgregarProductoFilaUnidadMedida) {
                UnidadMedidaPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:kUnidadMedidaPickerCellIdentifier
                                                                        forIndexPath:indexPath];
                _medidaPicker = cell.unidadMedidaPicker;
                defaultCell = cell;
            }
            break;
        case kAgregarProductoSeccionPrecioEstablecimiento:
            if (indexPath.row == kAgregarProductoFilaEstablecimiento) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeleccionCellIdentifier
                                                       forIndexPath:indexPath];
                cell.textLabel.text = @"Establecimiento";
                //Obtengo la ultima categoria seleccionada por el usuario
                Establecimiento *establecimientoGuardado = variablesGlobales.establecimiento;
                if (registroPrecio.establecimiento) {
                    cell.detailTextLabel.text = registroPrecio.establecimiento.nombre;
                } else if (establecimientoGuardado) {
                    registroPrecio.establecimiento = establecimientoGuardado;
                    cell.detailTextLabel.text = establecimientoGuardado.nombre;
                }
                defaultCell = cell;
            } else if (indexPath.row == kAgregarProductoFilaPrecio) {
                PrecioCell *cell = [tableView dequeueReusableCellWithIdentifier:kPrecioCellIdentifier
                                                                     forIndexPath:indexPath];
                cell.monedaLabel.text = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
                precioTextField = cell.precioTextField;
                cell.precioTextField.tag = kPrecioTextFieldTag;
                if (registroPrecio.precio) {
                    cell.precioTextField.text = [NSString stringWithFormat:@"%.2f", registroPrecio.precio];
                }
                defaultCell = cell;
            }
            break;
        default:
            break;
    }
    
    return defaultCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == kAgregarProductoSeccionInfoProducto) {
        if ((indexPath.row == kAgregarProductoFilaFotoProducto) && (!_estaCargandoImagenProducto)) {
            [self tomarFoto];
        } else if (indexPath.row == kAgregarProductoFilaCategoria) {
            [self performSegueWithIdentifier:kAgregarProductoCategoriaSegue
                                      sender:self];
        } else if (indexPath.row == kAgregarProductoFilaCantidad) {
            if (estaMostrandoPickerMedidas) {
                [self ocultarPickerMedidas];
            }
        }
    }
    else if (indexPath.section == kAgregarProductoSeccionPrecioEstablecimiento) {
        if (indexPath.row == kAgregarProductoFilaEstablecimiento) {
            [self performSegueWithIdentifier:kAgregarProductoEstablecimientoSegue
                                      sender:self];
        }
    }
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == kAgregarProductoFilaUnidadMedida){
        CGPoint localizacionUnidad = [Utilidades indiceParaDiminutivoUnidadMedida:producto.unidadMedida enDiccionario:diccionarioMedidas];
        [_medidaPicker selectRow:localizacionUnidad.x inComponent:0 animated:YES];
        [_medidaPicker reloadComponent:1];
        [_medidaPicker selectRow:localizacionUnidad.y inComponent:1 animated:YES];
    }
}


#pragma mark - GestureRecognizer

-(void) manejarTap:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}


#pragma mark - Picker Unidad de Medida

- (void) ocultarPickerMedidas
{
    NSIndexPath *medidaIndexPath = [NSIndexPath indexPathForRow:kAgregarProductoFilaUnidadMedida inSection:kAgregarProductoSeccionInfoProducto];
    NSArray *arreglo = [NSArray arrayWithObject:medidaIndexPath];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:arreglo withRowAnimation:UITableViewRowAnimationFade];
    numeroDeFilasSeccionInfoProducto--;
    [self.tableView endUpdates];
    estaMostrandoPickerMedidas = NO;
}

- (void) mostrarPickerMedidas
{
    NSIndexPath *medidaIndexPath = [NSIndexPath indexPathForRow:kAgregarProductoFilaUnidadMedida inSection:kAgregarProductoSeccionInfoProducto];
    NSArray *arreglo = [NSArray arrayWithObject:medidaIndexPath];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:arreglo withRowAnimation:UITableViewRowAnimationFade];
    numeroDeFilasSeccionInfoProducto++;
    [self.tableView endUpdates];
    estaMostrandoPickerMedidas = YES;
}

-(void) mostrarPickerMedidas:(id)sender
{
    if (estaMostrandoPickerMedidas) {
        [self ocultarPickerMedidas];
    } else {
        [self mostrarPickerMedidas];
    }
}


#pragma mark - Agregar Producto

- (IBAction)agregarProducto:(id)sender
{
    [self.view endEditing:YES];
    NSMutableString *mensajeError = [NSMutableString string];
    if ((!producto.nombre) || ([producto.nombre isEqualToString:@""])) {
        [mensajeError appendString:@"El campo nombre es requerido.\n"];
    }
    if ((!producto.marca) || ([producto.marca isEqualToString:@""])) {
        [mensajeError appendString:@"El campo marca es requerido.\n"];
    }
    if (!producto.cantidad) {
        [mensajeError appendString:@"El campo contenido neto es requerido. Ejemplo: 1 unidades.\n"];
    }
    if (!producto.categoria) {
        [mensajeError appendString:@"El campo categoria es requerido.\n"];
    }
    if (!producto.modelo) {
        producto.modelo = @"-";
    }
    if (!registroPrecio.establecimiento) {
        [mensajeError appendString:@"El campo establecimiento es requerido.\n"];
    }
    if (!registroPrecio.precio) {
        [mensajeError appendString:@"El campo precio es requerido.\n"];
    }
    
    if ([mensajeError length] != 0) {
        [mensajeError deleteCharactersInRange:
         NSMakeRange(([mensajeError length] - 1), 1)];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message:mensajeError delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [AgregarProductos agregarProducto:registroPrecio withBlock:^(NSError *error)
         {
             if (error) {
                 UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Agregar Producto"
                                                                  message:error.description
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                 [alerta show];
             } else {
                 UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Agregar Producto"
                                                                  message:@"Producto agregado con éxito."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                 [alerta show];
                 if (producto.imagen) {
                     [AgregarProductos subirFotoProducto:registroPrecio.producto withBlock:^(NSError *error)
                      {
                          if (error) {
                              NSLog(@"Error: %@", error);
                          }
                      }];
                 }
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }];
        
    }
}


#pragma mark - Manejo de camara

-(void) tomarFoto
{
    [self startCameraControllerFromViewController:self
                                    usingDelegate:self];
}


- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *tipoMultimedia = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *imagenOriginal, *imagenEditada, *imagenAGuardar;
    
    if ([tipoMultimedia isEqualToString:@"public.image"]) {
        
        imagenEditada = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        imagenOriginal = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (imagenEditada) {
            imagenAGuardar = imagenEditada;
        } else {
            imagenAGuardar = imagenOriginal;
        }
        producto.imagen = imagenAGuardar;
        [self.tableView reloadData];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - CategoriasViewControllerDelegate

- (void) seleccionoCategoria:(NSString *)categoria
{
    //Guardo la categoria seleccionada en los user defaults
    variablesGlobales.categoria = categoria;
    producto.categoria = categoria;
    [self.tableView reloadData];
}



#pragma mark - EstablecimientoViewControllerDelegate

-(void) seleccionoEstablecimiento:(EstablecimientoFoursquare *)establecimiento
{
    Establecimiento *nuevoEstablecimiento = [[Establecimiento alloc] initConEstablecimientoFoursquare:establecimiento];
    variablesGlobales.establecimiento = nuevoEstablecimiento;
    registroPrecio.establecimiento = nuevoEstablecimiento;
    [self.tableView reloadData];
}


#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger filas = 0;
    if (component == 0) {
        filas = [diccionarioMedidas count];
    } else if (component == 1) {
        NSInteger indiceSeleccionado = [pickerView selectedRowInComponent:0];
        NSString *categoriaSeleccionada = [[diccionarioMedidas allKeys] objectAtIndex:indiceSeleccionado];
        filas = [[diccionarioMedidas objectForKey:categoriaSeleccionada] count];
    }
    return filas;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *titulo = nil;
    if (component == 0) {
        titulo = [[diccionarioMedidas allKeys] objectAtIndex:row];
    } else if (component == 1) {
        NSInteger indiceSeleccionado = [pickerView selectedRowInComponent:0];
        NSString *categoriaSeleccionada = [[diccionarioMedidas allKeys] objectAtIndex:indiceSeleccionado];
        NSArray *unidadesDisponibles = [diccionarioMedidas objectForKey:categoriaSeleccionada];
        if ([unidadesDisponibles count] > row) {
            titulo = [unidadesDisponibles objectAtIndex:row];
        }
    }
    return titulo;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        [pickerView reloadAllComponents];
    }
    NSInteger indiceSeleccionado = [pickerView selectedRowInComponent:1];
    NSString *unidadMedida = [self pickerView:pickerView titleForRow:indiceSeleccionado forComponent:1];
    
    //Guardo la unidad seleccionada en los user defaults
    variablesGlobales.unidadMedida= unidadMedida;
    
    producto.unidadMedida = unidadMedida;
    
    [_botonUnidadMedida setTitle:[Utilidades diminutivoParaUnidadDeMedida:producto.unidadMedida] forState:UIControlStateNormal];
}

#pragma mark - TextField delegate

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == nombreTextField) {
        producto.nombre = nombreTextField.text;
    } else if (textField == marcaTextField) {
        producto.marca = marcaTextField.text;
    } else if (textField == modeloTextField) {
        producto.modelo = modeloTextField.text;
    } else if (textField == cantidadTextField) {
        producto.cantidad = [cantidadTextField.text floatValue];
    } else if (textField == precioTextField) {
        NSString *precio = [precioTextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
        registroPrecio.precio = [precio doubleValue];
    }
}


#pragma mark - Navigacion


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kAgregarProductoCategoriaSegue]) {
        CategoriasViewController *categorias =
        (CategoriasViewController *)segue.destinationViewController;
        [categorias setDelegate:self];
    } else if ([segue.identifier isEqualToString:kAgregarProductoEstablecimientoSegue]) {
        EstablecimientoViewController *establecimientoVC =
        (EstablecimientoViewController *)segue.destinationViewController;
        [establecimientoVC setDelegate:self];
    }
}

@end
