//
//  Stop.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/17/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import MapKit

class Stop: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    let id: String
    let color: UIColor
    let kind: Route.Kind
    let route: String?
    
    init(_ coordinate: CLLocationCoordinate2D, id: String, color: UIColor, kind: Route.Kind, route: String? = nil) {
        self.coordinate = coordinate
        self.id = id
        self.color = color
        self.kind = kind
        self.route = route
    }
}

class StopAnnotation: MKAnnotationView {
    
    static let minDelta: CGFloat = 0.005
    static let maxDelta: CGFloat = 0.04
    static let delta: CGFloat = maxDelta - minDelta
    
    static let minDiameter: CGFloat = 6
    static let maxDiameter: CGFloat = 40
    static let span: CGFloat = maxDiameter - minDiameter
    
    static let minSize = CGSize(width: minDiameter, height: minDiameter)
    static let maxSize = CGSize(width: maxDiameter, height: maxDiameter)
    
    static func size(for mapView: MKMapView, initial: Bool = false) -> CGSize? {
        let delta = CGFloat(mapView.region.span.longitudeDelta)
        let small = delta > maxDelta
        let big = delta < minDelta
        if small || big {
            if initial {
                return small ? minSize : maxSize
            }
            return nil
        }
        let diameter: CGFloat = minDiameter + (span * (maxDelta - delta) / StopAnnotation.delta)
        return CGSize(width: diameter, height: diameter)
    }
    
    static func resize(for mapView: MKMapView) {
        guard let size = size(for: mapView) else { return }
        let diameter = size.height
        let radius = diameter / 2
        
        let firstAnnotation = mapView.annotations.first { annotation -> Bool in
            return mapView.view(for: annotation) is StopAnnotation
        }
        if firstAnnotation == nil { return }
        if mapView.view(for: firstAnnotation!)!.frame.size.height == diameter { return }
        let stops = mapView.annotations.map { mapView.view(for: $0) }
        for view in stops {
            if let view = view as? StopAnnotation {
                view.frame.size = size
                view.layer.cornerRadius = radius
            }
        }
    }
    
    static func size(_ annotation: StopAnnotation, for mapView: MKMapView) {
        guard let size = size(for: mapView, initial: true) else { return }
        let diameter = size.height
        let radius = diameter / 2
        
        annotation.frame.size = size
        annotation.layer.cornerRadius = radius
        annotation.bounds = annotation.frame
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let annotation = annotation as? Stop else { return }
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = annotation.color.cgColor
        self.isOpaque = false
        self.layer.zPosition = 0.1
        self.centerOffset = CGPoint(x: 0, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
