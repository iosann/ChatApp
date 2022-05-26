//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Anna Belousova on 20.02.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var lastState = UIApplication.shared.applicationState
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure(options: createFirebaseOptions())
        if UserDefaults.standard.string(forKey: "DeviceId") == nil, let uuid = UIDevice.current.identifierForVendor?.uuidString {
                UserDefaults.standard.setValue(uuid, forKey: "DeviceId")
            }
//        NSLog("Application moved from not running to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
        return true
    }
    
    private func createFirebaseOptions() -> FirebaseOptions {
       let secondaryOptions = FirebaseOptions(
           googleAppID: Bundle.main.object(forInfoDictionaryKey: "googleAppID") as? String ?? "",
           gcmSenderID: Bundle.main.object(forInfoDictionaryKey: "gcmSenderID") as? String ?? "")
       secondaryOptions.apiKey = Bundle.main.object(forInfoDictionaryKey: "gcmSenderID") as? String
       secondaryOptions.projectID = Bundle.main.object(forInfoDictionaryKey: "projectID") as? String
       secondaryOptions.bundleID = Bundle.main.object(forInfoDictionaryKey: "bundleID") as? String ?? ""
       secondaryOptions.clientID = Bundle.main.object(forInfoDictionaryKey: "clientID") as? String
       let string = Bundle.main.object(forInfoDictionaryKey: "databaseURL") as? String
       secondaryOptions.databaseURL = "https://" + (string ?? "")
       secondaryOptions.storageBucket = Bundle.main.object(forInfoDictionaryKey: "storageBucket") as? String
       return secondaryOptions
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = RootAssembly.presentationAssembly.getConversationsListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
//        UIBarButtonItem.appearance().setTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: 30), for: .default)
        ThemeManager.apply()
        
//        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
//        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
//        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
//        NSLog("Application moved from \(lastState.name) to \(application.applicationState.name): \(#function)")
        lastState = application.applicationState
    }
}
