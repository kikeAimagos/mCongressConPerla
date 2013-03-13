//
//  AiMAppDelegate.h
//  mCongres
//
//  Created by luis Gonzalez on 28-02-13.
//  Copyright (c) 2013 luis Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "AiMHomeViewController.h"


@class AiMViewController;


@interface AiMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIImage *backButtonImage;

@property (strong, nonatomic) AiMHomeViewController *viewController;
@end
