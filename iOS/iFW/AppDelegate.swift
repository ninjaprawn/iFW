//
//  AppDelegate.swift
//  iFW
//
//  Created by George Dan on 28/03/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import UIKit

let height: CGFloat = 60

extension UITabBar {
	override public func sizeThatFits(size: CGSize) -> CGSize {
		var currentSize = super.sizeThatFits(size)
		
		currentSize.height = height - 20
		
		return currentSize
	}
}

extension UINavigationBar {
	override public func sizeThatFits(size: CGSize) -> CGSize {
		var currentSize = super.sizeThatFits(size)
		
		currentSize.height = height - 25
		
		return currentSize
	}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		
		UINavigationBar.appearance().barTintColor = UIColor(red: 65/255, green: 131/255, blue: 215/255, alpha: 1.0)
		UINavigationBar.appearance().tintColor = UIColor.whiteColor()
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(17)]
		
		UITabBar.appearance().barTintColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
		UITabBar.appearance().tintColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)

		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 127/255, green: 140/255, blue: 141/255, alpha: 1.0)], forState: .Normal)
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)], forState: .Selected)
		
		
		// Push notification stuff (ty peter)
		let oneSignal = OneSignal(launchOptions: launchOptions, appId: "Go away", handleNotification: nil)
  
		OneSignal.defaultClient().enableInAppAlertNotification(true)
		requestPushes()
		
		application.applicationIconBadgeNumber = 0
		application.cancelAllLocalNotifications()
		
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
	}
	
	
	// This is from https://github.com/dzt/ftp/blob/master/ios/FTP/AppDelegate.swift.
	
	func requestPushes() {
		
		let settings = UIUserNotificationSettings(forTypes: [.Badge, .Alert], categories: nil)
		UIApplication.sharedApplication().registerUserNotificationSettings(settings)
		UIApplication.sharedApplication().registerForRemoteNotifications()
	}
	
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		print(deviceToken.description)
		
	}
	
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		print(error)
	}

}

