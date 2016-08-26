//
//  MockAssetsAccess.swift
//  AssetTracker
//
//  Created by Daniel Garbień on 23/08/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import MapKit

struct MockAssetAccess
{
    private let operationQueue = NSOperationQueue()
    init()
    {
        operationQueue.maxConcurrentOperationCount = 1
    }
}

extension MockAssetAccess: AssetsAccess
{
    func fetchAssets(completion: [SimpleAsset]? -> Void)
    {
        operationQueue.addOperationWithBlock
        {
            do
            {
                let URL = NSURL(string: "http://10.100.0.56:9234/devices")!
                let data = try NSData(contentsOfURL: URL, options: [])
                
                var error: NSError?
                let messageJSON = JSON(data: data, options: .AllowFragments, error: &error)
                
                if error != nil
                {
                    NSOperationQueue.mainQueue().addOperationWithBlock { completion(nil) }
                }
                else
                {
                    if let array = messageJSON.array
                    {
//                        WTF?
//                        let assets = array.map { SimpleAsset(json: $0) }
//                        completion(assets)
                        var simpleAssets = [SimpleAsset]()
                        for json in array
                        {
                            let asset = try SimpleAsset(json: json)
                            simpleAssets.append(asset)
                        }
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock { completion(simpleAssets) }
                    }
                    else
                    {
                        NSOperationQueue.mainQueue().addOperationWithBlock { completion(nil) }
                    }
                }
            }
            catch
            {
                NSOperationQueue.mainQueue().addOperationWithBlock { completion(nil) }
            }
        }
    }
}

struct SimpleAsset {
    let title: String
    let location: CLLocationCoordinate2D
}

extension SimpleAsset {
    init(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.init(title: title, location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
}

extension SimpleAsset
{
    init(json: JSON) throws
    {
        title = try json.stringForKey("display_name")
        location = try json.locationCoordinate2DForKey("data")
    }
}

