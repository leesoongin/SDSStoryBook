//
//  SDSSearchBar.swift
//  SoongBook
//
//  Created by 이숭인 on 11/24/24.
//

import UIKit
import Combine
import Then
import SnapKit
import CombineCocoa
import RxSwift
import RxCocoa

//TODO: 자체 Theme 만들어야함.
public final class SDSSearchBar: BaseView {
    private var cancellables = Set<AnyCancellable>()
    
    let containerView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .center
    }
    let textField: SDSTextField
    let cancelButton = SDSButton(
        theme: .purple,
        variant: .primary,
        style: .goast,
        size: .midium,
        state: .enabled
    ).then {
        $0.text = "취소"
        $0.isStretch = false
        $0.isHidden = true
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
    }
    
    //MARK: Properties
    //TODO: SearchBar의 Theme도 만들어여함
    private let variant: BaseTextField.Variant
    private let size: BaseTextField.Size
    private let theme: TextFieldThemeType
    
    /// `TextField`의 `placeholder`
    public var placeholder: String? {
        didSet { setupPlaceholder() }
    }
    /// `TextField 좌측`에 생성될 imageView의 이미지. nil이 아닌 경우에만 imageView가 노출됩니다.
    public var leftImage: UIImage? {
        didSet { setupLeftImageView() }
    }
    /// `clear button 우측`에 생성될 버튼의 이미지. nil이 아닌 경우에만 버튼이 노출됩니다.
    public var rightButtonImage: UIImage? {
        didSet { setupRightButton() }
    }
    
    /// `SearchBar`의 `textChanged` publisher
    public var textChangedPublisher: AnyPublisher<String, Never> {
        textField.textChangedPublisher
    }
    /// `SearchBar`의 `editingDidBegin` publisher
    public var editingDidBeginPublisher: AnyPublisher<String, Never> {
        textField.editingDidBeginPublisher
    }
    /// `SearchBar`의 `editingDidEnd` publisher
    public var editingDidEndPublisher: AnyPublisher<String, Never> {
        textField.editingDidEndPublisher
    }
    /// `rightButton`의 `tap` publisher
    public var rightButtonTapPublisher: AnyPublisher<Void, Never> {
        textField.rightButtonTapPublisher
    }
    /// `ClearButton` 의 `tab` publisher
    public var clearButtonTapPublisher: AnyPublisher<Void, Never> {
        textField.clearButtonTapPublisher
    }
   
    private let cancelButtonTapSubject = PassthroughSubject<Void, Never>()
    /// `CancelButton` 의 `tab` Publisher
    public var cancelButtonTapPublisher: AnyPublisher<Void, Never> {
        cancelButtonTapSubject.eraseToAnyPublisher()
    }

    public init(
        variant: BaseTextField.Variant,
        size: BaseTextField.Size,
        theme: TextFieldThemeType
    ) {
        self.variant = variant
        self.size = size
        self.theme = theme
        
        self.textField = SDSTextField(
            variant: variant,
            size: size,
            theme: theme
        )
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setup() {
        super.setup()
        
        setupCustomSpacing()
        
        bindAction()
    }
    
    public override func setupSubviews() {
        addSubview(containerView)
        
        
        containerView.addArrangedSubview(textField)
        containerView.addArrangedSubview(cancelButton)
    }
    
    public override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(32)
        }
    }
    
    private func setupCustomSpacing() {
        containerView.setCustomSpacing(8, after: textField)
    }
    
    private func bindAction() {
        cancelButton.tap
            .sink { [weak self] _ in
                self?.cancelButtonTapSubject.send(Void())
                self?.textField.textField.resignFirstResponder()
            }
            .store(in: &cancellables)
        
        textField.editingDidBeginPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.updateTargetViewVisibility(
                    to: self.cancelButton,
                    isHidden: false,
                    duration: 0.2
                )
            }
            .store(in: &cancellables)
        
        textField.editingDidEndPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.updateTargetViewVisibility(
                    to: self.cancelButton,
                    isHidden: true,
                    duration: 0.2
                )
            }
            .store(in: &cancellables)
    }
    
    private func updateTargetViewVisibility(to targetView: UIView, isHidden: Bool, duration: CGFloat) {
        guard targetView.isHidden != isHidden else { return }
        
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState]) {
            targetView.isHidden = isHidden
            targetView.alpha = isHidden ? 0 : 1
            if self.superview != nil {
                self.layoutIfNeeded()
            }
        }
    }
}

//MARK: - Setup
extension SDSSearchBar {
    private func setupPlaceholder() {
        textField.placeholder = placeholder
    }
    
    private func setupLeftImageView() {
        textField.leftImage = leftImage
    }
    
    private func setupRightButton() {
        textField.rightButtonImage = rightButtonImage
    }
}
