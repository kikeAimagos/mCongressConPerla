//
//  DetalleCell.m
//  mCongres
//
//  Created by kikito on 11-03-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.
//

#import "DetalleCell.h"

@implementation DetalleCell
@synthesize nombreExp;
@synthesize detalle1;
@synthesize detalle2;
@synthesize imagen;
@synthesize fechaExp;
@synthesize compania;
@synthesize titulopresentacion;
@synthesize detalle3;
@synthesize detalle4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
		// Configure the view for the selected state
}
+ (NSString *)reuseIdentifier {
    return @"CeldaDetalle"; //identificador para su uso en tablas
}


@end
