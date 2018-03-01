//
//  StopViewController.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/18/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import RxSwift

class StopViewController: UIViewController {
    static let height: CGFloat = 140
    
    let bag = DisposeBag()
    
    let routeLabel = UILabel()
    let stopLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupViews()
    }
    
    func addViews() {
        view.addSubview(routeLabel)
        view.addSubview(stopLabel)
    }
    
    func setupViews() {
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.5
        
        setupLabels()
    }
    
    func setupLabels() {
        routeLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        routeLabel.textColor = UIColor("#979797")
        
        routeLabel.pin.top(12).left(18).height(routeLabel.font.lineHeight)
        
        stopLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        stopLabel.textColor = UIColor.black
        
        stopLabel.pin.topLeft(to: routeLabel.anchor.bottomLeft).height(stopLabel.font.lineHeight).marginTop(2)
    }
    
    var arrivalsView: ArrivalsView?
    
    func refresh(stop: Stop?) {
        
        guard let stop = stop,
            let id = stop.route,
            let route = MapData.routes[id]
            else {
                if let view = self.arrivalsView {
                    view.removeFromSuperview()
                }
                return
        }
        
        routeLabel.text = route.name
        routeLabel.sizeToFit()
        
        stopLabel.text = stop.name
        stopLabel.sizeToFit()
        
        self.view.layoutIfNeeded()
        
        HudModel.shared.arrivals.asObservable().subscribe(onNext: { [unowned self] arrivals in
            
            if let view = self.arrivalsView {
                view.removeFromSuperview()
            }
            
            if let arrivals = arrivals {
                self.arrivalsView = ArrivalsView(arrivals)
                
                self.view.addSubview(self.arrivalsView!)
                
                self.arrivalsView?.pin.topLeft(to: self.stopLabel.anchor.bottomLeft).bottomRight()
                
                self.arrivalsView?.flex.layout()
            }
            
        }).disposed(by: bag)
    }
}

