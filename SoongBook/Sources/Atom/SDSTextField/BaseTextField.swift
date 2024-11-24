//
//  BaseTextField.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import UIKit
import SnapKit
import Then

public class BaseTextField: BaseView {
    private let variant: Variant
    private let size: Size
    
    // MARK: - UI Components
    // 0. Container
    let containerView = UIStackView().then {
        $0.axis = .vertical
    }
    
    // 1. Title
    let titleContainer = UIView()
    lazy var titleLabel = UILabel(typography: Constant.titleTypo.value)
    
    // 2. Background
    let textFieldContainerView = UIView().then {
        $0.layer.cornerRadius = 12
    }
    let textFieldFocusColorView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
    }
    
    // 3. TextField Content
    let textFieldStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.isLayoutMarginsRelativeArrangement = true
    }
    let leftImageView = ImageContentView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    let textField = UITextField()
    let rightButton = UIButton().then {
        $0.imageView?.contentMode = .scaleAspectFit
    }
    lazy var clearButton = {
        var config = UIButton.Configuration.plain()
        let convertedSize = CGSize(width: size.rightButtonImageSize - 4, height: size.rightButtonImageSize - 4)
        config.image = UIImage(systemName: "xmark.circle.fill")?.resize(to: convertedSize).withRenderingMode(.alwaysTemplate)
        config.background.imageContentMode = .scaleAspectFit
        
        let button = UIButton(configuration: config)
        button.clipsToBounds = true
        
        return button
    }()
    
    // 4. Support Label
    let supportView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
    }
    let supportImageView = ImageContentView()
    lazy var supportLabel = UILabel(typography: Constant.supportTypo.value)
    
    // 5. error View
    let errorView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    let errorImageView = ImageContentView()
    lazy var errorLabel = UILabel(typography: Constant.errorTypo.value)
    
    public init(variant: Variant, size: Size) {
        self.variant = variant
        self.size = size
        
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setup() {
        super.setup()
        
        setupSupportCustomSpacing()
        setupErrorCustomSpacing()
        setupTextFieldLayoutMargin()
        setupInitialVisibility()
    }
    
    public override func setupSubviews() {
        addSubview(containerView)
        
        // title
        containerView.addArrangedSubview(titleContainer)
        titleContainer.addSubview(titleLabel)
        
        // textField
        containerView.addArrangedSubview(textFieldContainerView)
        textFieldContainerView.addSubview(textFieldFocusColorView)
        textFieldContainerView.addSubview(textFieldStackView)
        
        textFieldStackView.addArrangedSubview(leftImageView)
        textFieldStackView.addArrangedSubview(textField)
        textFieldStackView.addArrangedSubview(clearButton)
        textFieldStackView.addArrangedSubview(rightButton)
        
        // support
        containerView.addArrangedSubview(supportView)
        supportView.addArrangedSubview(supportImageView)
        supportView.addArrangedSubview(supportLabel)
        
        // error
        containerView.addArrangedSubview(errorView)
        errorView.addArrangedSubview(errorImageView)
        errorView.addArrangedSubview(errorLabel)
    }
    
    public override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.height.equalTo(size.rawValue)
        }
        
        textFieldFocusColorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textFieldStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        leftImageView.snp.makeConstraints { make in
            make.size.equalTo(size.leftImageSize)
        }
        
        clearButton.snp.makeConstraints { make in
            make.size.equalTo(size.rightButtonImageSize)
        }
        
        rightButton.snp.makeConstraints { make in
            make.size.equalTo(size.rightButtonImageSize)
        }
        
        supportImageView.snp.makeConstraints { make in
            make.size.equalTo(14)
        }
        
        errorImageView.snp.makeConstraints { make in
            make.size.equalTo(14)
        }
    }
    
    
    public func setupTitleContainerCustomSpacing() {
        containerView.setCustomSpacing(8, after: titleContainer)
    }
    
    public func setupTextFieldContainerCustomSpacing() {
        containerView.setCustomSpacing(8, after: textFieldContainerView)
    }
    
    private func setupInitialVisibility() {
        [titleContainer,
         leftImageView,
         clearButton,
         rightButton,
         supportView,
         supportImageView,
         errorView,
         errorImageView
        ].forEach {
            $0.isHidden = true
            $0.alpha = 0
        }
    }
    
    private func setupTextFieldLayoutMargin() {
        textFieldStackView.layoutMargins = size.layoutMargin
        
        textFieldStackView.setCustomSpacing(size.layoutMargin.left - 4, after: leftImageView)
        textFieldStackView.setCustomSpacing(size.layoutMargin.left - 4, after: textField)
        textFieldStackView.setCustomSpacing(size.layoutMargin.left - 4, after: clearButton)
    }
    
    private func setupSupportCustomSpacing() {
        supportView.setCustomSpacing(4, after: supportImageView)
    }
    
    private func setupErrorCustomSpacing() {
        errorView.setCustomSpacing(4, after: errorImageView)
    }
}


extension BaseTextField {
    public enum State: Hashable {
        case `default`
        case press
        case typed
        case typing
        case disabled
        case error
    }
}

extension BaseTextField {
    public enum Variant {
        case filled
        case outline
    }
    
    public enum Size: CGFloat {
        case large = 44
        case medium = 40
        case small = 36
    }
}

extension BaseTextField.Size {
    var placeholderAttributes: [NSAttributedString.Key: Any] {
        switch self {
        case .large:
            return [.font: UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor.gray500]
        case .medium:
            return [.font: UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor.gray500]
        case .small:
            return [.font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.gray500]
        }
    }

    var layoutMargin: UIEdgeInsets {
        switch self {
        case .large, .medium: return .init(top: 0, left: 12, bottom: 0, right: 10)
        case .small: return .init(top: 0, left: 8, bottom: 0, right: 6)
        }
    }

    var leftImageSize: CGFloat {
        switch self {
        case .large: return 18
        case .medium: return 18
        case .small: return 16
        }
    }

    // 버튼 영역을 조금 더 넓히기 위해 디자인보다 상하좌우 4씩 늘려놓는다
    var rightButtonImageSize: CGFloat {
        switch self {
        case .large: return 22
        case .medium: return 22
        case .small: return 20
        }
    }
}

extension BaseTextField {
    //TODO: 추후 Typo 도 theme 에 넣자
    enum Constant {
        case titleTypo
        case contentTypo
        case supportTypo
        case errorTypo
        
        var value: Typography {
            switch self {
            case .titleTypo:
                Typography(
                    token: .smallSubTitle,
                    colorStyle: .grayPrimary,
                    alignment: .natural,
                    applyLineHeight: true
                )
            case .contentTypo:
                Typography(
                    token: .mediumBody,
                    colorStyle: .grayPrimary,
                    alignment: .natural,
                    applyLineHeight: true
                )
            case .supportTypo:
                Typography(
                    token: .smallBody,
                    colorStyle: .grayPrimary,
                    alignment: .natural,
                    applyLineHeight: true
                )
            case .errorTypo:
                Typography(
                    token: .smallBody,
                    colorStyle: .textWarned,
                    alignment: .natural,
                    applyLineHeight: true
                )
            }
        }
    }
}

extension UIImage {
    public func resize(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    public func resize(to size: CGFloat) -> UIImage {
        resize(to: CGSize(width: size, height: size))
    }
}
