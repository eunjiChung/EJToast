//
//  ToastView.swift
//  EJToast
//
//  Created by eunji chung on 2020/01/15.
//

import UIKit

open class ToastView: UIView {
    // MARK: - Properties
    open var text: String? {
        get { return self.textLabel.text }
        set { self.textLabel.text = newValue }
    }
    
    
    // MARK: - UI
    private let backgroundView: UIView = {
       // Use backticks to make `self` an identifier
        let `self` = UIView()
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        return self
    }()
    private let textLabel: UILabel = {
        let `self` = UILabel()
        self.textColor = .white
        self.backgroundColor = .clear
        self.font = {
            switch UIDevice.current.userInterfaceIdiom {
            case .unspecified:   return .systemFont(ofSize: 12)
            case .phone      :   return .systemFont(ofSize: 12)
            case .pad        :   return .systemFont(ofSize: 16)
            case .tv         :   return .systemFont(ofSize: 20)
            case .carPlay    :   return .systemFont(ofSize: 12)
            }
        }()
        self.numberOfLines = 0
        self.textAlignment = .center
        return self
    }()
    
    
    // MARK: - Appearance
    
    /// The background view's color
    open override var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    
    /// The background view's corner radius.
    @objc open var cornerRadius: CGFloat {
        get { return self.backgroundView.layer.cornerRadius }
        set { self.backgroundView.layer.cornerRadius = newValue }
    }
    
    /// The inset of the text Label
    open var textInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    
    /// The color of the text label's text
    open var textColor: UIColor? {
        get { return self.textLabel.textColor }
        set { self.textLabel.textColor = newValue }
    }
    
    /// The font of the text label.
    open var font: UIFont? {
        get { return self.textLabel.font }
        set { self.textLabel.font = newValue }
    }
    
    /// The bottom offset from the screen's bottom in portrait mode.
    open var bottomOffsetPortrait: CGFloat = {
        switch UIDevice.current.userInterfaceIdiom {
            case .unspecified: return 30
            case .phone: return 30
            case .pad: return 60
            case .tv: return 90
            case .carPlay: return 30
        }
    }()
    
    /// The bottom offset from the screen's bottom in landscape mode
    open var bottomOffsetLandscape: CGFloat = {
        switch UIDevice.current.userInterfaceIdiom {
        case .unspecified: return 20
        case .phone: return 20
        case .pad: return 40
        case .tv: return 60
        case .carPlay: return 20
        }
    }()
    
    
    // MARK: - Initializing
    public init() {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = false
        self.addSubview(self.backgroundView)
        self.addSubview(self.textLabel)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    /*
     subview를 배치하는 함수
     디폴트 기능으로는 당신이 어떤 서브뷰의 사이즈와 위치든 정할때 설정하는 모든 constraint를 쓴다
     서브 클래스들은 이 메소드를 필요에 따라 오버라이딩하여 서브뷰에 더 정확한 레이아웃을 설정할 수 있다
     이 기능을 오버라이딩하는 때는, 서브뷰가 당신이 원하는 오토 리사이징이나 constraint 기반의 동작을 하지 않을 때이다
     서브뷰들의 프레임을 직접적으로 설정하기 위해 쓴다
     
     이 메소드를 직접적으로 호출하지 않는다. 만약 당신이 레이아웃 업데이트를 원한다면, setNeedsLayout 메소드를 호출해야 한다
     */
    open override func layoutSubviews() {
        super.layoutSubviews()
        let containerSize = ToastWindow.shared.frame.size
        let constraintSize = CGSize(width: containerSize.width * (280.0 / 320.0), height: CGFloat.greatestFiniteMagnitude)
        
        let textLabelSize = textLabel.sizeThatFits(constraintSize)
        textLabel.frame = CGRect(x: textInsets.left, y: textInsets.top, width: textLabelSize.width, height: textLabelSize.height)
        backgroundView.frame = CGRect(
            x: 0,
            y: 0,
            width: textLabel.frame.size.width + textInsets.left + textInsets.right,
            height: textLabel.frame.size.height + textInsets.top + textInsets.bottom
        )
        
        var x: CGFloat
        var y: CGFloat
        var width: CGFloat
        var height: CGFloat
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation.isPortrait || !ToastWindow.shared.shouldRotateManually {
            width = containerSize.width
            height = containerSize.height
            y = self.bottomOffsetPortrait
        } else {
            width = containerSize.height
            height = containerSize.width
            y = self.bottomOffsetLandscape
        }
        
        let backgroundViewSize = backgroundView.frame.size
        x = (width - backgroundViewSize.width) * 0.5
        y = height - (backgroundViewSize.height + y)
        self.frame = CGRect(x: x, y: y, width: backgroundViewSize.width, height: backgroundViewSize.height)
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let superview = self.superview {
            let pointInWindow = self.convert(point, to: superview)
            let contains = self.frame.contains(pointInWindow)
            
        }
    }
}
