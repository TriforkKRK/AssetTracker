//
//  MKMapView+Asset.swift
//  AssetTracker
//
//  Created by Daniel Garbień on 24/08/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import MapKit


class Annotation: NSObject, MKAnnotation {
    
    @objc let coordinate: CLLocationCoordinate2D
    let color: UIColor
    
    init(coordinate: CLLocationCoordinate2D, color: UIColor) {
        self.coordinate = coordinate
        self.color = color
    }
}

extension MKMapView {
    
    private static let annotationIdentifier = "annotationView"
    
    func dequeueAnnotationViewWithAnnotation(annotation: Annotation) -> MKAnnotationView? {
        
        let view: MKAnnotationView
        if let dequeuedView = dequeueReusableAnnotationViewWithIdentifier(MKMapView.annotationIdentifier) {
            view = dequeuedView
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: MKMapView.annotationIdentifier)
        }
        
        view.image = "✤".imageWithFont(UIFont.systemFontOfSize(30), color: annotation.color)
        return view
    }
}
