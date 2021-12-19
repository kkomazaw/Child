//
//  AppDelegate.swift
//  Child
//
//  Created by Matsui Keiji on 2019/02/17.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

enum AppName:String {
    case child
    case kangan
    case shokudou
    case igan
    case daichougan
    case tandougan
    case suigan
    case nyugan
    case haigan
    case lymph
    case meld
    case liverdamage
    case aih1999
    case simpleAIH
    case suien
    case pbc
    case jis
    case clip
    case milan
    case ctcae
    case jas
    case yakubutsu
    case fib
    case nafic
    case bclc
    case hccalgo
    case albi
}

var lungT = 0
var lungN = 0
var lungM = 0

var flagOfLiverDamage = 0
var myValue1 = 1
var myValue2 = 0
var myValue3 = 0
var myValue4 = 0
var myValue5 = 0
var myValue6 = 0
var myValue7 = 0
var myValue8 = 0
var vChusiOrToyochu = 0
var vShokaiOrSaitoyo = 0
var vNissuSegment = 0
var vKeikaSegment = 0
var vKikenInshiSegment = 0
var vYakubutsuIgainoGenin = 0
var vKakonoKanshogai = 0
var vKosankyu = 0
var vDLST = 0
var vGuzenNoSaitoyo = 0
var vTensu = 0
var zenhanText = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Child")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
