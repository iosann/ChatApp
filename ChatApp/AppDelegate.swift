//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Anna Belousova on 20.02.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var lastState = UIApplication.shared.applicationState
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NSLog("Application moved from not running to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
    }
}
