//
//  ToastCenter.swift
//  EJToast
//
//  Created by eunji chung on 2020/02/03.
//

import UIKit

open class ToastCenter {
    
    // MARK: Properties
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    open var currentToast: Toast? {
        return self.queue.operations.first { (operation) -> Bool in
            return !operation.isCancelled && !operation.isFinished
        } as? Toast
    }
    
    public static let `default` = ToastCenter()
    
    // MARK: Initializing
    
    init() {
        #if swift(>=4.2)
        let name = UIDevice.orientationDidChangeNotification
        #else
        let name = NSNotification.Name.UIDeviceOrientationDidChange
        #endif
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: name, object: nil)
    }
    
    // MARK: Adding Toasts
    open func add(_ toast: Toast) {
        queue.addOperation(toast)
    }
    
    // MARK: Cancelling Toasts
    open func cancellAll() {
        queue.cancelAllOperations()
    }
    
    // MARK: Notifications
    @objc dynamic func deviceOrientationDidChange() {
        if let lastToast = queue.operations.first as? Toast {
            lastToast.view.setNeedsLayout()
        }
    }
}
