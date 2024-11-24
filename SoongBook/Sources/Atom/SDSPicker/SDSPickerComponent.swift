//
//  SDSPickerComponent.swift
//  SoongBook
//
//  Created by 이숭인 on 11/15/24.
//

import UIKit
import Combine
import SnapKit
import Then
import RxSwift
import RxCocoa

struct SDSPickerEvent: ActionEventItem {
    let identifier: String
    let item: String
}

struct SDSPickerSwitchEvent: ActionEventItem {
    let identifier: String
    let isOn: Bool
}

struct SDSPickerComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .adaptive
    
    var identifier: String
    let title: String
    let subTitle: String
    var isOn: Bool = false
    var selectedItem: String
    let pickerItems: [String]
    var isOptionalOption: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(subTitle)
//        hasher.combine(isOn)
        hasher.combine(pickerItems)
        hasher.combine(isOptionalOption)
    }
    
    func prepareForReuse(content: SDSPickerComponentView) {
        content.pickerItems = []
    }
}

extension SDSPickerComponent {
    typealias ContentType = SDSPickerComponentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(
            title: context.title,
            subTitle: context.subTitle,
            isOn: context.isOn,
            selectedItem: context.selectedItem,
            pickerItems: context.pickerItems,
            isOptionalOption: context.isOptionalOption
        )
        
        content.pickerView.rx.itemSelected
            .asPublisher()
            .sink { [weak content] row, _ in
                content?.textField.text = context.pickerItems[row]
                
                let action = SDSPickerEvent(identifier: context.identifier, item: context.pickerItems[row])
                content?.actionEventEmitter.send(action)
            }
            .store(in: &cancellable)
        
        content.doneButton.tapPublisher
            .sink { [weak content] _ in
                content?.textField.textField.resignFirstResponder()
            }
            .store(in: &cancellable)
        
        content.toggleSwitch.isOnPublisher
            .dropFirst()
            .sink { [weak content] isOn in
                let switchAction = SDSPickerSwitchEvent(
                    identifier: context.identifier,
                    isOn: isOn
                )
                print("id: \(context.identifier), isOn: \(isOn)")
                content?.actionEventEmitter.send(switchAction)
                
                if context.isOptionalOption {
                    content?.textField.isEnabled = isOn
                }
            }
            .store(in: &cancellable)
    }
}

final class SDSPickerComponentView: BaseView, ActionEventEmitable {
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
        variant: .filled,
        size: .large,
        theme: .default
    ).then {
        $0.clearButtonMode = .never
    }
    let pickerView = UIPickerView()
    let toolbar = UIToolbar()
    let doneButton = UIBarButtonItem().then {
        $0.title = "Done"
        $0.style = .done
    }
    
    var pickerItems: [String] = []
    
    override func setup() {
        super.setup()
        
        self.toolbar.sizeToFit()
        self.toolbar.setItems([doneButton], animated: false)
        
        
        textField.textField.inputView = pickerView
        textField.textField.inputAccessoryView = toolbar
        
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
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
    
    func bind(title: String, subTitle: String, isOn: Bool, selectedItem: String, pickerItems: [String], isOptionalOption: Bool) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        textField.text = selectedItem
        
        toggleSwitch.isHidden = !isOptionalOption
        toggleSwitch.isOn = isOn
        
        if isOptionalOption {
            textField.isEnabled = isOn
        }
        
        self.pickerItems = pickerItems
    }
}

extension SDSPickerComponentView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row]
    }
}

extension SDSPickerComponentView {
    private enum Constants {
        static let titleTypo = Typography(token: .mediumSubTitle, colorStyle: .grayPrimary)
        static let bodyTypo = Typography(token: .smallBody, colorStyle: .grayPrimary)
    }
}

import Combine
import RxSwift

extension ObservableType {
    public func asPublisher() -> AnyPublisher<Element, Never> {
        let subject = PassthroughSubject<Element, Never>()
        
        // 구독하여 이벤트를 PassthroughSubject로 전달
        let _ = self.subscribe(
            onNext: { element in
                subject.send(element)
            },
            onError: { error in
                // Combine에서는 Never로 처리되므로 에러를 무시합니다.
                // 에러를 전달하려면 AnyPublisher<Element, Error>로 반환 타입을 변경해야 합니다.
            },
            onCompleted: {
                subject.send(completion: .finished)
            }
        )
        
        return subject.eraseToAnyPublisher()
    }
}
