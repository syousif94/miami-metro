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
    let name: String
    let color: UIColor
    let kind: Route.Kind
    let route: String?
    
    init(_ coordinate: CLLocationCoordinate2D, id: String, name: String, color: UIColor, kind: Route.Kind, route: String? = nil) {
        self.coordinate = coordinate
        self.id = id
        self.name = name
        self.color = color
        self.kind = kind
        self.route = route
    }
}

class StopView: MKAnnotationView {
    
    static let minDelta: CGFloat = 0.009
    static let maxDelta: CGFloat = 0.04
    static let delta: CGFloat = maxDelta - minDelta
    
    static let minDiameter: CGFloat = 6
    static let maxDiameter: CGFloat = 30
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
        let diameter: CGFloat = minDiameter + (span * (maxDelta - delta) / StopView.delta)
        return CGSize(width: diameter, height: diameter)
    }
    
    static func resize(for mapView: MKMapView) {
        guard let size = size(for: mapView) else { return }
        let diameter = size.height
        let radius = diameter / 2
        
        let firstAnnotation = mapView.annotations.first { annotation -> Bool in
            return mapView.view(for: annotation) is StopView
        }
        if firstAnnotation == nil { return }
        if mapView.view(for: firstAnnotation!)!.frame.size.height == diameter { return }
        let stops = mapView.annotations.map { mapView.view(for: $0) }
        for view in stops {
            if let view = view as? StopView {
                view.frame.size = size
                view.layer.cornerRadius = radius
                if diameter < 22 {
                    view.idLabel.isHidden = true
                }
                else {
                    view.idLabel.pin.center()
                    if view.idLabel.isHidden {
                        view.idLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    static func size(_ view: StopView, for mapView: MKMapView) {
        guard let size = size(for: mapView, initial: true) else { return }
        let diameter = size.height
        let radius = diameter / 2
        
        view.frame.size = size
        view.layer.cornerRadius = radius
        view.bounds = view.frame
        
        view.idLabel.isHidden = diameter < 22
        
        view.idLabel.pin.size(view.idLabel.frame.size).center()
    }
    
    lazy var stop: Stop = {
        return self.annotation as! Stop
    }()
    
    let idLabel = UILabel()
    
    // let arrivalLabel = UILabel()
    
    func configureIdLabel() {
        addSubview(idLabel)
        
        idLabel.font = UIFont.systemFont(ofSize: 8, weight: UIFont.Weight.semibold)
        
        idLabel.text = stop.kind == .trolley ? nil : stop.id
        idLabel.sizeToFit()
        
        idLabel.textColor = UIColor.black
    }
    
    func configureViews() {
        // shows number or id of stop
        self.configureIdLabel()
        
        // shows next arrival eta in seconds
        // addSubview(arrivalLabel)
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
        
        self.configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
