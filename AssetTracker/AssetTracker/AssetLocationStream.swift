//
//  AssetLocationStream.swift
//  AssetTracker
//
//  Created by Wojciech Nagrodzki on 26/08/2016.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import CoreLocation


struct AssetN
{
    typealias ID = String // asset ID, e.g. 4f0047001951343334363036
    let assetID: ID
}


struct AssetTrackPoint // better name?
{
    let location: CLLocationCoordinate2D
    let timestamp: NSDate
}


protocol AssetLocationStreamDelegate: class
{
    func assetLocationStream(assetLocationStream: AssetLocationStream, didReceiveAssetTrackPoint trackPoint: AssetTrackPoint)
    func assetLocationStream(assetLocationStream: AssetLocationStream, didReceiveError error: ErrorType)
}


class AssetLocationStream
{
    weak var delegate: AssetLocationStreamDelegate?
    private let assetID: AssetN.ID
    private var webSocket: WebSocket!
    
    init(asset: AssetN)
    {
        assetID = asset.assetID
    }
    
    deinit
    {
        webSocket?.close()
    }
    
    func start()
    {
        guard let socket = webSocket else
        {
            setupWebSocketConnection()
            return
        }
        
        socket.open()
    }
    
    func stop()
    {
        guard let socket = webSocket else { return }
        socket.close()
    }
    
    private func setupWebSocketConnection()
    {
        let URL = NSURL(string: "ws://10.100.0.56:9234/device/\(assetID)/location-stream")!
        let URLRequest = NSURLRequest(URL: URL)
        webSocket = WebSocket(request: URLRequest)
        webSocket.compression.on = true
        
        webSocket.event.open = {
            print("opened")
        }
        
        webSocket.event.close = { code, reason, clean in
            print("closed \(code) \(reason) \(clean)")
        }
        
        webSocket.event.error = { [unowned self] error in
            print("error \(error)")
            self.delegate?.assetLocationStream(self, didReceiveError: error)
        }
        
        webSocket.event.message = { data in
            print("message \(data as? String)")
            
            if let string = data as? String
            {
                let dataString = string.dataUsingEncoding(NSUTF8StringEncoding)!
                
                var error: NSError?
                let messageJSON = JSON(data: dataString, options: .AllowFragments, error: &error)
                
                if let error = error
                {
                    // JSON parsing errors
                    self.delegate?.assetLocationStream(self, didReceiveError: error)
                }
                else
                {
                    do
                    {
                        let assetLocation = try AssetTrackPoint(json: messageJSON)
                        self.delegate?.assetLocationStream(self, didReceiveAssetTrackPoint: assetLocation)
                    }
                    catch
                    {
                        // JSON not confirming to schema
                        self.delegate?.assetLocationStream(self, didReceiveError: error)
                    }
                }
            }
        }
    }
}


private extension AssetTrackPoint
{
    init(json: JSON) throws
    {
        location = try json.locationCoordinate2DForKey("data")
        timestamp = try json.timestampForKey("published_at")
    }
}



