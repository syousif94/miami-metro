//
//  HudModel.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/18/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import RxSwift

class HudModel: NSObject {
    static let shared = HudModel()
    let bag = DisposeBag()

    let selectedStop = Variable<Stop?>(nil)
    
    override init() {
        super.init()
    }
    
    static func select(stop: Stop) {
        shared.selectedStop.value = stop
    }
    
    static func deselect() {
        shared.selectedStop.value = nil
    }
}
