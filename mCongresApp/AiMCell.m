//
//  AiMCell.m
//  mCongres
//
//  Created by kikito on 09-03-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.
//

#import "AiMCell.h"

@implementation AiMCell

@synthesize nombreExpositor;
@synthesize fotoExpositor;
@synthesize fecha;
@synthesize detalleX;


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
    return @"CustomCellIdentifier";//identificador para su uso en tablas
}

@end
