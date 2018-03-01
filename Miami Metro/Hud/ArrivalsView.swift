//
//  ArrivalView.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/26/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import FlexLayout
import RxSwift

class ArrivalsView: UIView {
    
    let arrivals: [String: [Arrival]]
    
    var etas: [UILabel] = []
    
    let bag = DisposeBag()
    
    init(_ arrivals: [String: [Arrival]]) {
        self.arrivals = arrivals
        super.init(frame: .zero)
        
        self.flex.direction(.row).define { flex in
            guard let kind = HudModel.shared.selectedStop.value?.kind else { return }
            switch kind {
            case .rail:
                layoutRail()
            default:
                break
            }
        }
    }
    
    func layoutRail() {
        let ids = [("NB", "Northbound"), ("SB", "Southbound")]
        for id in ids {
            if let value = arrivals[id.0] {
                flex.addItem()
                    .direction(.column)
                    .marginTop(10)
                    .marginBottom(12)
                    .justifyContent(.spaceBetween)
                    .grow(1)
                    .define { flex in
                        
                        let label = UILabel()
                        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
                        label.text = id.1
                        label.sizeToFit()
                        
                        flex.addItem(label)
                        
                        value.enumerated().forEach { index, arrival in
                           
                            flex.addItem()
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
                                    
                                    flex.addItem(etaLabel).marginRight(20).grow(1)
                                    
                                    etas.append(etaLabel)
                            }
                        }
                }
            }
        }
        
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] time in
            var index = 0
            for id in ids {
                if let value = self.arrivals[id.0] {
                    for arrival in value {
                        let label = self.etas[index]
                        label.text = self.createETA(from: arrival.date)
                        label.sizeToFit()
                        index += 1
                    }
                }
            }
            self.flex.layout()
        }).disposed(by: bag)
    }
    
    func createETA(from date: Date) -> String {
        let eta = date.timeIntervalSinceNow
        
        let etaMinutes = Int(floor(eta / 60))
        let etaSeconds = abs(Int(eta) % 60)
        
        var seconds: String!
        if etaSeconds < 10 {
            seconds = "0\(etaSeconds)"
        }
        else {
            seconds = "\(etaSeconds)"
        }
        
        return "\(etaMinutes):\(seconds!)"
    }
    
    func createTime(from date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        let minutes = Calendar.current.component(.minute, from: date)
        
        var time = ""
        
        var meridian = "am"
        
        if hour == 0 {
            time += "12:"
        }
        else if hour >= 12 {
            meridian = "pm"
            
            if hour == 12 {
                time += "\(hour):"
            }
            else {
                time += "\(hour - 12):"
            }
        }
        
        if minutes < 10 {
            time += "0\(minutes)"
        }
        else {
            time += "\(minutes)"
        }
        
        time += " \(meridian)"
        
        return time
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
