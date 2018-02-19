//
//  Route.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/19/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

struct Route {
    let kind: Route.Kind
    let id: String
    let name: String
    let lines: [Line]
    let color: UIColor
    var stops: [Stop]!
    
    init(_ json: JSON) {
        let type = json["type"].stringValue
        let kind = Kind.init(rawValue: type)!
        self.kind = kind
        
        let name = json["name"].stringValue
        self.name = name
        
        var id: String!
        switch self.kind {
        case .gables, .mover, .rail:
            let color = UIColor.black
            self.color = color
            let colors: [String:UIColor] = json["colors"].dictionaryValue.mapValues { UIColor($0.stringValue) }
            self.lines = json["poly"].dictionaryValue.map { key, json -> Line in
                let color = colors[key]!
                return Line.create(encodedPolyline: json.stringValue, color: color)
            }
            id = type
            self.id = id
        case .trolley:
            self.color = UIColor(json["color"].stringValue)
            let line = Line.create(encodedPolyline: json["poly"].stringValue, color: self.color)
            self.lines = [line]
            id = json["id"].stringValue
            self.id = id
        }
        
        self.stops = json["stops"].arrayValue.map { json -> Stop in
            let name = json["name"].stringValue
            let lat = json["lat"].doubleValue
            let lng = json["lng"].doubleValue
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            return Stop(coordinate, id: json["id"].stringValue, name: name, color: color, kind: kind, route: id)
        }
    }
}

extension Route {
    enum Kind: String {
        case trolley
        case gables
        case rail
        case mover
    }
}

