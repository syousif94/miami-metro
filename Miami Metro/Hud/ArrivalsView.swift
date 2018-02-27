//
//  ArrivalView.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/26/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit

class ArrivalsView: UIView {
    
    init(_ arrivals: [String: [Arrival]]) {
        super.init(frame: .zero)
        
        arrivals.forEach { key, value in
            let view = UIView()
            
            value.enumerated().forEach { index, arrival in
                let hour = Calendar.current.component(.hour, from: arrival.date)
                let minutes = Calendar.current.component(.minutes, from: arrival.date)
                
                let label = UILabel()
                label.text = "\(hours):\(minutes)"
                label.sizeToFit()
                
                view.addSubview(label)
                
                if index == 0 {
                    label.pin.top().left().height(label.font.lineHeight)
                }
                else {
                    label.pin.top(to: <#T##VerticalEdge#>)
                }
            }
            
            addSubview(view)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
