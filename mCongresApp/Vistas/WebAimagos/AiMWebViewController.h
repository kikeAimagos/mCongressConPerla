//
//  AiMWebViewController.h
//  mCongres
//
//  Created by luis Gonzalez on 07-03-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AiMVistaPerlaDetalleViewController.h"

@interface AiMWebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *TextoPerla;
@property (strong, nonatomic) IBOutlet UIWebView *WebAimagos;
@property (strong, nonatomic) NSURL        *url ;

- (IBAction)EventoPerlaDetalle:(UIButton *)sender;

@end
