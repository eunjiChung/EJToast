//
//  ToastWindow.swift
//  EJToast
//
//  Created by eunji chung on 2020/02/03.
//

import UIKit

open class ToastWindow: UIWindow {
    public static let shared = ToastWindow(frame: UIScreen.main.bounds)
    
    /// Will not return 'rootViewController' while this value is 'true'.
    var isStatusBarOrientationChanging = false
    
    var shouldRotateManually: Bool {
        let iPad = UIDevice.current.userInterfaceIdiom == .pad
        let application = UIApplication.shared
        let window = application.delegate?.window ?? nil
        let supportsAllOrientations = application.supportedInterfaceOrientations(for: window) == .all
       
        let info = Bundle.main.infoDictionary
        let requiresFullScreen = (info?["UIRequiresFullScreen"] as? NSNumber)?.boolValue == true
        let hasLaunchStoryboard = info?["UILaunchStoryboardName"] != nil
        
        if #available(iOS 9, *), iPad && supportsAllOrientations && !requiresFullScreen && hasLaunchStoryboard {
            return false
        }
        
        return true
    }
    
    open override var rootViewController: UIViewController? {
        get {
            guard !self.isStatusBarOrientationChanging else { return nil }
            guard let firstWindow = UIApplication.shared.delegate?.window else { return nil }
            // `is` is type checking operator
            return firstWindow is ToastWindow ? nil : firstWindow?.rootViewController
        }
        set { /* Do nothing */ }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        #if swift(>=4.2)
        self.windowLevel = .init(rawValue: .greatestFiniteMagnitude)
        let didBecomeVisibleName = UIWindow.didBecomeVisibleNotification
        let willChangeStatusBarOrientationName = UIApplication.willChangeStatusBarOrientationNotification
        let didChangeStatusBarOrientationName = uiapplication
        #else
        self.windowLevel = .greatestFiniteMagnitude
        let didBecomeVisibleName = NSNotification.Name.UIWindowDidBecomeVisible
        #endif
        self.backgroundColor = .clear
        self.isHidden = false
        // handleRotate
        
        NotificationCenter.default.addObserver(self, selector: #selector(bringWindowToTop(_:)), name: didBecomeVisibleName, object: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented: please use ToastWindow.shared")
    }
    
    
    /// Bring ToastWindow to top when another window is being shown.
    @objc func bringWindowToTop(_ notification: Notification) {
        if !(notification.object is ToastWindow) {
            // why...?
            ToastWindow.shared.isHidden = true
            ToastWindow.shared.isHidden = false
        }
    }
}

