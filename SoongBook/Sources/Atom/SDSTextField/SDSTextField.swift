//
//  SDSTextField.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import UIKit
import Combine
import Then
import SnapKit
import CombineCocoa
import RxSwift
import RxCocoa

public final class SDSTextField: BaseTextField {
    private var cancellables = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()
    
    private let variant: BaseTextField.Variant
    private let size: BaseTextField.Size
    private let theme: TextFieldTheme
    
    private var previousState: BaseTextField.State = .default
    private(set) var state: BaseTextField.State = .default {
        willSet { updatePreviousState(with: newValue, currentState: state) }
        didSet { updateState(with: oldValue) }
    }
    
    //MARK: Properties
    /// `TextField 상단`의 `title`
    public var title: String? {
        didSet { setupTitle() }
    }
    /// `TextField`의 `placeholder`
    public var placeholder: String? {
        didSet { setupPlaceholder() }
    }
    /// `TextField`의 maxLength. `Default value : Int.max`
    public var maxLength: Int = .max
    /// `TextField 좌측`에 생성될 imageView의 이미지. nil이 아닌 경우에만 imageView가 노출됩니다.
    public var leftImage: UIImage? {
        didSet { setupLeftImageView() }
    }
    /// `clear button 우측`에 생성될 버튼의 이미지. nil이 아닌 경우에만 버튼이 노출됩니다.
    public var rightButtonImage: UIImage? {
        didSet { setupRightButton() }
    }
    /// `TextField` 하단 안내 텍스트. `TextField` 하단에 위치합니다.
    public var supportText: String? {
        didSet { setupSupportText() }
    }
    /// `TextField` 하단 안내 이미지. `TextField` 하단에 위치합니다.
    public var supportImage: UIImage? {
        didSet { setupSupportImage() }
    }
    /// `TextField` 하단 에러 텍스트. `SupportView` 하단에 위치합니다.
    public var errorText: String? {
        didSet { setupErrorText() }
    }
    /// `TextField` 하단 에러 이미지. `SupportView` 하단에 위치합니다.
    public var errorImage: UIImage? {
        didSet { setupErrorImage() }
    }
    /// `TextField`의 subview들이 나타나거나 사라질때 animation 적용 여부
    public var enabledAnimation: Bool = false
    /// animation durate
    public var animationDutarion: CGFloat = 0.2
    
    /// `TextField` 의  Enabled.
    public var isEnabled: Bool = true {
        didSet { updateEnabled() }
    }
    /// `ClearButton` 의 노출여부를 결정하는 `ViewMode` 입니다.
    public var clearButtonMode: UITextField.ViewMode = .always {
        didSet { updateClearButtonVisiblity() }
    }
    /// `errorText의 노출 여부를 확인하는 closure`. 정규식 등을 이용할 수 있습니다.
    public var validator: ((String) -> Bool)? {
        didSet { updateStateFromTextFieldEventIfNeeded(with: text ?? "") }
    }
    
    public var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    public var attributedText: NSAttributedString? {
        get { textField.attributedText }
        set { textField.attributedText = newValue }
    }
    /// `Keyboard type`(자판 배열)을 지정합니다.
    public var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    /// `Return key` 타입을 지정합니다.
    public var returnKeyType: UIReturnKeyType {
        get { textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }
    
    // MARK: Publishers
    private let editingDidBeginSubject = PassthroughSubject<String, Never>()
    private let editingDidEndSubject = PassthroughSubject<String, Never>()
    private let textChangedSubject = PassthroughSubject<String, Never>()
    private let rightButtonTapSubject = PassthroughSubject<Void, Never>()
    private let heightChangedSubject = PassthroughSubject<CGFloat, Never>()
    private let stateChangedSubject = PassthroughSubject<State, Never>()
    private let clearButtonTapSubject = PassthroughSubject<Void, Never>()
    
    /// `TextField`의 `editingDidBegin` publisher
    public var editingDidBeginPublisher: AnyPublisher<String, Never> { editingDidBeginSubject.eraseToAnyPublisher() }
    /// `TextField`의 `editingDidEnd` publisher
    public var editingDidEndPublisher: AnyPublisher<String, Never> { editingDidEndSubject.eraseToAnyPublisher() }
    /// `TextField`의 `textChanged` publisher
    public var textChangedPublisher: AnyPublisher<String, Never> { textChangedSubject.eraseToAnyPublisher() }
    /// `rightButton`의 `tap` publisher
    public var rightButtonTapPublisher: AnyPublisher<Void, Never> { rightButtonTapSubject.eraseToAnyPublisher() }
    /// `SwitTextField`의 `heightChanged` publisher
    public var heightChangedPublisher: AnyPublisher<CGFloat, Never> { heightChangedSubject.removeDuplicates().eraseToAnyPublisher() }
    /// `SwitTextField`의 `state` publisher
    public var stateChangedPublisher: AnyPublisher<State, Never> { stateChangedSubject.removeDuplicates().eraseToAnyPublisher() }
    /// `ClearButton` 의 `tab` publisher
    public var clearButtonTapPublisher: AnyPublisher<Void, Never> { clearButtonTapSubject.eraseToAnyPublisher() }
    
    // MARK: Initailize
    public init(
        variant: BaseTextField.Variant,
        size: BaseTextField.Size,
        theme: TextFieldThemeType
    ) {
        self.variant = variant
        self.size = size
        self.theme = theme.instance
        
        super.init(variant: variant, size: size)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setup() {
        super.setup()
        
        updateColors()
        updateEnabled()
        
        bindClearButtonTap()
        bindRightButtonTap()
        bindTextFieldEditingDidBegin()
        bindTextFieldTextChanged()
        bindTextFieldEditingDidEnd()
    }
    
    private func updateTargetViewVisibility(to targetView: UIView, isHidden: Bool, duration: CGFloat) {
        guard targetView.isHidden != isHidden else { return }

        if enabledAnimation {
            UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState]) {
                targetView.isHidden = isHidden
                targetView.alpha = isHidden ? 0 : 1
                if self.superview != nil {
                    self.layoutIfNeeded()
                }
            }
        } else {
            targetView.isHidden = isHidden
            targetView.alpha = 1
        }
        
        heightChangedSubject.send(sizeThatFits(.zero).height)
    }
}

//MARK: - Event
extension SDSTextField {
    private func bindClearButtonTap() {
        clearButton.tapPublisher
            .sink { [weak self] in
                self?.textField.text = ""
                self?.clearButtonTapSubject.send(Void())
            }
            .store(in: &cancellables)
    }

    private func bindRightButtonTap() {
        rightButton.tapPublisher
            .sink { [weak self] in
                self?.rightButtonTapSubject.send(Void())
            }
            .store(in: &cancellables)
    }
    
    private func bindTextFieldEditingDidBegin() {
        textField.rx.controlEvent(.editingDidBegin)
            .withLatestFrom(textField.rx.text)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] text in
                self?.updateStateFromTextFieldEventIfNeeded(with: text ?? "")
                self?.editingDidBeginSubject.send(text ?? "")
            }
            .disposed(by: disposeBag)
    }
    
    private func bindTextFieldEditingDidEnd() {
        textField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(textField.rx.text)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] text in
                self?.updateStateFromTextFieldEventIfNeeded(with: text ?? "")
                self?.editingDidEndSubject.send(text ?? "")
            }
            .disposed(by: disposeBag)
    }
    
    private func bindTextFieldTextChanged() {
        textField.rx.controlEvent(.editingChanged)
            .withLatestFrom(textField.rx.text)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] text in
                self?.updateStateFromTextFieldEventIfNeeded(with: text ?? "")
                self?.textChangedSubject.send(text ?? "")
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - Update
extension SDSTextField {
    private func updateState(with oldValue: State) {
        guard state != oldValue else {
            return
        }
        
        updateColors()
        stateChangedSubject.send(state)
    }
    
    private func updateColors() {
        /// back / border / focus 's `Color`
        textFieldContainerView.backgroundColor = textFieldBackgroundColor
        textFieldFocusColorView.backgroundColor = textFieldBackgroundColor
        textFieldFocusColorView.layer.borderColor = textFieldBorderColor
        
        textField.tintColor = textFieldTintColor
        errorImageView.tintColor = errorImageTintColor
        clearButton.tintColor = clearButtonTintColor
    }
    
    private func updatePreviousState(with newState: State, currentState: State) {
        guard currentState != newState, currentState != .disabled else { return }
        previousState = {
            if state == .typing {
                return .typed
            } else {
                return currentState
            }
        }()
    }
    
    private func updateStateFromTextFieldEventIfNeeded(with text: String) {
        guard state != .disabled else { return }

        updateStateByTextFieldResponder(with: text) // Handle textField state
        updateClearButtonVisiblity() // Handle clear button visiblity
        checkValidationIfNeeded(with: text)// Check text validation
        
    }

    private func updateStateByTextFieldResponder(with text: String) {
        let textEmptyState: State = textField.isFirstResponder ? .press : .default
        let textNotEmptyState: State = textField.isFirstResponder ? .typing : .typed
        state = text.isEmpty ? textEmptyState : textNotEmptyState
    }
    
    private func updateClearButtonVisiblity() {
        let isHidden = {
            let isDisabled = state == .disabled
            let isTextEmpty = (textField.text ?? "").isEmpty

            switch clearButtonMode {
            case .never: return true
            case .always: return isDisabled || isTextEmpty
            case .unlessEditing: return isDisabled || isTextEmpty || state != .typed
            case .whileEditing: return isDisabled || isTextEmpty || state != .typing
            @unknown default: return true
            }
        }()
        clearButton.isHidden = isHidden
        clearButton.alpha = isHidden ? 0 : 1
    }
    
    private func checkValidationIfNeeded(with text: String) {
        guard let validator, state != .disabled else { return }
        
        if validator(text) == false {
            state = .error
        }
        
        let isHiddenErrorMessage = !(errorText.isNotNil && state == .error)
        
        setupErrorText()
        setupErrorImage()
        
        updateTargetViewVisibility(
            to: supportView,
            isHidden: !isHiddenErrorMessage,
            duration: animationDutarion
        )
    }
    
    private func updateEnabled() {
        state = isEnabled ? previousState : .disabled

        textField.isEnabled = isEnabled
        rightButton.isEnabled = isEnabled
        
        rightButton.tintColor = imageTintColor
        leftImageView.tintColor = imageTintColor
        supportImageView.tintColor = imageTintColor
        
        errorImageView.tintColor = errorImageTintColor
        
        updateClearButtonVisiblity()
    }
}

// MARK: - Setup
extension SDSTextField {
    private func setupTitle() {
        titleLabel.text = title
        
        updateTargetViewVisibility(to: titleContainer, isHidden: title.isNil, duration: animationDutarion)
        
        if title.isNotNil {
            setupTitleContainerCustomSpacing()
        }
    }
    
    private func setupPlaceholder() {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: size.placeholderAttributes)
    }
    
    private func setupLeftImageView() {
        leftImageView.fetch(leftImage)
        
        updateTargetViewVisibility(
            to: leftImageView,
            isHidden: leftImage.isNil,
            duration: animationDutarion
        )
    }
    
    private func setupRightButton() {
        guard let rightButtonImage = rightButtonImage else {
            updateTargetViewVisibility(to: rightButton, isHidden: true, duration: animationDutarion)
            return
        }
        
        // 버튼 영역을 조금 더 넓히기 위해 디자인보다 상하좌우 4씩 늘려놨기 때문에 이미지는 4씩 줄여놔야한다.
        let convertedSize = CGSize(width: size.rightButtonImageSize - 4, height: size.rightButtonImageSize - 4)
        rightButton.setImage(rightButtonImage.resize(to: convertedSize).withRenderingMode(.alwaysTemplate), for: .normal)
        updateTargetViewVisibility(to: rightButton, isHidden: false, duration: animationDutarion)
    }
    
    private func setupSupportText() {
        let isSupportTextHidden = supportText.isNil
        
        updateTargetViewVisibility(
            to: supportView,
            isHidden: isSupportTextHidden,
            duration: animationDutarion
        )
        
        supportLabel.text = supportText
        
        if supportText.isNotNil {
            setupTextFieldContainerCustomSpacing()
        }
    }
    
    private func setupSupportImage() {
        let isSupportImageHidden = supportImage.isNil
        
        updateTargetViewVisibility(
            to: supportImageView,
            isHidden: isSupportImageHidden,
            duration: animationDutarion
        )
        
        supportImageView.image = supportImage
    }
    
    private func setupErrorText() {
        let isErrorTextHidden = !(errorText.isNotNil && state == .error)
        
        updateTargetViewVisibility(
            to: errorView,
            isHidden: isErrorTextHidden,
            duration: animationDutarion
        )
        
        errorLabel.text = errorText
        
        if errorText.isNotNil {
            setupTextFieldContainerCustomSpacing()
        }
    }
    
    private func setupErrorImage() {
        let isErrorImageHidden = !(errorImage.isNotNil && state == .error)
        
        updateTargetViewVisibility(
            to: errorImageView,
            isHidden: isErrorImageHidden,
            duration: animationDutarion
        )
        
        errorImageView.image = errorImage
    }
    
    private func setupInputView() {
        textField.inputView = inputView
    }
}

//MARK: - Color
extension SDSTextField {
    private var titleTextColor: UIColor { theme.titleTextColor }
    private var helperTextColor: UIColor { theme.helperTextColor }
//    private var errorTextColor: UIColor { theme.errorTextColor }
    private var textFieldTintColor: UIColor { theme.textFieldTintColor }
    private var errorImageTintColor: UIColor { theme.errorImageTintColor }
    private var clearButtonTintColor: UIColor { theme.clearButtonTintColor }
//
    private var imageTintColor: UIColor {
        theme.imageTintColor(isEnabled: isEnabled)
    }
//
//    private var textFieldFontColor: UIColor {
//        theme.textFieldFontColor(state: state)
//    }
    
    private var textFieldBackgroundColor: UIColor {
        theme.textFieldBackgroundColor(variant: variant, state: state)
    }
    
    private var textFieldFocusColor: UIColor {
        theme.textFieldFocusColor(variant: variant, state: state)
    }

    private var textFieldBorderColor: CGColor {
        theme.textFieldBorderColor(variant: variant, state: state)
    }
}

