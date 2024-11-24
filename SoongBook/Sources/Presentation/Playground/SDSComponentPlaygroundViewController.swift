//
//  SDSComponentPlaygroundViewController.swift
//  SoongBook
//
//  Created by 이숭인 on 11/25/24.
//

import UIKit
import Combine
import SnapKit
import Then

final class SDSComponentPlaygroundView: BaseView {
    let buttonContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 8
    }
    let addSearchBarButton = SDSButton(theme: .purple, variant: .primary, style: .outline, size: .midium).then {
        $0.text = "SearchBar"
        $0.additionalImage = UIImage(systemName: "plus.circle.fill")
        $0.buttonShape = .circle
    }
    let addButtonButton = SDSButton(theme: .purple, variant: .primary, style: .outline, size: .midium).then {
        $0.text = "Button"
        $0.additionalImage = UIImage(systemName: "plus.circle.fill")
        $0.buttonShape = .circle
    }
    let addLabelButton = SDSButton(theme: .purple, variant: .primary, style: .outline, size: .midium).then {
        $0.text = "Label"
        $0.additionalImage = UIImage(systemName: "plus.circle.fill")
        $0.buttonShape = .circle
    }

    let addTextFieldButton = SDSButton(theme: .purple, variant: .primary, style: .outline, size: .midium).then {
        $0.text = "TextField"
        $0.additionalImage = UIImage(systemName: "plus.circle.fill")
        $0.buttonShape = .circle
    }
    
    let deleteSearchBarButton = SDSButton(theme: .purple, variant: .danger, style: .outline, size: .midium).then {
        $0.text = "SearchBar"
        $0.additionalImage = UIImage(systemName: "trash.fill")
        $0.buttonShape = .circle
    }
    let deleteButtonButton = SDSButton(theme: .purple, variant: .danger, style: .outline, size: .midium).then {
        $0.text = "Button"
        $0.additionalImage = UIImage(systemName: "trash.fill")
        $0.buttonShape = .circle
    }
    let deleteLabelButton = SDSButton(theme: .purple, variant: .danger, style: .outline, size: .midium).then {
        $0.text = "Label"
        $0.additionalImage = UIImage(systemName: "trash.fill")
        $0.buttonShape = .circle
    }

    let deleteTextFieldButton = SDSButton(theme: .purple, variant: .danger, style: .outline, size: .midium).then {
        $0.text = "TextField"
        $0.additionalImage = UIImage(systemName: "trash.fill")
        $0.buttonShape = .circle
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setup() {
        super.setup()
        
        backgroundColor = .white000
        
        setupStackView()
    }
    
    override func setupSubviews() {
        addSubview(buttonContainerView)
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        buttonContainerView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func setupStackView() {
        [[addSearchBarButton, deleteSearchBarButton], [addButtonButton, deleteButtonButton], [addLabelButton, deleteLabelButton], [addTextFieldButton, deleteTextFieldButton]].forEach { buttonGroup in
            let groupStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.alignment = .fill
                $0.spacing = 4
            }
            buttonGroup.forEach {
                groupStackView.addArrangedSubview($0)
            }
            
            buttonContainerView.addArrangedSubview(groupStackView)
        }
    }
}

final class SDSComponentPlaygroundViewController: ViewController<SDSComponentPlaygroundView> {
    private var cancellables = Set<AnyCancellable>()
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    private let converter = SDSComponentPlaygroundSectionConverter()
    
    var components = CurrentValueSubject<[ComponentType], Never>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAdapter()
        bindButtonAction()
    }
    
    private func bindAdapter() {
        components
            .sink { [weak self] components in
                let sections = self?.converter.createSections(with: components) ?? []
                
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
    }
    
    private func bindButtonAction() {
        contentView.addSearchBarButton.tap
            .sink { [weak self] _ in
                self?.components.value.append(.searchBar)
            }
            .store(in: &cancellables)
        
        contentView.addButtonButton.tap
            .sink { [weak self] _ in
                self?.components.value.append(.button)
            }
            .store(in: &cancellables)
        
        contentView.addLabelButton.tap
            .sink { [weak self] _ in
                self?.components.value.append(.label)
            }
            .store(in: &cancellables)
        
        contentView.addTextFieldButton.tap
            .sink { [weak self] _ in
                self?.components.value.append(.textField)
            }
            .store(in: &cancellables)
        
        contentView.deleteSearchBarButton.tap
            .sink { [weak self] _ in
                if let index = self?.components.value.lastIndex(where: { $0 == .searchBar }) {
                    self?.components.value.remove(at: index)
                }
            }
            .store(in: &cancellables)
        
        contentView.deleteButtonButton.tap
            .sink { [weak self] _ in
                if let index = self?.components.value.lastIndex(where: { $0 == .button }) {
                    self?.components.value.remove(at: index)
                }
            }
            .store(in: &cancellables)
        
        contentView.deleteLabelButton.tap
            .sink { [weak self] _ in
                if let index = self?.components.value.lastIndex(where: { $0 == .label }) {
                    self?.components.value.remove(at: index)
                }
            }
            .store(in: &cancellables)
        
        contentView.deleteTextFieldButton.tap
            .sink { [weak self] _ in
                if let index = self?.components.value.lastIndex(where: { $0 == .textField }) {
                    self?.components.value.remove(at: index)
                }
            }
            .store(in: &cancellables)
    }
}

extension SDSComponentPlaygroundViewController {
    enum ComponentType: CaseIterable {
        case searchBar
        case button
        case label
        case textField
    }
}

final class SDSComponentPlaygroundSectionConverter {
    typealias ComponentType = SDSComponentPlaygroundViewController.ComponentType
    
    func createSections(with components: [ComponentType]) -> [SectionModelType] {
        [
            createComponents(with: components)
        ].flatMap { $0 }
    }
}

extension SDSComponentPlaygroundSectionConverter {
    private func createComponents(with components: [ComponentType]) -> [SectionModelType] {
        var makedComponents: [ItemModelType] = []
        
        components.forEach { component in
            switch component {
            case .searchBar:
                let searchBarComponent = SDSSearchBarComponent(
                    heightStrategy: .adaptive,
                    identifier: UUID().uuidString,
                    variant: .outline,
                    size: .large,
                    theme: .default
                )
                makedComponents.append(searchBarComponent)
            case .button:
                let buttonComponent = SDSButtonComponent(
                    heightStrategy: .adaptive,
                    identifier: UUID().uuidString,
                    componentModel: SDSButtonComponentModel(
                    theme: .purple,
                    variant: .primary,
                    style: .filled,
                    size: .large,
                    state: .enabled,
                    shape: .round,
                    buttonText: "Button",
                    leftIcon: nil,
                    rightIcon: nil)
                )
                makedComponents.append(buttonComponent)
            case .label:
                let labelComponent = SDSLabelComponent(
                    heightStrategy: .adaptive,
                    identifier: UUID().uuidString,
                    componentModel: SDSLabelComponentModel(
                        text: "Label",
                        typoStyle: .largeBody,
                        textColorStyle: .grayPrimary,
                        numberOfLines: 0,
                        lineBreakMode: .byTruncatingTail,
                        alignment: .center
                    )
                )
                makedComponents.append(labelComponent)
            case .textField:
                let textFieldComponent = SDSTextFieldComponent(
                    heightStrategy: .adaptive,
                    identifier: UUID().uuidString,
                    componentModel:  SDSTextfieldComponentModel(
                        theme: .default,
                        style: .outline,
                        size: .large,
                        title: "타이틀",
                        contentText: "",
                        placeholder: "텍스트를 입력해주세요.",
                        leftImage: .icSearchUnpressed,
                        rightImage: nil,
                        supportText: "도움말 입니다.",
                        supportImage: nil,
                        errorText: nil,
                        errorImage: nil,
                        keyboardType: .default,
                        returnKeyType: .default,
                        isDisabled: false,
                        isError: false
                    )
                )
                makedComponents.append(textFieldComponent)
            }
        }
        
        let section = SectionModel(
            identifier: "maked_components_section",
            itemModels: makedComponents
        )
        
        return [section]
    }
}
