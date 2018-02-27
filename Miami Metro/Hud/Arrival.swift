//
//  Arrival.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/25/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import Firebase

struct Arrival {
    let date: Date
    let kind: Route.Kind
    let vehicle: String
    let route: String
    let station: String
    
    init?(_ snapshot: DataSnapshot) {
        let dict = snapshot.value as! NSDictionary
        
        guard let timestamp = dict["timestamp"] as? Double,
            let kind = dict["kind"] as? String,
            let route = dict["route"] as? String,
            let station = dict["station"] as? String,
            let vehicle = dict["vehicle"] as? String else { return nil }
        
        self.date = Date(timeIntervalSince1970: timestamp / 1000)
        self.kind = Route.Kind(rawValue: kind)!
        self.route = route
        self.station = station
        self.vehicle = vehicle
    }
}
