//
//  ArrivalsView+Mover.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/28/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit

extension ArrivalsView {
    func setupMover() {
        if let route = MapData.routes[Route.Kind.mover.rawValue],
            let names = route.names,
            let ids: [(String, String)] = route.ids?.enumerated().map({ ($0.element, names[$0.offset]) }) {
            layoutMover(ids: ids)
        }
    }
    
    func layoutMover(ids: [(String, String)]) {
        self.flex.direction(.row).define { flex in
            for id in ids {
                if let value = arrivals[id.0] {
                    flex.addItem()
                        .direction(.column)
                        .marginTop(10)
                        .marginBottom(12)
                        .grow(1)
                        .define { flex in
                            
                            let label = UILabel()
                            label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
                            label.text = id.1
                            label.sizeToFit()
                            
                            flex.addItem(label)
                            
                            value.enumerated().forEach { index, arrival in
                                
                                flex.addItem()
                                    .marginTop(5)
                                    .direction(.row)
                                    .justifyContent(.spaceBetween)
                                    .define { flex in
                                        
                                        let label = UILabel()
                                        label.font = UIFont.systemFont(ofSize: 12)
                                        label.text = self.createTime(from: arrival.date)
                                        label.sizeToFit()
                                        
                                        flex.addItem(label)
                                        
                                        let etaLabel = UILabel()
                                        etaLabel.font = UIFont.systemFont(ofSize: 12)
                                        etaLabel.textColor = UIColor("#979797")
                                        etaLabel.text = createETA(from: arrival.date)
                                        etaLabel.sizeToFit()
                                        etaLabel.textAlignment = .right
                                        
                                        flex.addItem(etaLabel).marginRight(12).grow(1)
                                        
                                        etas.append(etaLabel)
                                }
                            }
                    }
                }
            }
        }
    }
}
