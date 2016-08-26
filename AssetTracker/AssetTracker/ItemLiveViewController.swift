//
//  ItemLiveViewController.swift
//  AssetTracker
//
//  Created by Daniel Garbień on 24/08/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import UIKit
import MapKit

enum LiveTrackerResult {
    case Track(coordinate: CLLocationCoordinate2D, timestamp: NSDate)
    case Error
}

protocol LiveTracker {
    
    func startTracking(track: (LiveTrackerResult) -> Void)
}


class ItemLiveViewController: UIViewController {

    init(asset: AssetN, initialCoordinate: CLLocationCoordinate2D, indicatorColor: UIColor) {
        assetLocationStream = AssetLocationStream(asset: asset)
        self.initialCoordinate = initialCoordinate
        self.indicatorColor = indicatorColor
        super.init(nibName: nil, bundle: nil)
        assetLocationStream.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentLocationAnnotation(initialCoordinate)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        assetLocationStream.start()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        assetLocationStream.stop()
    }
    
    private let assetLocationStream: AssetLocationStream
    private let initialCoordinate: CLLocationCoordinate2D
    private let indicatorColor: UIColor
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.region = MKCoordinateRegionMakeWithDistance(initialCoordinate, 10000, 10000)
            mapView.delegate = self
        }
    }
    private var coordinates = [CLLocationCoordinate2D]()
}

extension ItemLiveViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Annotation else {
            return nil
        }
        return mapView.dequeueAnnotationViewWithAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 5
        return renderer
    }
}

private extension ItemLiveViewController {
    
    func consume(trackerResult: LiveTrackerResult) {
        switch trackerResult {
        case let .Track(coordinate, _):
            consume(coordinate)
        case .Error:
            print("LiveTrackerResult error")
            return
        }
    }
    
    func consume(coordinate: CLLocationCoordinate2D) {
        defer {
            coordinates.append(coordinate)
            updateCurrentLocationAnnotation(coordinate)
        }
        guard let lastCoordinate = coordinates.last else {
            return
        }
        var polylineCoordinates = [lastCoordinate, coordinate]
        mapView.addOverlay(MKPolyline(coordinates: &polylineCoordinates, count: polylineCoordinates.count))
    }
    
    func updateCurrentLocationAnnotation(coordinate: CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(Annotation(coordinate: coordinate, color: indicatorColor))
        
        // center map only if indicator has moved
        let mapPoint = MKMapPointForCoordinate(coordinate)
        let mapRect = mapView.visibleMapRect
        if !MKMapRectContainsPoint(mapRect, mapPoint)
        {
            mapView.setCenterCoordinate(coordinate, animated: true)
        }
    }
}


extension ItemLiveViewController: AssetLocationStreamDelegate
{
    func assetLocationStream(assetLocationStream: AssetLocationStream, didReceiveAssetTrackPoint trackPoint: AssetTrackPoint)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock { self.consume(trackPoint.location) }
    }
    
    func assetLocationStream(assetLocationStream: AssetLocationStream, didReceiveError error: ErrorType)
    {
        
    }
}
