//
//  AiMCell.h
//  mCongres
//
//  Created by kikito on 09-03-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AiMCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fecha;
@property (weak, nonatomic) IBOutlet UILabel *nombreExpositor;
@property (weak, nonatomic) IBOutlet UITextView *detalleX;
@property (weak, nonatomic) IBOutlet UIImageView *fotoExpositor;
+ (NSString *)reuseIdentifier;
@end
