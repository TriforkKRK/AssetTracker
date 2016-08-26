//
//  AssetListProvider.swift
//  AssetTracker
//
//  Created by Wojciech Nagrodzki on 26/08/2016.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import CoreLocation


protocol AssetListProviderDelegate: class
{
    func assetListProvider(assetListProvider: AssetListProvider, didReceiveAssets assets: [String])
    func assetListProvider(assetListProvider: AssetListProvider, didReceiveError error: ErrorType)
}


struct AssetN
{
    typealias ID = String // asset ID, e.g. 4f0047001951343334363036
    let assetID: ID
    let displayName: String
    let lastLocation: CLLocationCoordinate2D
}


class AssetListProvider
{
    var delegate: AssetListProviderDelegate?
    private let operationQueue = NSOperationQueue()
    
    
    init()
    {
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    func fetch()
    {
        operationQueue.addOperationWithBlock
        {
            do
            {
                let URL = NSURL(string: "http://jsonplaceholder.typicode.com/posts/1")!
                let data = try NSData(contentsOfURL: URL, options: [])
            }
            catch
            {
                self.delegate?.assetListProvider(self, didReceiveError: error)
            }
        }
    }
}


private extension AssetN
{
    init(json: JSON) throws
    {
        assetID = try json.stringForKey("ID")
        displayName = try json.stringForKey("displayName")
        lastLocation = try json.locationCoordinate2DForKey("data")
    }
}