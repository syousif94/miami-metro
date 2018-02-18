//
//  MapData.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/17/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import UIColor_Hex_Swift

class MapData: NSObject {
    static let shared = MapData()
    
    let routes: [String:Route]
    
    override init() {
        self.routes = MapData.loadRoutes()
        
        super.init()
    }
    
    static func loadRoutes() -> [String:Route] {
        guard let path = Bundle.main.path(forResource: "map", ofType: "json") else {
            return [:]
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            var routes: [String:Route] = [:]
            try JSON(data: data).arrayValue.forEach { json in
                let route = Route(json)
                routes[route.id] = route
            }
            return routes
        } catch let error {
            print(error.localizedDescription)
            return [:]
        }
    }
}

struct Route {
    let kind: Route.Kind
    let id: String
    let lines: [Line]
    let color: UIColor
    var stops: [Stop]!
    
    init(_ json: JSON) {
        let type = json["type"].stringValue
        let kind = Kind.init(rawValue: type)!
        self.kind = kind
        
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
            let lat = json["lat"].doubleValue
            let lng = json["lng"].doubleValue
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            if kind == .trolley {
                let route = id
                return Stop(coordinate, id: json["id"].stringValue, color: color, kind: kind, route: route)
            }
            else {
                return Stop(coordinate, id: json["id"].stringValue, color: color, kind: kind)
            }
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
