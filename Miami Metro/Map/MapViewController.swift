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
import RxSwift

protocol AnnotationDelegate: class {
    var mapView: MKMapView { get }
}

class MapViewController: UIViewController, AnnotationDelegate {
    let mapView = MKMapView()
    var displayLink: CADisplayLink?
    
    let bag = DisposeBag()
    let stopViewController = StopViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addControllers()
        addViews()
        setupViews()
        
        MapData.shared.delegate = self
    }
    
    func addControllers() {
        addChildViewController(stopViewController)
    }
    
    func addViews() {
        view.addSubview(mapView)
        view.addSubview(stopViewController.view)
    }
    
    func setupViews() {
        mapView.pin.all()
        mapView.delegate = self
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.showsUserLocation = true
        
        let top = UIScreen.insets.top + 5
        
        let translateY = -(top + StopViewController.height)
        
        stopViewController.view.pin.horizontally(15).top(top).height(StopViewController.height)
        stopViewController.view.transform = CGAffineTransform(translationX: 0, y: translateY)
        
        HudModel.shared.selectedStop.asObservable()
            .scan((nil, nil)) { stops, stop -> (Stop?, Stop?) in
                return (stops.1, stop)
            }
            .subscribe(onNext: { stops in
                let last = stops.0
                let current = stops.1
                
                if last == current { return }
                
                self.stopViewController.refresh(stop: current)
                
                let show = last == nil && current != nil
                let hide = last != nil && current == nil
                
                if show || hide {
                    let y: CGFloat = show ? 0 : translateY
                    UIView.animate(withDuration: 0.2) { [unowned self] in
                        self.stopViewController.view.transform = CGAffineTransform(translationX: 0, y: y)
                    }
                }
                
            }).disposed(by: bag)
        
        let center = CLLocationCoordinate2D(latitude: 25.769281912440562, longitude: -80.218781669048795)
        let span = MKCoordinateSpan(latitudeDelta: 0.10407172945630805, longitudeDelta: 0.059041752313689244)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        
        for (_, route)  in MapData.shared.routes {
            for line in route.lines {
                mapView.add(line)
            }
            
            route.stops.values.forEach { mapView.addAnnotation($0) }
        }
    }
    
    @objc func updateRegion() {
        StopView.resize(for: mapView)
        VehicleView.resize(for: mapView)
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
            mapView.userLocation.title = nil
        }

        if annotation is Stop {
            let view = StopView(annotation: annotation, reuseIdentifier: "stop")
            StopView.size(view, for: mapView)
            view.layoutIfNeeded()
            return view
        }
        
        if annotation is Vehicle {
            let view = VehicleView(annotation: annotation, reuseIdentifier: "vehicle")
            VehicleView.size(view, for: mapView)
            view.layoutIfNeeded()
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        displayLink = CADisplayLink(target: self, selector: #selector(updateRegion))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        displayLink?.invalidate()
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            view.setSelected(false, animated: false)
        }
        
        if let view = view as? StopView {
            view.backgroundColor = view.stop.color
            view.idLabel.textColor = UIColor.white
            HudModel.select(stop: view.stop)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let view = view as? StopView {
            view.idLabel.textColor = UIColor.black
            view.backgroundColor = UIColor.white
            HudModel.deselect()
        }
    }
}
