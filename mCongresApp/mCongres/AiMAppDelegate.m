//
//  AiMAppDelegate.m
//  mCongres
//
//  Created by luis Gonzalez on 28-02-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.




#import "GAI.h"
#import "Regiztro.h"
#import "Perlazo.h"
#import "Congreso.h"
#import "PBMecaniSync.h"
#import "AiMAppDelegate.h"
#import "PBDuenasCoreData.h"
#import "AiMVariablesGlobales.h"
#import "AiMSideViewController.h"
#import "AiMHomeViewController.h"
#import "AiMSeccionViewController.h"


@implementation AiMAppDelegate

@synthesize viewController, backButtonImage;

- (AiMHomeViewController *)demoController {
	
	return [[AiMHomeViewController alloc]
			initWithNibName:@"AiMHomeViewController" bundle:nil];}

- (UINavigationController *)navigationController {
    return [[UINavigationController alloc]
            initWithRootViewController:[self demoController]];
}

- (MFSideMenu *)sideMenu {
    AiMSideViewController *sideMenuController = [[AiMSideViewController alloc] init];
    UINavigationController *navigationController = [self navigationController];
    
    MFSideMenuOptions options = MFSideMenuOptionMenuButtonEnabled|MFSideMenuOptionBackButtonEnabled
    |MFSideMenuOptionShadowEnabled;
    MFSideMenuPanMode panMode = MFSideMenuPanModeNavigationBar|MFSideMenuPanModeNavigationController;
    
    MFSideMenu *sideMenu = [MFSideMenu menuWithNavigationController:navigationController
                                                 sideMenuController:sideMenuController
                                                           location:MFSideMenuLocationLeft
                                                            options:options
                                                            panMode:panMode];
    sideMenuController.sideMenu = sideMenu;
    
    return sideMenu;
}

- (void) setupNavigationControllerApp {
    self.window.rootViewController = [self sideMenu].navigationController;
    [self.window makeKeyAndVisible];
}


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[PBMecaniSync sharedEngine] registerNSManagedObjectClassToSync:[Perlazo class]];
    [[PBMecaniSync sharedEngine] registerNSManagedObjectClassToSync:[Regiztro class]];
    [[PBMecaniSync sharedEngine] registerNSManagedObjectClassToSync:[Congreso class]];
    
	[GAI sharedInstance].trackUncaughtExceptions = YES; // Enviamos datos a servior de google cada 1 minuto (60 segundos)
    
    [GAI sharedInstance].dispatchInterval = 60; // Optional: set debug to YES for extra debugging information.
    
    [GAI sharedInstance].debug = YES;
	
	
#pragma mark -// Create tracker instance
    
    //id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-37741557-2"];
    
    id<GAITracker> tracker = [[GAI sharedInstance]
							  trackerWithTrackingId:@"UA-39008147-1"];

    [[UINavigationBar appearance] setBackgroundImage:[UIImage
													  imageNamed:@"navbar.png"]
									   forBarMetrics:UIBarMetricsDefault];
	
    [self setupNavigationControllerApp];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor clearColor]];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[PBMecaniSync sharedEngine] startSync];
}

@end
