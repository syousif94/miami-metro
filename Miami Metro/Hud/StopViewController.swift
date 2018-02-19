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
        routeLabel.pin.top(12).left(18).height(routeLabel.font.lineHeight)
        
        stopLabel.pin.topLeft(to: routeLabel.anchor.bottomLeft).marginTop(5)
    }
    
    func refresh(stop: Stop?) {
        
        guard let stop = stop,
            let id = stop.route,
            let route = MapData.routes[id]
            else { return }
        
        routeLabel.text = route.name
        routeLabel.sizeToFit()
        
        stopLabel.text = stop.name
        stopLabel.sizeToFit()
        
        self.view.layoutIfNeeded()
    }
}

