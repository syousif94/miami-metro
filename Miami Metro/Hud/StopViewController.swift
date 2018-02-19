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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.white
    }
}

