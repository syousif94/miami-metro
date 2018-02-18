//
//  MapViewController.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/17/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import MapKit
import PinLayout

class MapViewController: UIViewController {
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views()
        configure()
    }
    
    func views() {
        view.addSubview(mapView)
    }
    
    func configure() {
        mapView.pin.all()
        mapView.delegate = self
        
        for (_, route)  in MapData.shared.routes {
            for line in route.lines {
                mapView.add(line)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? Line {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 1
            renderer.strokeColor = overlay.color
            return renderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
}
