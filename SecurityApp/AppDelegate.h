//
//  AppDelegate.h
//  SecurityApp
//
//  Created by Matthew Dobson on 10/30/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SHMKit/SHMRequestFactoryDelegate.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SHMRequestFactoryDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *accessToken;


@end

