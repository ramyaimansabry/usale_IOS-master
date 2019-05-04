//
//  AppDelegate.swift
//  usale
//
//  Created by Ahmed masoud on 7/28/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import UserNotifications

let defaults = UserDefaults.standard
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        
        
        
        
        /* UI Enhancments */
        UITabBar.appearance().barTintColor = UIColor(rgb: 0xE91F1F)
        UITabBar.appearance().tintColor = .white
        //        UINavigationBar.appearance().barTintColor = UIColor(rgb: 0xE91F1F)
        UINavigationBar.appearance().tintColor = UIColor(rgb: 0xE91F1F)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(rgb: 0xE91F1F)]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(rgb: 0xE91F1F)]
        
        /* Push notifications configurations */
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        /* Check if user is already logged in */
        if let loggedInClient = defaults.dictionary(forKey: "loggedInClient"){
            if loggedInClient["id"] as! Int != 0 {
                HelperData.sharedInstance.loggedInClient.id = loggedInClient["id"] as! Int
                HelperData.sharedInstance.loggedInClient.name = loggedInClient["name"] as! String
                HelperData.sharedInstance.loggedInClient.email = loggedInClient["email"] as! String
                HelperData.sharedInstance.loggedInClient.phone = loggedInClient["phone"] as! String
                HelperData.sharedInstance.loggedInClient.token = loggedInClient["token"] as! String
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Landing", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "landingTabBar")
                self.window?.rootViewController = tabBarController
                self.window?.makeKeyAndVisible()
            }
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication: String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: nil)
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
            if granted{
                HelperData.sharedInstance.FCM_TOKEN = fcmToken
                if let loggedInClient = defaults.dictionary(forKey: "loggedInClient"){
                    if loggedInClient["id"] as! Int != 0 {
                        ApiManager.sharedInstance.updateFCM(token: fcmToken, completed: { (valid, msg) in
                        })
                    }
                }
            }
        }
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        HelperData.sharedInstance.constructBanner(title: userInfo["title"] as! String, description: userInfo["body"] as! String)
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
