//
//  StopView.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/21/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import PinLayout

class StopView: MKAnnotationView {
    
    static let minDelta: CGFloat = 0.018
    static let maxDelta: CGFloat = 0.04
    static let delta: CGFloat = maxDelta - minDelta
    
    static let minDiameter: CGFloat = 12
    static let maxDiameter: CGFloat = 22
    static let span: CGFloat = maxDiameter - minDiameter
    
    static let minBorder: CGFloat = 1
    static let maxBorder: CGFloat = 2
    static let borderSpan = maxBorder - minBorder
    
    static let minSize = CGSize(width: minDiameter, height: minDiameter)
    static let maxSize = CGSize(width: maxDiameter, height: maxDiameter)
    
    static func size(for mapView: MKMapView, initial: Bool = false) -> (CGSize, CGFloat)? {
        let delta = CGFloat(mapView.region.span.longitudeDelta)
        let small = delta > maxDelta
        let big = delta < minDelta
        if small || big {
            if initial {
                return small ? (minSize, minBorder) : (maxSize, maxBorder)
            }
            return nil
        }
        let percentSize = (maxDelta - delta) / StopView.delta
        let diameter: CGFloat = minDiameter + (span * percentSize)
        let border = minBorder + (borderSpan * percentSize)
        return (CGSize(width: diameter, height: diameter), border)
    }
    
    static func resize(for mapView: MKMapView) {
        guard let (size, border) = size(for: mapView) else { return }
        let diameter = size.height
        let radius = diameter / 3
        
        let firstAnnotation = mapView.annotations.first { annotation -> Bool in
            return mapView.view(for: annotation) is StopView
        }
        if firstAnnotation == nil { return }
        if mapView.view(for: firstAnnotation!)!.frame.size.height == diameter { return }
        let stops = mapView.annotations.map { mapView.view(for: $0) }
        for view in stops {
            if let view = view as? StopView {
                view.layer.borderWidth = border
                view.frame.size = size
                view.layer.cornerRadius = radius
                view.idLabel.pin.center()
            }
        }
    }
    
    static func size(_ view: StopView, for mapView: MKMapView) {
        guard let (size, border) = size(for: mapView, initial: true) else { return }
        let diameter = size.height
        let radius = diameter / 3
        
        view.frame.size = size
        view.layer.borderWidth = border
        view.layer.cornerRadius = radius
        view.bounds = view.frame
        
        view.idLabel.pin.size(view.idLabel.frame.size).center()
    }
    
    lazy var stop: Stop = {
        return self.annotation as! Stop
    }()
    
    let idLabel = UILabel()
    
    func configureIdLabel() {
        addSubview(idLabel)
        
        idLabel.font = UIFont.systemFont(ofSize: 6, weight: UIFont.Weight.semibold)
        
        switch stop.kind {
        case .mover, .rail:
            idLabel.text = stop.id
        case .trolley:
            if let number = stop.number {
                idLabel.text = "\(number)"
            }
        default:
            break
        }
        idLabel.sizeToFit()
        
        idLabel.textColor = UIColor.black
    }
    
    func configureViews() {
        self.configureIdLabel()
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
