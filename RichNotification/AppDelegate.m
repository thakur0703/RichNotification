//
//  AppDelegate.m
//  RichNotification
//
//  Created by WebDunia on 17/07/18.
//  Copyright © 2018 Webdunia. All rights reserved.
//

#import "AppDelegate.h"
#import "NotificationService.h"

NSString *const pushNotificationCategoryIdent = @"Actionable";
NSString *const pushNotificationFirstActionIdent = @"First_Action";
NSString *const pushNotificationSecondActionIdent = @"Second_Action";

@interface AppDelegate () {
    NSString *devceToken;
    UNUserNotificationCenter *center;
}

@end

NSString * globalVariable;

@implementation AppDelegate


+ (AppDelegate *) appDelegateObject {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self registerForLocalNotification];
    
    UILocalNotification *launchNote = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (launchNote) {
        NSLog(@":%@", launchNote.userInfo);
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - register Notification

- (void) registerForLocalNotification {
    center = [UNUserNotificationCenter currentNotificationCenter];
    [center setDelegate:self];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined || settings.authorizationStatus == UNAuthorizationStatusDenied) {
            
            [self->center requestAuthorizationWithOptions:UNAuthorizationOptionSound + UNAuthorizationOptionBadge + UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *  error) {
                if (!granted) {
                    NSLog(@"something went wrong");
                } else {
                    NSLog(@"request successfully authorized");
                    [self registerForActionablePushNotification];
                }
            }];
        }
    }];
}

- (void)registerForRemoteNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }];
    } else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

#pragma mark - UNUserNotification methods

- (void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler {
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=  10.0) {
//        [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result){}];
//    } else {
//        /// previous stuffs for iOS 9 and below. I've shown an alert wth received data.
//    }
    
    NSLog(@":%@", response.notification.request.content.categoryIdentifier);
    
    if ([response.notification.request.content.categoryIdentifier isEqualToString:@"NotificationCategory1"]) {
        if (response.actionIdentifier == UNNotificationDismissActionIdentifier) {
            NSLog(@"action");
        }
        else if ([response.actionIdentifier  isEqual: @"Delete"]){
            
            NSLog(@"Delete");
        }
        else if ([response.actionIdentifier isEqual: @"Open"]){
            NSLog(@"open");
        }
    }
    
    completionHandler();
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"error here : %@", error);//not called
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    devceToken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSLog(@"Device Token = %@",devceToken);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //Called when a notification is delivered to a foreground app.
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)removeNotifications{
    [center removeAllDeliveredNotifications];
    [center removeAllPendingNotificationRequests];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"info: %@", userInfo);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        
    }
    
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive )
    {
        NSLog( @"INACTIVE" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else if( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground )
    {
        NSLog( @"BACKGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else
    {
        NSLog( @"FOREGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
}

-(void)registerForActionablePushNotification {
    
    UNNotificationAction *firstAction = [UNNotificationAction actionWithIdentifier:pushNotificationFirstActionIdent title:@"First Action" options:UNNotificationActionOptionForeground];
    
    UNNotificationAction *secondAction = [UNNotificationAction actionWithIdentifier:pushNotificationSecondActionIdent title:@"Second Action" options:UNNotificationActionOptionForeground];

    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:pushNotificationCategoryIdent actions:@[firstAction,secondAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    NSSet *categories = [NSSet setWithObject:category];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
}

//- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)(void))completionHandler {
//
//    if ([identifier isEqualToString:pushNotificationFirstActionIdent]) {
//
//        NSLog(@"Action 1");
//
//    }else if ([identifier isEqualToString:pushNotificationSecondActionIdent]){
//
//        NSLog(@"Action 2");
//
//    }
//
//    if (completionHandler) {
//        completionHandler();
//    }
//
//}

- (void) sendNotification {
    UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
    objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"Notification!" arguments:nil];
    objNotificationContent.body = [NSString localizedUserNotificationStringForKey:@"This is local notification message!"
                                                                        arguments:nil];
    objNotificationContent.sound = [UNNotificationSound defaultSound];
    
    /// 4. update application icon badge number
    objNotificationContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
    
    // Deliver the notification in five seconds.
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:10.f repeats:NO];
    
    NSError *error;
    
    UNNotificationAttachment *attachment;
    NSURL *url =  [[NSBundle mainBundle] URLForResource:@"recipe2" withExtension:@"mp4"];
    
    attachment=[UNNotificationAttachment attachmentWithIdentifier:pushNotificationCategoryIdent
                                                              URL: url
                                                          options:nil
                                                            error:&error];
    objNotificationContent.attachments=@[attachment];
    
//    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:pushNotificationCategoryIdent
//                                                                          content:objNotificationContent trigger:trigger];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:pushNotificationCategoryIdent
                                                                          content:objNotificationContent trigger:trigger];
    
    /// 3. schedule localNotification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Local Notification succeeded");
        }
        else {
            NSLog(@"Local Notification failed");
        }
    }];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"RichNotification"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
