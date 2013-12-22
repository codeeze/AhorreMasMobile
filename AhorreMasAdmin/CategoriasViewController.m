//
//  CategoriesViewController.m
//  Precio Digital
//
//  Created by Javier Ramirez on 10/12/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import "CategoriasViewController.h"
#import "Utilidades.h"

@interface CategoriasViewController ()

@property NSDictionary *diccionarioCategorias;
@property NSArray *nombresCategorias;

@end

@implementation CategoriasViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _diccionarioCategorias = [Utilidades diccionarioImagenesCategorias];
    _nombresCategorias = [_diccionarioCategorias allKeys];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_nombresCategorias count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoriaCell" forIndexPath:indexPath];
    NSString *nombreCategoria = [_nombresCategorias objectAtIndex:indexPath.row];
    NSString *archivoImagen = [_diccionarioCategorias objectForKey:nombreCategoria];
    cell.textLabel.text = nombreCategoria;
    UIImage *imagenCategoria = [UIImage imageNamed:archivoImagen];
    cell.imageView.image = imagenCategoria;
    
    return cell;
}



#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    NSString *categoria = [_nombresCategorias objectAtIndex:indexPath.row];
    [_delegate seleccionoCategoria:categoria];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return @"Seleccione una categoría";
}


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
