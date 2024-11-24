//
//  SDSUserInputComponent.swift
//  SoongBook
//
//  Created by 이숭인 on 11/17/24.
//

import UIKit
import Combine
import SnapKit
import Then

struct SDSChangeUserInputEvent: ActionEventItem {
    let identifier: String
    let text: String
}

struct SDSUserInputComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .adaptive
    
    var identifier: String
    let title: String
    let subTitle: String
    var isOn: Bool = false
    let placeHolder: String
    let text: String
    var keyboardType: UIKeyboardType = .default
    var isOptionalOption: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(subTitle)
        hasher.combine(placeHolder)
        hasher.combine(keyboardType)
        hasher.combine(isOptionalOption)
    }
}

extension SDSUserInputComponent {
    typealias ContentType = SDSUserInputView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(
            title: context.title,
            subTitle: context.subTitle,
            isOn: context.isOn,
            placeHolder: context.placeHolder,
            text: context.text, 
            keyboardType: context.keyboardType,
            isOptionalOption: context.isOptionalOption
        )
        
        content.textField.textChangedPublisher
            .sink { [weak content] text in
                let action = SDSChangeUserInputEvent(
                    identifier: context.identifier,
                    text: text
                )
                content?.actionEventEmitter.send(action)
            }
            .store(in: &cancellable)
        
        content.textField.clearButtonTapPublisher
            .dropFirst()
            .sink { [weak content] _ in
                let action = SDSChangeUserInputEvent(identifier: context.identifier, text: "")
                content?.actionEventEmitter.send(action)
            }
            .store(in: &cancellable)
        
        content.toggleSwitch.isOnPublisher
            .dropFirst()
            .sink { [weak content] isOn in
                let switchAction = SDSPickerSwitchEvent(
                    identifier: context.identifier,
                    isOn: isOn
                )
                content?.actionEventEmitter.send(switchAction)
                
                if context.isOptionalOption {
                    content?.textField.isEnabled = isOn
                    if !isOn {
                        content?.textField.text = nil
                    }
                }
            }
            .store(in: &cancellable)
    }
}

final class SDSUserInputView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let containerView = UIView()
    
    let topContainerView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    let toggleSwitch = UISwitch().then {
        $0.onTintColor = .green200
    }
    let titleContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
    }
    let titleLabel = SDSLabel(typography: Constants.titleTypo)
    let subTitleLabel = SDSLabel(typography: Constants.bodyTypo)
    
    let textField = SDSTextField(
        variant: .outline,
        size: .large,
        theme: .default
    )
    
    override func setupSubviews() {
        addSubview(containerView)
        
        containerView.addSubview(topContainerView)
        topContainerView.addArrangedSubview(titleContainerView)
        topContainerView.addArrangedSubview(toggleSwitch)
        
        titleContainerView.addArrangedSubview(titleLabel)
        titleContainerView.addArrangedSubview(subTitleLabel)
        
        containerView.addSubview(textField)
    }
    
    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        topContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(topContainerView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func bind(title: String, subTitle: String, isOn: Bool, placeHolder: String, text: String, keyboardType: UIKeyboardType, isOptionalOption: Bool) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        textField.placeholder = placeHolder
        textField.text = text
        textField.keyboardType = keyboardType
        
        toggleSwitch.isHidden = !isOptionalOption
        toggleSwitch.isOn = isOn
        
        if isOptionalOption {
            textField.isEnabled = isOn
        }
    }
}

extension SDSUserInputView {
    private enum Constants {
        static let titleTypo = Typography(token: .mediumSubTitle, colorStyle: .grayPrimary)
        static let bodyTypo = Typography(token: .smallBody, colorStyle: .grayPrimary)
    }
}
