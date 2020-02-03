
import UIKit

// 얼마나 딜레이를 줄 지
public struct Delay {
    public static let short: TimeInterval = 2.0
    public static let long: TimeInterval = 3.5
}

/*
 접근 한정자 open
 프레임워크를 만들때 사용
 open은 가장 개방된 접근 한정자, class 및 class memeber에만 붙일 수 있다
 public은 Struct, Enum
 참조 : https://zeddios.tistory.com/383
 */
open class Toast: Operation {
    
    // MARK: - Properties
    public var view: UIView = UIView()
    
    /*
     프로퍼티에 get-set, didSet-willSet 사용가능
     get-set 사용하려면 반드시 값을 저장할 변수가 필요하다!
     */
    public var text: String? {
        get { return self.view.text }
        set { self.view.text = newValue }
    }
    
    public var delay: TimeInterval
    public var duration: TimeInterval
    
    private var _executing = false
    // Operation 클래스의 open 변수 상속
    open override var isExecuting: Bool {
        get { return self._executing }
        set {
            self.willChangeValue(forKey: "isExecuting")
            self._executing = newValue
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished = false
    open override var isFinished: Bool {
        get { return self._finished }
        set {
            self.willChangeValue(forKey: "isFinished")
            self._finished = newValue
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    // MARK: UI
    
    public var view: ToastView = ToastView()
    
    // MARK: Initializing
    // default value를 설정해놓으면 선택적으로 param을 쓸 수 있다
    public init(text: String?, delay: TimeInterval = 0, duration: TimeInterval = Delay.short) {
        super.init()
        self.delay = delay
        self.duration = duration
        self.text = text
    }
    
    // MARK: Showing
    public func show() {
        
    }
    
    // MARK: - Cancelling
    // Foundation > Task Management > Operation > cancel
    open override func cancel() {
        super.cancel()
        self.finish()
        self.view.removeFromSuperview()
    }
    
    // MARK: Operation Subclassing
    open override func start() {
        let isRunnable = !isFinished && !isCancelled && !isExecuting
        guard isRunnable else { return }
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.start()
            }
            return
        }
        main()
    }
    
    open override func main() {
        isExecuting = true
        
        DispatchQueue.main.async {
            self.view.setNeedsLayout()
            self.view.alpha = 0
            ToastWindow.shared.addSubview(self.view)
            
            UIView.animate(withDuration: 0.5, delay: self.delay, options: .beginFromCurrentState, animations: {
                self.view.alpha = 1
            }) { (completed) in
                UIView.animate(withDuration: self.duration, animations: {
                    self.view.alpha = 1.0001
                }) { (completed) in
                    self.finish()
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.alpha = 0.5
                    }) { (completed) in
                        self.view.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func finish() {
        self.isExecuting = false
        self.isFinished = true
    }
    
}
