//
//  Line.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/17/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import MapKit
import Polyline

class Line: MKPolyline {
    var color: UIColor!
    
    static func create(encodedPolyline: String, color: UIColor) -> Line {
        let points = Polyline(encodedPolyline: encodedPolyline).coordinates!
        let pointer: UnsafePointer<CLLocationCoordinate2D> = UnsafePointer(points)
        let line = Line(coordinates: pointer, count: points.count)
        line.color = color
        return line
    }
}
