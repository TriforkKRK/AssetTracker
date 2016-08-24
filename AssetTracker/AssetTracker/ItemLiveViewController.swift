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

    init(tracker: LiveTracker, initialCoordinate: CLLocationCoordinate2D, indicatorColor: UIColor) {
        self.tracker = tracker
        self.initialCoordinate = initialCoordinate
        self.indicatorColor = indicatorColor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentLocationAnnotation(initialCoordinate)
        tracker.startTracking { [weak self] result in
            self?.consume(result)
        }
    }
    
    private let tracker: LiveTracker
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
        mapView.setCenterCoordinate(coordinate, animated: true)
    }
}
