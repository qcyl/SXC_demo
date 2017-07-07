//
//  DemoController.swift
//  SXC
//
//  Created by qi chao on 2017/7/5.
//  Copyright © 2017年 qi chao. All rights reserved.
//

import UIKit
import QCRouter

class DemoController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Router.open(R("SSQ/VC?abe=123"))
    }

}
