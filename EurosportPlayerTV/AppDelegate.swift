//
//  AppDelegate.swift
//  EurosportPlayerTV
//
//  Created by Alexander Edge on 30/04/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import CoreData
import EurosportKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    lazy var managedObjectContext: NSManagedObjectContext = {
        let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        try! psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options:nil)
        let context = NSManagedObjectContext( concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        return context
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        guard let tabController = window?.rootViewController as? UITabBarController, let viewControllers = tabController.viewControllers else {
            fatalError("wrong view controller type")
        }
        
        for controller in viewControllers {
            guard let vc = controller as? ManagedObjectContextSettable else {
                continue
            }
            vc.managedObjectContext = managedObjectContext
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //self.saveContext()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //self.saveContext()
    }

    private lazy var applicationCachesDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "uk.co.alexedge.EurosportPlayerTV" in the application's caches Application Support directory.
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls.last!
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle(for: Sport.self).url(forResource: "EurosportKit", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var storeURL: URL = {
        return self.applicationCachesDirectory.appendingPathComponent("EurosportPlayerTV.sqlite")
    }()
    
    private func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

