//
//  SDSTextFieldComponent.swift
//  SoongBook
//
//  Created by 이숭인 on 11/17/24.
//

import UIKit
import Combine
import Then
import SnapKit

struct SDSTextfieldComponentModel: Hashable {
    var theme: TextFieldThemeType
    var style: BaseTextField.Variant // 정의된 enum name 을 variant > style로 변경해야함
    var size: BaseTextField.Size
    var title: String?
    var contentText: String
    var placeholder: String?
    var leftImage: UIImage?
    var rightImage: UIImage?
    var supportText: String?
    var supportImage: UIImage?
    var errorText: String?
    var errorImage: UIImage?
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var isDisabled: Bool = false
    var isError: Bool = false
}

struct SDSTextFieldComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .ratioWithCollectionView(1.0)
    
    var identifier: String
    let componentModel: SDSTextfieldComponentModel
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(componentModel)
    }
    
    func prepareForReuse(content: SDSTextFieldComponentView) {
        content.containerStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension SDSTextFieldComponent {
    typealias ContentType = SDSTextFieldComponentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(with: context.componentModel)
    }
}

final class SDSTextFieldComponentView: BaseView {
    let containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    let bottomDivider = UIView().then {
        $0.backgroundColor = .gray300
    }
    
    override func setupSubviews() {
        addSubview(containerStackView)
        addSubview(bottomDivider)
    }
    
    override func setupConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.greaterThanOrEqualToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        bottomDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func bind(with model: SDSTextfieldComponentModel) {
        let textField = SDSTextField(
            variant: model.style,
            size: model.size,
            theme: model.theme
        )
        
        textField.title = model.title
        textField.text = model.contentText
        textField.placeholder = model.placeholder
        textField.leftImage = model.leftImage
        textField.rightButtonImage = model.rightImage
        textField.supportText = model.supportText
        textField.supportImage = model.supportImage
        textField.errorText = model.errorText
        textField.errorImage = model.errorImage
        textField.keyboardType = model.keyboardType
        textField.returnKeyType = model.returnKeyType
        textField.isEnabled = !model.isDisabled
        
        if model.isError {
            textField.validator = { _ in
                return false
            }
        }
        
        containerStackView.addArrangedSubview(textField)
    }
}

