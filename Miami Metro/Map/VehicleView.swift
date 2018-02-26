//
//  VehicleView.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/21/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class VehicleView: MKAnnotationView {
    
    static let minDelta: CGFloat = 0.005
    static let maxDelta: CGFloat = 0.04
    static let delta: CGFloat = maxDelta - minDelta
    
    static let minDiameter: CGFloat = 18
    static let maxDiameter: CGFloat = 25
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
            return mapView.view(for: annotation) is VehicleView
        }
        if firstAnnotation == nil { return }
        if mapView.view(for: firstAnnotation!)!.frame.size.height == diameter { return }
        let stops = mapView.annotations.map { mapView.view(for: $0) }
        for view in stops {
            if let view = view as? VehicleView {
                view.frame.size = size
                view.layer.cornerRadius = radius
                view.directionLabel.pin.center()
            }
        }
    }
    
    static func size(_ view: VehicleView, for mapView: MKMapView) {
        guard let size = size(for: mapView, initial: true) else { return }
        let diameter = size.height
        let radius = diameter / 2
        
        view.frame.size = size
        view.layer.cornerRadius = radius
        view.bounds = view.frame
        
        view.directionLabel.pin.width(view.directionLabel.frame.width).height(view.directionLabel.font.lineHeight).center()
    }
    
    lazy var vehicle: Vehicle = {
        return self.annotation as! Vehicle
    }()
    
    let directionLabel = UILabel()
    
    func configureDirectionLabel() {
        addSubview(directionLabel)
        
        directionLabel.font = UIFont.systemFont(ofSize: 6, weight: UIFont.Weight.semibold)
        
        directionLabel.text = vehicle.direction
        
        directionLabel.sizeToFit()
        
        directionLabel.textColor = UIColor.white
    }
    
    func configureView() {
        self.configureDirectionLabel()
        
        switch vehicle.kind {
        case .rail, .mover:
            if let route = MapData.routes[vehicle.kind.rawValue],
                let color = route.colors[vehicle.route] {
                self.backgroundColor = color
            }
        default:
            self.backgroundColor = UIColor.lightGray
        }
        
        self.isOpaque = false
        self.layer.zPosition = 3
        //        self.layer.borderWidth = 1
        //        self.layer.borderColor = UIColor.white.cgColor
        self.centerOffset = CGPoint(x: 0, y: 0)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        guard let _ = annotation as? Vehicle else { return }
        
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
