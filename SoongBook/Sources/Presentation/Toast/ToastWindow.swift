//
//  ToastWindow.swift
//  DesignSystem
//
//  Created by 이숭인 on 10/30/24.
//

import UIKit
import Combine
import SnapKit
import RxSwift
import RxCocoa

final class WindowManager {
    static let shared = WindowManager()
    
    let toastWindow = ToastWindow()
}

public final class ToastWindow: UIWindow {
    public var isPresented: Bool { isHidden == false }
    
    public override var windowLevel: UIWindow.Level {
        get { .alert - 1 }
        set { }
    }
    
    //MARK: Initializer
    public init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
        
        rootViewController = UIViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public functions
    public func setup() {
        backgroundColor = .clear
        isHidden = true
    }
    
    public func show() {
        DispatchQueue.main.async { [weak self] in
            guard self?.isPresented == false else { return }
            
            self?.isHidden = false
        }
    }
    
    public func hide() {
        DispatchQueue.main.async { [weak self] in
            guard self?.isPresented == true else { return }
            
            self?.isHidden = true
        }
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event),
           let rootViewController = rootViewController,
           rootViewController.view.subviews.filter({ $0 is Toast }).contains(where: { view.isDescendant(of: $0) }) {
            return view
        }
        
        return nil
    }
}



public final class Toast: BaseView {
    private var cancellables = Set<AnyCancellable>()
    
    private let configure: ToastConfig
    
    private var attachView: UIView? { configure.attachView }
    private var toastWindow: ToastWindow { WindowManager.shared.toastWindow }
    private var keyboardHeight: CGFloat = .zero
    
    private let toastContainerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let label = UILabel().then {
        $0.text = "Test Label"
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    public init(with config: ToastConfig) {
        self.configure = config
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .emerald300 // TODO: theme
        
        bindKeyboard()
        bindSwipeGesture()
    }
    
    public override func setupSubviews() {
        addSubview(toastContainerStackView)
        
        toastContainerStackView.addArrangedSubview(label)
        toastContainerStackView.addArrangedSubview(buttonStackView)
    }
    
    public override func setupConstraints() {
        toastContainerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
extension Toast {
    public func show() {
        guard toastWindow.isPresented == false else { return }
        removeExistToast()
        
        toastWindow.show()
        
        DispatchQueue.main.async {
            self.insertToastToWindow()
            self.setupVisiblePositionIfNeeded()
            UIView.animate(
                withDuration: self.configure.duration,
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction]
            ) { [weak self] in
                if self?.configure.showAnimationType == .fadeIn {
                    self?.alpha = 1
                }
                self?.superview?.layoutIfNeeded()
            }
        }
        
        setupAutoDismissIfNeeded()
    }
    
    private func setupAutoDismissIfNeeded() {
        guard configure.autoDismiss else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + configure.displayTime) { [weak self] in
            guard let self else { return }
            self.dismiss(to: self.configure.hideAnimationType)
        }
    }
    
    private func dismiss(to hideAnimationType: ToastConfig.HideAnimationType) {
        DispatchQueue.main.async {
            switch hideAnimationType {
            case .toTop:
                self.dismissToTop()
            case .toBottom:
                self.dismissToBottom()
            case .toLeft:
                self.dismissToLeft()
            case .toRight:
                self.dismissToRight()
            default:
                break
            }
            
            UIView.animate(
                withDuration: self.configure.duration,
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction]) {
                    if hideAnimationType == .fadeOut {
                        self.alpha = 0
                    }
                    self.superview?.layoutIfNeeded()
                } completion: { _ in
                    self.removeFromSuperview()
                    self.toastWindow.hide()
                }
        }
    }
    
    private func dismissToTop() {
        guard let rootView = toastWindow.rootViewController?.view else { return }
        
        self.snp.remakeConstraints { make in
            make.bottom.equalTo(rootView.snp.top)
            make.centerX.equalToSuperview()
        }
    }
    
    private func dismissToBottom() {
        guard let rootView = toastWindow.rootViewController?.view else { return }
        
        self.snp.remakeConstraints { make in
            make.top.equalTo(rootView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    private func dismissToLeft() {
        guard let rootView = toastWindow.rootViewController?.view else { return }
        
        self.snp.remakeConstraints { make in
            make.trailing.equalTo(rootView.snp.leading)
            setupVisiblePosition(make)
        }
    }
    
    private func dismissToRight() {
        guard let rootView = toastWindow.rootViewController?.view else { return }
        self.snp.remakeConstraints { make in
            make.leading.equalTo(rootView.snp.trailing)
            setupVisiblePosition(make)
        }
    }
    
    public func hide() {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: self.configure.duration,
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction]) {
                self.removeFromSuperview()
                self.toastWindow.hide()
            }
        }
    }
    
    private func insertToastToWindow() {
        guard let rootViewController = toastWindow.rootViewController else { return }
        toastWindow.rootViewController?.view.addSubview(self)

        self.snp.makeConstraints { make in
            switch configure.showAnimationType {
            case .fadeIn:
                make.bottom.equalToSuperview().inset(16)
            case .fromTop:
                make.bottom.equalTo(rootViewController.view.safeAreaLayoutGuide.snp.top)
            case .fromBottom:
                make.top.equalTo(rootViewController.view.snp.bottom)
            }
            setupWidthStrategyConstraints(make)
            make.centerX.equalToSuperview()
        }
        
        self.alpha = configure.showAnimationType == .fadeIn ? 0 : 1
        
        self.superview?.layoutIfNeeded()
    }
    
    private func removeExistToast() {
        toastWindow.subviews
            .compactMap { view -> Toast? in
                guard view != self else { return nil }
                return view as? Toast
            }
            .forEach { $0.dismiss(to: .fadeOut) }
    }
    
    @discardableResult
    public func addAction(title: String?, image: UIImage?, handler: (() -> Void)?) -> Self {
        let button = SDSButton(
            theme: .pink,
            variant: .primary,
            style: .goast,
            size: .midium,
            state: .enabled
        )
        button.text = title
        button.image = image
        
        button.tap
            .sink { [weak self] _ in
                guard let self else { return }
                self.dismiss(to: self.configure.hideAnimationType)
                handler?()
            }
            .store(in: &cancellables)
        
        buttonStackView.addArrangedSubview(button)
        buttonStackView.isHidden = false
        
        return self
    }
    
    private func setupVisiblePositionIfNeeded() {
        guard configure.showAnimationType != .fadeIn else { return }
        snp.remakeConstraints { make in
            setupVisiblePosition(make)
            setupWidthStrategyConstraints(make)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupVisiblePosition(_ make: ConstraintMaker) {
        guard let rootViewController = toastWindow.rootViewController else { return }
        
        switch configure.positionType {
        case .relative:
            make.bottom.equalToSuperview().inset(getRelativeBottomMargin())
        case .absolute(let absolutePosition):
            switch absolutePosition {
            case .top(let margin):
                make.top.equalTo(rootViewController.view.safeAreaLayoutGuide.snp.top).inset(margin)
            case .center:
                make.centerY.equalToSuperview()
            case .bottom(let margin):
                make.bottom.equalTo(rootViewController.view.safeAreaLayoutGuide.snp.bottom).inset(margin)
            }
        }
    }
    
    private func getRelativeBottomMargin() -> CGFloat {
        guard case .relative(let bottomMargin) = configure.positionType else { return .zero }
        if keyboardHeight > 0 {
            return bottomMargin + keyboardHeight
        } else {
            let safeArea = toastWindow.rootViewController?.view.safeAreaInsets.bottom ?? 0
            return bottomMargin + safeArea
        }
    }
    
    private func setupWidthStrategyConstraints(_ make: ConstraintMaker) {
        switch configure.widthStategy {
        case .fill(let padding):
            make.leading.trailing.equalToSuperview().inset(padding)
        case .adaptive(let padding):
            make.leading.greaterThanOrEqualToSuperview().inset(padding)
            make.trailing.lessThanOrEqualToSuperview().inset(padding)
        }
    }
    
    private func updatePosition() {
        guard superview.isNotNil else { return }
        guard case .relative = configure.positionType else { return }
     
            self.snp.remakeConstraints { make in
                self.setupVisiblePosition(make)
                self.setupWidthStrategyConstraints(make)
                make.centerX.equalToSuperview()
            }
        
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: self?.configure.duration ?? 0,
                           delay: 0,
                           options: [.beginFromCurrentState, .allowUserInteraction],
                           animations: {
                self?.superview?.layoutIfNeeded()
            })
        }
    }
    
    private func bindKeyboard() {
        CombineKeyboard.shared.height
            .sink { [weak self] height in
                self?.keyboardHeight = height
                self?.updatePosition()
            }
            .store(in: &cancellables)
    }
    
    private func bindSwipeGesture() {
        let swipeDirections: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]

        for direction in swipeDirections {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: nil)
            swipeGesture.direction = direction
            self.addGestureRecognizer(swipeGesture)
            
            swipeGesture.swipePublisher
                .sink { [weak self] gesture in
                    switch gesture.direction {
                    case .up:
                        self?.dismiss(to: .toTop)
                    case .down:
                        self?.dismiss(to: .toBottom)
                    case .left:
                        self?.dismiss(to: .toLeft)
                    case .right:
                        self?.dismiss(to: .toRight)
                    default:
                        break
                    }
                }
                .store(in: &cancellables)
        }
    }
}

public struct ToastConfig {
    public var showAnimationType: ShowAnimationType
    public var hideAnimationType: HideAnimationType
    public var positionType: PositionType
    public let widthStategy: ViewWidthStrategy
    public let autoDismiss: Bool
    public let displayTime: TimeInterval
    public let duration: TimeInterval
    public let attachView: UIView?
    
    public init(
        showAnimationType: ShowAnimationType = .fadeIn,
        hideAnimationType: HideAnimationType = .fadeOut,
        positionType: PositionType = .relative(margin: 12),
        widthStategy: ViewWidthStrategy = .fill(padding: 12),
        autoDismiss: Bool = true,
        displayTime: TimeInterval = 3.0,
        duration: TimeInterval = 0.3,
        attachView: UIView? = nil
    ) {
        self.showAnimationType = showAnimationType
        self.hideAnimationType = hideAnimationType
        self.positionType = positionType
        self.widthStategy = widthStategy
        self.autoDismiss = autoDismiss
        self.displayTime = displayTime
        self.duration = duration
        self.attachView = attachView ?? WindowManager.shared.toastWindow
    }
    
}

extension ToastConfig {
    public enum ShowAnimationType: Int {
        case fadeIn
        case fromTop
        case fromBottom
    }
    
    public enum HideAnimationType: Int {
        case fadeOut
        case toTop
        case toBottom
        case toLeft
        case toRight
    }
    
    public enum PositionType {
        case relative(margin: CGFloat)
        case absolute(AbsolutePosition)
        
        public enum AbsolutePosition {
            case top(margin: CGFloat)
            case center
            case bottom(margin: CGFloat)
        }
    }
    
    public enum ViewWidthStrategy {
        case fill(padding: CGFloat)
        case adaptive(padding: CGFloat)
    }
}


public class CombineKeyboard {
    public static let shared = CombineKeyboard()
    
    private let _frame: CurrentValueSubject<CGRect, Never>
    private var cancellables = Set<AnyCancellable>()
    
    /// A publisher emitting current keyboard `frame`
    /// You will be returned the current keyboard `frame` at start of subscription.
    public var frame: AnyPublisher<CGRect, Never> {
        _frame.removeDuplicates().eraseToAnyPublisher()
    }
    
    /// A publisher emitting current keyboard `height`
    /// You will be returned the current keyboard `height` at start of subscription.
    public var height: AnyPublisher<CGFloat, Never> {
        frame.map { UIScreen.main.bounds.height - $0.origin.y }.eraseToAnyPublisher()
    }
    
    /// A publisher emitting current keyboard `height` when keyboard's height is updated
    public var heightUpdated: AnyPublisher<CGFloat, Never> {
        height.dropFirst().eraseToAnyPublisher()
    }
    
    private init() {
        let defaultFrame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0)
        self._frame = .init(defaultFrame)
        
        /// MARK: Keyboard will change frame
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .map { $0.keyboardFrame(defaultFrame) }
            .subscribe(_frame)
            .store(in: &cancellables)
        
        /// MARK: Keyboard will hide
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { $0.keyboardFrame(defaultFrame) }
            .subscribe(_frame)
            .store(in: &cancellables)
    }
}

fileprivate extension Notification {
    func keyboardFrame(_ defaultFrame: CGRect) -> CGRect {
        let value = self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        return value?.cgRectValue ?? defaultFrame
    }
}
