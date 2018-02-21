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

class HudModel: NSObject {
    static let shared = HudModel()
    let bag = DisposeBag()

    let selectedStop = Variable<Stop?>(nil)
    
    override init() {
        super.init()
        
        selectedStop.asObservable()
            .flatMapLatest { stop -> Observable<Stop> in
                return stop?.kind == .rail
                    ? Observable.merge(
                        Observable.of(stop!),
                        Observable<Int>.interval(1, scheduler: MainScheduler.instance).map { _ in stop! }
                    ) : .empty()
            }
            .flatMap { stop -> Observable<Data> in
                let base = "https://d0c45bdf.ngrok.io"
                let url = URL(string: "\(base)/arrivals/\(stop.kind.rawValue)/\(stop.id)")!
                let req = URLRequest(url: url)
                return URLSession.shared.rx.data(request: req)
            }
            .subscribe(onNext: { data in
                guard let json = try? JSON(data: data) else { return }
                print(json)
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
