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
import RxSwift
import RxCocoa
import PromiseKit
import CoreLocation
import Firebase

class MapData: NSObject {
    static let shared = MapData()
    
    static var routes: [String: Route] {
        return shared.routes
    }
    
    let bag = DisposeBag()
    
    let routes: [String:Route]
    
    let refreshingPositions = Variable<Bool>(false)
    var positions: [String:Vehicle] = [:]
    
    weak var delegate: AnnotationDelegate? {
        didSet {
            refreshingPositions.value = true
            CLLocationManager
                .promise(.whenInUse)
                .then { location -> Void in }
                .catch { print($0.localizedDescription) }
        }
    }
    
    override init() {
        self.routes = MapData.loadRoutes()
        
        super.init()
        
        let ref = Database.database().reference()
        
        ref.child("positions").observe(.value) { snapshot in
            
            var next: [String: Vehicle] = [:]
            
            let rail = snapshot.childSnapshot(forPath: "rail")
            
            rail.children.forEach { child in
                let child = child as! DataSnapshot
                
                let vehicle = Vehicle(child)
                
                let key = vehicle.key
                if let previous = self.positions.removeValue(forKey: key) {
                    previous.update(vehicle)
                    next[key] = previous
                }
                else {
                    vehicle.delegate = self.delegate
                    DispatchQueue.main.async {
                        vehicle.delegate?.mapView.addAnnotation(vehicle)
                    }
                    next[vehicle.key] = vehicle
                }
            }
            
            let mover = snapshot.childSnapshot(forPath: "mover")
            
            mover.children.forEach { child in
                let child = child as! DataSnapshot
                
                let vehicle = Vehicle(child)
                
                let key = vehicle.key
                if let previous = self.positions.removeValue(forKey: key) {
                    previous.update(vehicle)
                    next[key] = previous
                }
                else {
                    vehicle.delegate = self.delegate
                    DispatchQueue.main.async {
                        vehicle.delegate?.mapView.addAnnotation(vehicle)
                    }
                    next[vehicle.key] = vehicle
                }
            }
            
            self.positions.forEach { key, vehicle in
                vehicle.remove()
            }
            
            self.positions = next
        }
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
