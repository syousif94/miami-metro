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
    let ids: [String]?
    let name: String
    let lines: [Line]
    
    var color: UIColor!
    var colors: [String:UIColor]!
    var stops: [String:Stop]!
    
    init(_ json: JSON) {
        let type = json["type"].stringValue
        let kind = Kind.init(rawValue: type)!
        self.kind = kind
        
        let name = json["name"].stringValue
        self.name = name
        
        var id: String!
        switch self.kind {
        case .gables, .mover, .rail:
            let colors: [String:UIColor] = json["colors"].dictionaryValue.mapValues { UIColor($0.stringValue) }
            self.color = colors.reversed().first?.value
            self.colors = colors
            self.lines = json["poly"].dictionaryValue.map { key, json -> Line in
                let color = colors[key]!
                return Line.create(encodedPolyline: json.stringValue, color: color)
            }
            id = type
            self.id = id
            self.ids = json["ids"].arrayValue.map { $0.stringValue }
        case .trolley:
            self.color = UIColor(json["color"].stringValue)
            let line = Line.create(encodedPolyline: json["poly"].stringValue, color: self.color)
            self.lines = [line]
            id = json["id"].stringValue
            self.id = id
            self.ids = nil
        }
        
        self.stops = json["stops"].arrayValue.reduce([:]) { previous, json in
            let stop = Stop(json, color: color, kind: kind, route: id)
            var next = previous
            next![stop.id] = stop
            return next
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

