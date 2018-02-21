//
//  Stop.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/17/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class Stop: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    let id: String
    let name: String
    let color: UIColor
    let kind: Route.Kind
    let route: String?
    var number: Int?
    
    init(_ json: JSON, color: UIColor, kind: Route.Kind, route: String? = nil) {
        
        let id = json["id"].stringValue
        let name = json["name"].stringValue
        let lat = json["lat"].doubleValue
        let lng = json["lng"].doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        self.coordinate = coordinate
        self.id = id
        self.name = name
        self.color = color
        self.kind = kind
        self.route = route
        self.number = json["index"].int
    }
}
