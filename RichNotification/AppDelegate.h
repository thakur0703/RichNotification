//
//  AppDelegate.h
//  RichNotification
//
//  Created by WebDunia on 17/07/18.
//  Copyright © 2018 Webdunia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

+ (AppDelegate *) appDelegateObject;

- (void) sendNotification;

@end

