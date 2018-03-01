//
//  HudModel.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/18/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import RxCocoa
import Firebase

class HudModel: NSObject {
    static let shared = HudModel()
    let bag = DisposeBag()

    let selectedStop = Variable<Stop?>(nil)
    
    let arrivals = Variable<[String: [Arrival]]?>(nil)
    
    var ref: DatabaseReference?
    
    override init() {
        super.init()
        
        selectedStop.asObservable()
            .subscribe(onNext: { [unowned self] stop in
                if let ref = self.ref {
                    ref.removeAllObservers()
                    self.ref = nil
                }
                
                if let stop = stop,
                    stop.kind == .rail || stop.kind == .mover {
                    self.ref = Database.database().reference().child("/arrivals/\(stop.kind)/\(stop.id)")
                    self.ref?.observe(.value) { snapshot in
                        
                        let arrivals: [String: [Arrival]] = snapshot
                            .children
                            .reduce([:]) { result, direction in
                                let snapshot = direction as! DataSnapshot
                                
                                if snapshot.key == "id" { return result }
                                var next = result
                                
                                let arrivals: [Arrival] = snapshot
                                    .children
                                    .reduce([]) { result, arrival in
                                        guard let arrival = Arrival(arrival as! DataSnapshot) else { return result }
                                        var next = result
                                        next.append(arrival)
                                        return next
                                    }
                                next["\(snapshot.key)"] = arrivals.sorted { $0.date < $1.date}
                                return next
                        }
                        
                        self.arrivals.value = arrivals
                        
                    }
                }
            })
            .disposed(by: bag)
    }
    
    static func select(stop: Stop) {
        shared.selectedStop.value = stop
    }
    
    static func deselect() {
        shared.selectedStop.value = nil
    }
}
