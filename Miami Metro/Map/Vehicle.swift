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
import Firebase

class Vehicle: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    let id: String
    let kind: Route.Kind
    let route: String
    let direction: String?;
//    let bearing: String?;
    
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
//        self.bearing = json["bearing"].string
    }
    
    init(_ snapshot: DataSnapshot) {
        let dict = snapshot.value as! NSDictionary
        
        let kind = dict["kind"] as! String
        self.kind = Route.Kind(rawValue: kind)!
        
        let lat = dict["lat"] as! Double
        let lng = dict["lng"] as! Double
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        self.id = dict["id"] as! String
        
        self.route = dict["route"] as! String
        self.direction = dict["direction"] as? String
    }
    
    func remove() {
        delegate?.mapView.removeAnnotation(self)
    }
    
    func update(_ vehicle: Vehicle) {
        updatePosition(vehicle)
    }
    
    func updateArrival(_ json: JSON) {
        
    }
    
    func updatePosition(_ vehicle: Vehicle) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 8) { [unowned self] in
                self.coordinate = vehicle.coordinate
            }
        }
        
    }
}

