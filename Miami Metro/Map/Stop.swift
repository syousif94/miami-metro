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
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let annotation = annotation as? Stop else { return }
        
        self.frame.size = CGSize(width: 6, height: 6)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
        self.layer.borderColor = annotation.color.cgColor
        self.bounds = self.frame
        self.isOpaque = false
        self.layer.zPosition = 0.1
        self.centerOffset = CGPoint(x: 0, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
