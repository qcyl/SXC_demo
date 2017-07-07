//
//  RouteTipController.swift
//  QCRoute
//
//  Created by qi chao on 2017/6/6.
//  Copyright © 2017年 qi chao. All rights reserved.
//

import UIKit

class RouterTipController: UIViewController {

    fileprivate enum RouterTipType: String {
        case `default` = ""
        case schemeNil = "scheme为空"
        case schemeIsNotLocal = "scheme不是本地的"
        case URLError = "URL格式错误（scheme://namespace/classname）"
        case connectError = "connect没有遵守协议"
    }
    
    fileprivate var type: RouterTipType = RouterTipType.default
    fileprivate var URLString: String?
    fileprivate var params: [String: Any]?
    
    lazy var valueL: UILabel = {
        let  valueL: UILabel = UILabel(frame: CGRect(x: 10, y: 50, width:self.view.frame.size.width-20, height: self.view.frame.size.height-100))
        valueL.textColor = UIColor.white
        valueL.font = UIFont.systemFont(ofSize: 16)
        valueL.backgroundColor = UIColor.clear
        self.view.addSubview(valueL)
        return valueL
    }()
    lazy var returnBtn: UIButton = {
        let returnBtn: UIButton = UIButton(type: .custom)
        returnBtn.frame = CGRect(x: (self.view.frame.size.width-100)/2, y: self.view.frame.size.height-75, width: 100, height: 50)
        returnBtn.layer.cornerRadius = 4
        returnBtn.backgroundColor = UIColor.gray
        returnBtn.setTitle("返回", for: .normal)
        returnBtn.setTitleColor(UIColor.black, for: .normal)
        returnBtn.addTarget(self, action: #selector(RouterTipController.returnClick), for: .touchUpInside)
        return returnBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        view.addSubview(returnBtn)
        
        let showText = "open url error: \(self.type.rawValue)\n\nURL: \n\t\(String(describing: self.URLString))\n\nparams:\n\t\(String(describing: self.params))"
        
        valueL.numberOfLines = showText.components(separatedBy: "\n").count + 1
        valueL.text = showText
    }
    
    func returnClick() {
        if (self.navigationController == nil) {
            dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

}

extension RouterTipController {
    static public func schemeNilTip(_ URLString: String, params: [String: Any]?) -> UIViewController {
        let vc = RouterTipController()
        vc.type = RouterTipType.schemeNil
        vc.URLString = URLString
        vc.params = params!
        return vc
    }
    
    static public func schemeIsNotLocalTip(_ URLString: String, params: [String: Any]?) -> UIViewController {
        let vc = RouterTipController()
        vc.type = RouterTipType.schemeIsNotLocal
        vc.URLString = URLString
        vc.params = params
        return vc
    }
    
    static public func URLErrorTip(_ URLString: String, params: [String: Any]?) -> UIViewController {
        let vc = RouterTipController()
        vc.type = RouterTipType.URLError
        vc.URLString = URLString
        vc.params = params
        return vc
    }
    
    static public func connectErrorTip(_ URLString: String, params: [String: Any]?) -> UIViewController {
        let vc = RouterTipController()
        vc.type = RouterTipType.connectError
        vc.URLString = URLString
        vc.params = params
        return vc
    }
}
