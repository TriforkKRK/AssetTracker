//
//  MockLiveTracker.swift
//  AssetTracker
//
//  Created by Daniel Garbień on 24/08/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import MapKit

class MockLiveTracker {

    private var track: (LiveTrackerResult -> Void)!
    private var currentLocation = CLLocationCoordinate2D(latitude: 50.0647, longitude: 19.945)
}

extension MockLiveTracker: LiveTracker {
    
    func startTracking(track: (LiveTrackerResult) -> Void) {
        self.track = track
        trackRecursively()
    }
    
    private func trackRecursively() {
        track(LiveTrackerResult.Track(coordinate: currentLocation, timestamp: NSDate()))
        delay(5) { [weak self] in
            let lat = Double(Int(arc4random_uniform(200)) - 100)/10000
            self?.currentLocation.latitude += lat
            let long = Double(Int(arc4random_uniform(200)) - 100)/10000
            self?.currentLocation.longitude += long
            self?.trackRecursively()
        }
    }
}

private func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

