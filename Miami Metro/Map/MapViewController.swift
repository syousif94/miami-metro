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
    var displayLink: CADisplayLink?
    
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
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        
        let center = CLLocationCoordinate2D(latitude: 25.769281912440562, longitude: -80.218781669048795)
        let span = MKCoordinateSpan(latitudeDelta: 0.10407172945630805, longitudeDelta: 0.059041752313689244)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        
        for (_, route)  in MapData.shared.routes {
            for line in route.lines {
                mapView.add(line)
            }
            
            mapView.addAnnotations(route.stops)
        }
    }
    
    @objc func update() {
        let delta = CGFloat(mapView.region.span.longitudeDelta)
        if delta > 0.04 || delta < 0.01 {
            return
        }
        let diameter: CGFloat = 6 + (15 * (0.04 - delta) / 0.03)
        let radius: CGFloat = diameter / 2
        
        let firstAnnotation = mapView.annotations.first { annotation -> Bool in
            return mapView.view(for: annotation) is StopAnnotation
        }
        if firstAnnotation == nil { return }
        if mapView.view(for: firstAnnotation!)!.frame.size.height == diameter { return }
        let stops = mapView.annotations.map { mapView.view(for: $0) }
        for view in stops {
            if let view = view as? StopAnnotation {
                view.frame.size = CGSize(width: diameter, height: diameter)
                view.layer.cornerRadius = radius
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        return StopAnnotation(annotation: annotation, reuseIdentifier: "stop")
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        displayLink?.invalidate()
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? Stop else { return }
        view.backgroundColor = annotation.color
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let _ = view.annotation as? Stop else { return }
        view.backgroundColor = UIColor.white
    }
}
