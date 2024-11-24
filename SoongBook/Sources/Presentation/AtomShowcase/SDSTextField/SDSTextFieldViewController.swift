//
//  SDSTextFieldViewController.swift
//  SoongBook
//
//  Created by 이숭인 on 11/17/24.
//

import UIKit
import SnapKit
import Then
import Combine

final class SDSTextFieldView: BaseView {
    let contentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setup() {
        super.setup()
        
        backgroundColor = .white000
    }
    
    override func setupSubviews() {
        addSubview(contentCollectionView)
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        contentCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentCollectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

final class SDSTextFieldViewController: ViewController<SDSTextFieldView> {
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    private lazy var contentAdapter = CollectionViewAdapter(with: contentView.contentCollectionView)
    
    private let converter = SDSTextFieldSectionConverter()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let textComponentSubject = CurrentValueSubject<SDSTextfieldComponentModel, Never>(
        SDSTextfieldComponentModel(
            theme: .default,
            style: .filled,
            size: .large,
            title: nil,
            contentText: "",
            placeholder: "텍스트를 입력해주세요.",
            leftImage: nil,
            rightImage: nil,
            supportText: nil,
            supportImage: nil,
            errorText: nil,
            errorImage: nil,
            keyboardType: .default,
            returnKeyType: .default,
            isDisabled: false,
            isError: false
        )
    )
    
    private var switchStateDictionary: [String: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        textComponentSubject
            .sink { [weak self] model in
                let sdsTextFieldComponent = SDSTextFieldComponent(
                    identifier: "textfield_component",
                    componentModel: model
                )
                
                let section = SectionModel(
                    identifier: "textfield_component_section",
                    itemModels: [sdsTextFieldComponent]
                )
                
                _ = self?.contentAdapter.receive([section])
            }
            .store(in: &cancellables)
        
        textComponentSubject
            .sink { [weak self] component in
                let sections = self?.converter.createSections(
                    with: component,
                    imageMenu: ImageType.allCases,
                    themeMenu: ThemeType.allCases,
                    styleMenu: StyleType.allCases,
                    sizeMenu: SizeType.allCases,
                    switchState: self?.switchStateDictionary ?? [:]
                    ) ?? []
                
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        adapter.actionEventPublisher
            .sink { [weak self] action in
                switch action {
                case let action as SDSPickerEvent:
                    self?.handlePickerEvent(with: action)
                case let action as SDSChangeUserInputEvent:
                    self?.handleUserInputEvent(with: action)
                case let action as SDSPickerSwitchEvent:
                    self?.handlePickerSwitchEvent(with: action)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func handlePickerSwitchEvent(with event: SDSPickerSwitchEvent) {
        setupUserInputSectionIfNeeded(with: event)
        setupImagePickerSection(with: event)
        
        if event.isOn {
            switchStateDictionary.updateValue(true, forKey: event.identifier)
        } else {
            switchStateDictionary.removeValue(forKey: event.identifier)
        }
    }
    
    
    private func setupUserInputSectionIfNeeded(with event: SDSPickerSwitchEvent) {
        guard let sectionIdentifier = SDSTextFieldSectionConverter.SectionIdentifier(rawValue: event.identifier), event.isOn == false else {
            return
        }
        switch sectionIdentifier {
        case .titleInput:
            textComponentSubject.value.title = nil
        case .supportInput:
            textComponentSubject.value.supportText = nil
        case .errorInput:
            textComponentSubject.value.errorText = nil
        default:
            break
        }
    }
    
    
    private func setupImagePickerSection(with event: SDSPickerSwitchEvent) {
        guard let sectionIdentifier = SDSTextFieldSectionConverter.SectionIdentifier(rawValue: event.identifier) else { return }
        
        switch sectionIdentifier {
        case .leftImagePicker:
            textComponentSubject.value.leftImage = event.isOn ? .icChevronrtLine : nil
        case .rightImagePicker:
            textComponentSubject.value.rightImage = event.isOn ? .icChevronrtLine : nil
        case .supportImagePicker:
            textComponentSubject.value.supportImage = event.isOn ? .icChevronrtLine : nil
        case .errorImagePicker:
            textComponentSubject.value.errorImage = event.isOn ? .icChevronrtLine : nil
        default:
             break
        }
    }
    
    private func handlePickerEvent(with event: SDSPickerEvent) {
        guard let sectionIdentifier = SDSTextFieldSectionConverter.SectionIdentifier(rawValue: event.identifier) else {
            return
        }
        
        let imageType = ImageType(rawValue: event.item) ?? .ic_chevronrt_line
        
        switch sectionIdentifier {
        case .themePicker:
            let themeType = ThemeType(rawValue: event.item) ?? .default
            textComponentSubject.value.theme = themeType.value
        case .stylePicker:
            let styleType = StyleType(rawValue: event.item) ?? .filled
            textComponentSubject.value.style = styleType.value
        case .sizePicker:
            let sizeType = SizeType(rawValue: event.item) ?? .large
            textComponentSubject.value.size = sizeType.value
        case .leftImagePicker:
            textComponentSubject.value.leftImage = imageType.image
        case .rightImagePicker:
            textComponentSubject.value.rightImage = imageType.image
        case .supportImagePicker:
            textComponentSubject.value.supportImage = imageType.image
        case .errorImagePicker:
            textComponentSubject.value.errorImage = imageType.image
        default:
            break
        }
    }
    
    private func handleUserInputEvent(with event: SDSChangeUserInputEvent) {
        guard let sectionIdentifier = SDSTextFieldSectionConverter.SectionIdentifier(rawValue: event.identifier) else {
            return
        }
        
        switch sectionIdentifier {
        case .titleInput:
            textComponentSubject.value.title = event.text
        case .supportInput:
            textComponentSubject.value.supportText = event.text
        case .errorInput:
            textComponentSubject.value.isError = !event.text.isEmpty
            textComponentSubject.value.errorText = event.text
        default:
            break
        }
    }
}

//MARK: - Theme
extension SDSTextFieldViewController {
    enum ThemeType: String, CaseIterable {
        case `default`
        case violet
        case green
        
        var value: TextFieldThemeType {
            switch self {
            case .default:
                return .default
            case .violet:
                return .purple
            case .green:
                return .pink
            }
        }
        
        static func toThemeType(with themeType: TextFieldThemeType) -> ThemeType {
            switch themeType {
            case .default:
                return .default
            case .pink:
                return .green
            case .purple:
                return .violet
            }
        }
    }
}

//MARK: - Style
extension SDSTextFieldViewController {
    enum StyleType: String, CaseIterable {
        case filled
        case outline
        
        var value: BaseTextField.Variant {
            switch self {
            case .filled:
                return .filled
            case .outline:
                return .outline
            }
        }
        
        static func toStyleType(with style: BaseTextField.Variant) -> StyleType {
            switch style {
            case .filled:
                return .filled
            case .outline:
                return .outline
            }
        }
    }
}

//MARK: - Size
extension SDSTextFieldViewController {
    enum SizeType: String, CaseIterable {
        case large
        case medium
        case small
        
        var value: BaseTextField.Size {
            switch self {
            case .large:
                return .large
            case .medium:
                return .medium
            case .small:
                return .small
            }
        }
        
        static func toSizeType(with size: BaseTextField.Size) -> SizeType
        {
            switch size {
            case .large:
                return .large
            case .medium:
                return .medium
            case .small:
                return .small
            }
        }
    }
}

//MARK: - Image
extension SDSTextFieldViewController {
    enum ImageType: String, CaseIterable {
        case ic_chevronrt_line
        case ic_chevrondn_line
        case ic_chevronlf_line
        case ic_chevronup_line
        
        var image: UIImage? {
            switch self {
            case .ic_chevronup_line:
                return UIImage(named: "ic_chevronup_line")
            case .ic_chevrondn_line:
                return UIImage(named: "ic_chevrondn_line")
            case .ic_chevronlf_line:
                return UIImage(named: "ic_chevronlf_line")
            case .ic_chevronrt_line:
                return UIImage(named: "ic_chevronrt_line")
            }
        }
        
        static func toImageType(with image: UIImage?) -> ImageType {
            guard let image = image else {
                return .ic_chevronrt_line
            }
               
               // 이미지 데이터와 비교
               for type in ImageType.allCases {
                   if let typeImage = type.image,
                      typeImage.pngData() == image.pngData() {
                       return type
                   }
               }
               
            return .ic_chevronrt_line // 매칭되는 ImageType이 없으면 nil 반환
        }
    }
}
