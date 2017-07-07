import UIKit

public class Router {
    
//    fileprivate static var connectorMap: [String: String] = {
//        guard let path = Bundle.main.path(forResource: "URLRouter", ofType: "plist") else {
//            print("URLRouter.plist is not exist")
//            return [:]
//        }
//        let routeDict = NSDictionary(contentsOfFile: path)!
//        return routeDict as! [String : String]
//    }()
    
//    public static func register(_ URLString: String, connector: String) {
//        guard (NSClassFromString(connector) as? RouterConnectorPrt.Type) != nil else {
//            assert(false, connector + " is not RouteConnectorPrt")
//            return
//        }
//        connectorMap[URLString] = connector
//    }
    
    /// 根据URL和参数打开视图控制器
    public static func open(_ URLString: String, params: [String: Any]? = nil) {
        let scheme = getURLScheme(URLString)
        guard scheme.characters.count > 0 else {
            openLocal(URLString, params: params)
            return
        }

        switch confirm(scheme: scheme) {
        case .local:
            openLocal(URLString, params: params)
        case .remote:
            openRemote(URLString, params: params)
        case .web:
            openWeb(URLString, params: params)
        }
    }

    /// 根据URL和参数获取视图控制器
    public static func controller(_ URLString: String, params: [String: Any]? = nil) ->
            UIViewController {
        return localController(URLString, params: params)
    }

    /// 是否可以打开视图控制器
    public static func canOpen(_ URLString: String) -> Bool {
        let scheme = getURLScheme(URLString)

        switch confirm(scheme: scheme) {
        case .local:
            if ((controller(URLString) as? RouterTipController) != nil) {
                return false
            }
            return true
        case .remote:
            return UIApplication.shared.canOpenURL(URL(string: URLString)!)
        case .web:
            return true
        }
    }

    /// 远程调用时验证签名正确性
    public static func isRightSign(_ URLString: String) -> Bool {
        return true
    }

}

extension Router {

    fileprivate enum openType {
        case local, remote, web
    }

    fileprivate static func confirm(scheme: String) -> openType {
        if scheme == "http" || scheme == "https" {
            return .web
        }
        if Router.myURLSchemes().contains(scheme) {
            return .local
        }
        return .remote
    }

    private static func myURLSchemes() -> Array<String> {
        var schemes = Array<String>()

        let infoDict = Bundle.main.infoDictionary!

        guard let urlType = infoDict["CFBundleURLTypes"] else {
            return schemes
        }

        for item in urlType as! Array<Dictionary<String, Any>> {
            for urlScheme in item["CFBundleURLSchemes"] as! Array<String> {
                schemes.append(urlScheme)
            }
        }

        return schemes
    }

    fileprivate static func localController(_ URLString: String, params: [String: Any]?) ->
            UIViewController {
                
        let scheme = getURLScheme(URLString)
        let urlStr = getURLPath(URLString)
        let options = getURLParams(URLString, params: params)

        guard scheme.characters.count > 0 else {
            return RouterTipController.schemeNilTip(urlStr, params: options)
        }
        guard confirm(scheme: scheme) == openType.local else {
            return RouterTipController.schemeIsNotLocalTip(urlStr, params: options)
        }
        guard let url = URL(string: urlStr), let host = url.host else {
            return RouterTipController.URLErrorTip(urlStr, params: options)
        }
        let path = url.path.replacingOccurrences(of: "/", with: "")
        let className = "\(host).\(path)"
        guard let classTpye = NSClassFromString(className) as? RouterConnectorPrt.Type else {
            return RouterTipController.connectErrorTip(urlStr, params: options)
        }
        return classTpye.connect(url: url, params: options)
    }

    fileprivate static func openLocal(_ URLString: String, params: [String: Any]?) {

        let vc = localController(URLString, params: params)
        guard let currentNav = UIApplication.shared.currentController!.navigationController else {
            UIApplication.shared.currentController!.present(vc, animated: true)
            return
        }
        currentNav.pushViewController(vc, animated: true)

    }

    fileprivate static func openRemote(_ URLString: String, params: [String: Any]?) {
        if !canOpen(URLString) {
            return
        }
        
        let url = URL(string: getURLPath(URLString))!
        let options = getURLParams(URLString, params: params)
       
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: options)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    fileprivate static func openWeb(_ URLString: String, params: [String: Any]?) {

    }

    fileprivate static func getURLScheme(_ URLString: String) -> String {
        guard let range = URLString.range(of: "://") else {
            return ""
        }
        return URLString.substring(to: range.lowerBound)
    }

    private static func getURLPath(_ URLString: String) -> String {
        guard let range = URLString.range(of: "?") else {
            return URLString
        }
        return URLString.substring(to: range.lowerBound)
    }

    private static func getURLParams(_ URLString: String, params: [String: Any]?) -> [String: Any] {
        var paramsM = params

        if paramsM == nil {
            paramsM = Dictionary<String, Any>()
        }

        if let range = URLString.range(of: "?") {
            let subString = URLString.substring(from: range.upperBound)
            for str in subString.components(separatedBy: "&") {
                let strArray = str.components(separatedBy: "=")
                if strArray.count != 2 {
                    continue
                }
                paramsM![strArray[0]] = strArray[1]
            }
        }
        return paramsM!
    }

}

/**
 *  替换 viewWillAppear 方法
 */

extension UIViewController {
    open override static func initialize() {

        struct Static {
            static var token = NSUUID().uuidString
        }

        if self != UIViewController.self {
            return
        }

        DispatchQueue.once(token: Static.token) {
            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector = #selector(UIViewController.qc_viewWillAppear(animated:))

            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)

            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing

            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }

    func qc_viewWillAppear(animated: Bool) {
        self.qc_viewWillAppear(animated: animated)

        if Bundle.main == Bundle(for: self.classForCoder) {
            UIApplication.shared.currentController = self
        }
    }
}

/**
 *  DispatchQueue.once
 */

extension DispatchQueue {
    private static var onceTracker = [String]()

    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }

        if onceTracker.contains(token) {
            return
        }

        onceTracker.append(token)
        block()
    }
}

/**
 *  给 UIApplication 添加 currentController 属性
 */
private var currentControllerKey: UInt8 = 0

public extension UIApplication {

    public var currentController: UIViewController? {
        get {
            return associatedObject(base: self, key: &currentControllerKey) {
                return nil
            }
        }
        set {
            associateObject(base: self, key: &currentControllerKey, value: newValue!)
        }
    }

}

public func associatedObject<ValueType:AnyObject>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        initialiser: () -> ValueType?)
                -> ValueType? {
    if let associated = objc_getAssociatedObject(base, key)
    as? ValueType {
        return associated
    }
    let associated = initialiser()
    objc_setAssociatedObject(base, key, associated,
            .OBJC_ASSOCIATION_RETAIN)
    return associated
}

public func associateObject<ValueType:AnyObject>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        value: ValueType) {
    objc_setAssociatedObject(base, key, value,
            .OBJC_ASSOCIATION_RETAIN)
}

/**
 *  RouteConnectorPrt 协议
 */
public protocol RouterConnectorPrt {
    static func connect(url: URL, params: [String: Any]) -> UIViewController
}

/**
 *  String 命名空间扩展
 */

public extension String {

    /// 获取当前的命名空间
    public static func nameSpace() -> String {
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        return nameSpace
    }

    /// 在当前类名前加上命名空间
    public func includeNameSpace() -> String {
        return String.nameSpace() + "." + self
    }

    /// 删除类名前的命名空间
    public func removeNameSpace() -> String {
        var className = self
        className.removeSubrange(self.range(of: String.nameSpace() + ".")!)
        return className
    }

}
