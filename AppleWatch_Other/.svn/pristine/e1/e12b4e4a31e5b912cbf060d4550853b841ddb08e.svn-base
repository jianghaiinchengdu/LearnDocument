//
//  AppDelegate.swift
//  AppleWatch
//
//  Created by jianghai on 15/11/6.
//  Copyright © 2015年 jianghai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        defaults?.setBool(true, forKey:("enabled_preference"))
        
        
//        let notify = UILocalNotification()
//        notify.fireDate = NSDate(timeIntervalSinceNow: 10)
//        
//        notify.hasAction = false
//        notify.alertTitle = "TitleTitle"
//        notify.applicationIconBadgeNumber = 2
//        notify.userInfo = ["message":"localNotification"]
//        notify.category = "myCate"
//        
//        
//        let setting = UIUserNotificationSettings(forTypes: .Badge, categories:nil)
//        
//        UIApplication.sharedApplication().registerUserNotificationSettings(setting)
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let notification = UILocalNotification()
        //notification.fireDate = NSDate().dateByAddingTimeInterval(1)
        //setting timeZone as localTimeZone
        notification.timeZone = NSTimeZone.systemTimeZone()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.alertTitle = "This is a local notification"
        notification.alertBody = "Hey,It's great to see you again"
        notification.alertAction = "OK"
        notification.category = "MyNotification"
        notification.applicationIconBadgeNumber = 10
        var userInfo = ["message":"localNotification"]
        userInfo["kLocalNotificationID"] = "LocalNotificationID"
        userInfo["key"] = "Attention Please"
        notification.userInfo = userInfo
        
        
        let categ = UIMutableUserNotificationCategory()
        categ.identifier = "MyNotification"
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:
            [.Alert,.Badge,.Sound], categories: [categ]))
        
        
        application.scheduleLocalNotification(notification)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification){
        print(notification)
    }

}

