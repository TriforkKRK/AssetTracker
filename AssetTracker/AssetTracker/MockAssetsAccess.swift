//
//  MockAssetsAccess.swift
//  AssetTracker
//
//  Created by Daniel Garbień on 23/08/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import MapKit

struct MockAssetAccess {}

extension MockAssetAccess: AssetsAccess {
    
    func fetchAssets(completion: [Asset]? -> Void) {
        completion([
            SimpleAsset(title: "Bike", latitude: 50.0647, longitude: 19.945),
            SimpleAsset(title: "iPhone", latitude: 50.2649, longitude: 19.0238),
            SimpleAsset(title: "Truck full of money", latitude: 52.2296, longitude: 21.0122),
            ])
    }
}

private struct SimpleAsset: Asset {
    let title: String
    let location: CLLocationCoordinate2D
}

extension SimpleAsset {
    init(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.init(title: title, location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
}
