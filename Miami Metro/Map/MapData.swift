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
    
    static var routes: [String: Route] {
        return shared.routes
    }
    
    let routes: [String:Route]
    
    let positions: [Route.Kind:[String:Vehicle]]
    
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
