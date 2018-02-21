//
//  Vehicle.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/19/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class Vehicle: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    let id: String
    let kind: Route.Kind
    let route: String
    let direction: String?;
    let bearing: String?;
    
    var arrival: String!
    
    var key: String {
        get {
            return "\(kind)\(id)"
        }
    }
    
    weak var delegate: AnnotationDelegate?
    
    init(_ json: JSON) {
        self.kind = Route.Kind(rawValue: json["kind"].stringValue)!
        let lat = json["lat"].doubleValue
        let lng = json["lng"].doubleValue
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.id = json["id"].stringValue
        self.route = json["route"].stringValue
        self.direction = json["direction"].string
        self.bearing = json["bearing"].string
    }
    
    func remove() {
        delegate?.mapView.removeAnnotation(self)
    }
    
    func update(_ json: JSON) {
        updatePosition(json)
    }
    
    func updateArrival(_ json: JSON) {
        
    }
    
    func updatePosition(_ json: JSON) {
        let lat = json["lat"].doubleValue
        let lng = json["lng"].doubleValue
        let next = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 8) { [unowned self] in
                self.coordinate = next
            }
        }
        
    }
}

