//
//  ViewController.swift
//  Pods
//
//  Created by qi chao on 2017/7/7.
//
//

import UIKit
import QCRouter

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.gray
    }

}

class VC: RouterConnectorPrt {
    static func connect(url: URL, params: [String : Any]) -> UIViewController {
        print(url.absoluteString + "\n" + params.description)
        return ViewController()
    }
}
