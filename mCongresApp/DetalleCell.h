//
//  DetalleCell.h
//  mCongres
//
//  Created by kikito on 11-03-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetalleCell : UITableViewCell
+ (NSString *)reuseIdentifier;

@property (strong, nonatomic) IBOutlet UILabel *nombreExp;
@property (strong, nonatomic) IBOutlet UILabel *fechaExp;
@property (weak, nonatomic) IBOutlet UITextView *detalle1;
@property (weak, nonatomic) IBOutlet UITextView *detalle2;
@property (strong, nonatomic) IBOutlet UIImageView *imagen;
@property (weak, nonatomic) IBOutlet UITextView *detalle3;

@property (weak, nonatomic) IBOutlet UILabel *compania;
@property (weak, nonatomic) IBOutlet UITextView *detalle4;
@property (weak, nonatomic) IBOutlet UITextView *titulopresentacion;
@end
