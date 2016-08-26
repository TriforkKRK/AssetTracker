//
//  AppDelegate.swift
//  AssetTracker
//
//  Created by Daniel Garbień on 22/08/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private lazy var navController = UINavigationController()
    let assetsAccess = MockAssetAccess()

    func applicationDidFinishLaunching(application: UIApplication) {

        let itemsVC = ItemsListViewController(assetsAccess: assetsAccess, delegate: self)
        itemsVC.title = "Asset Tracker"
        navController.pushViewController(itemsVC, animated: false)
        
        window = UIWindow()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate: ItemsListViewControllerDelegate {
    
    func itemsListViewController(controller: ItemsListViewController, didRequestDetailsForAsset asset: Asset, color: UIColor) {
        
        let assetN = AssetN(assetID: "4f0047001951343334363036")
        
        let liveVC = ItemLiveViewController(asset: assetN, initialCoordinate: asset.location, indicatorColor: color)
        liveVC.title = asset.title
        navController.pushViewController(liveVC, animated: true)
    }
}
