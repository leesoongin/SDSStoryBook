//
//  SDSButtonViewController.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import UIKit
import SnapKit
import Then
import Combine

final class SDSButtonView: BaseView {
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

final class SDSButtonViewController: ViewController<SDSButtonView> {
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    private lazy var contentAdapter = CollectionViewAdapter(with: contentView.contentCollectionView)
    
    private let converter = SDSButtonSectionConverter()
    
    private let componentSubject = CurrentValueSubject<SDSButtonComponentModel, Never>(SDSButtonComponentModel(
        theme: .purple,
        variant: .primary,
        style: .filled,
        size: .large,
        state: .enabled,
        shape: .default,
        buttonText: "Button",
        leftIcon: nil,
        rightIcon: nil)
    )
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        componentSubject
            .sink { [weak self] model in
                let component = SDSButtonComponent(
                    identifier: "button_component",
                    componentModel: model
                )
                
                let section = SectionModel(
                    identifier: "button_component_section",
                    itemModels: [component]
                )
                
                _ = self?.contentAdapter.receive([section])
            }
            .store(in: &cancellables)
        
        componentSubject
            .sink { [weak self] model in
                let sections = self?.converter.createSections(
                    with: model,
                    iconMenu: SDSButtonViewController.ImageContentType.allCases,
                    themeMenu: SDSButtonViewController.ThemeType.allCases,
                    styleMenu: SDSButtonViewController.StyleType.allCases,
                    stateMenu: SDSButtonViewController.StateType.allCases,
                    variantMenu: SDSButtonViewController.VariantType.allCases,
                    shapeMenu: SDSButtonViewController.ShapeType.allCases
                )
                
                _ = self?.adapter.receive(sections ?? [])
            }
            .store(in: &cancellables)
        
        adapter.actionEventPublisher
            .sink { [weak self] action in
                switch action {
                case let action as SDSPickerSwitchEvent:
                    if action.identifier == "left_icon_picker_component" {
                        self?.componentSubject.value.leftIcon = action.isOn ? .icChevronrtLine : nil
                    } else if action.identifier == "right_icon_picker_component" {
                        self?.componentSubject.value.rightIcon = action.isOn ? .icChevronrtLine : nil
                    }
                case let action as SDSChangeUserInputEvent:
                    self?.componentSubject.value.buttonText = action.text
                case let action as SDSPickerEvent:
                    switch action.item {
                    case let item where ImageContentType(rawValue: item).isNotNil:
                        let menu = ImageContentType(rawValue: item) ?? .ic_chevronrt_line
                        if action.identifier == "left_icon_picker_component" {
                            self?.componentSubject.value.leftIcon = menu.image
                        } else {
                            self?.componentSubject.value.rightIcon = menu.image
                        }
                    case let item where ThemeType(rawValue: item).isNotNil:
                        let theme = ThemeType(rawValue: item) ?? .violet
                        self?.componentSubject.value.theme = theme.value
                    case let item where StyleType(rawValue: item).isNotNil:
                        let style = StyleType(rawValue: item) ?? .filled
                        self?.componentSubject.value.style = style.value
                    case let item where StateType(rawValue: item).isNotNil:
                        let state = StateType(rawValue: item) ?? .enabled
                        self?.componentSubject.value.state = state.value
                    case let item where VariantType(rawValue: item).isNotNil:
                        let variant = VariantType(rawValue: item) ?? .primary
                        self?.componentSubject.value.variant = variant.value
                    case let item where ShapeType(rawValue: item).isNotNil:
                        let shape = ShapeType(rawValue: item) ?? .default
                        self?.componentSubject.value.shape = shape.value
                    default:
                        break
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: Shape
extension SDSButtonViewController {
    enum ShapeType: String, CaseIterable {
        case circle
        case round
        case `default`
        
        var value: SDSButton.Shape {
            switch self {
            case .circle:
                return .circle
            case .round:
                return .round
            case .default:
                return .default
            }
        }
        
        static func toShapeType(with shape: SDSButton.Shape) -> ShapeType {
            switch shape {
            case .default:
                return .default
            case .round:
                return .round
            case .circle:
                return .circle
            }
        }
    }
}

//MARK: State
extension SDSButtonViewController {
    enum StateType: String, CaseIterable {
        case enabled
        case pressed
        case disabled
        
        var value: CommonButton.State {
            switch self {
            case .enabled:
                return .enabled
            case .pressed:
                return .pressed
            case .disabled:
                return .disabled
            }
        }
        
        static func toStateType(with state: CommonButton.State) -> StateType {
            switch state {
            case .enabled:
                return .enabled
            case .disabled:
                return .disabled
            case .pressed:
                return .pressed
            }
        }
    }
}

//MARK: - Variant
extension SDSButtonViewController {
    enum VariantType: String, CaseIterable {
        case primary
        case secondary
        case danger
        
        var value: CommonButton.Variant {
            switch self {
            case .primary:
                return .primary
            case .secondary:
                return .secondary
            case .danger:
                return .danger
            }
        }
        
        static func toVariantType(with variant: CommonButton.Variant) -> VariantType {
            switch variant {
            case .primary:
                return .primary
            case .secondary:
                return .secondary
            case .danger:
                return .danger
            }
        }
    }
}

//MARK: - Style
extension SDSButtonViewController {
    enum StyleType: String, CaseIterable {
        case filled
        case outline
        case goast
        
        var value: CommonButton.Style {
            switch self {
            case .filled:
                return .filled
            case .outline:
                return .outline
            case .goast:
                return .goast
            }
        }
        
        static func toStyleType(with style: CommonButton.Style) -> StyleType {
            switch style {
            case .filled:
                return .filled
            case .outline:
                return .outline
            case .goast:
                return .goast
            }
        }
    }
}

//MARK: - Theme {
extension SDSButtonViewController {
    enum ThemeType: String, CaseIterable {
        case violet
        case green
        
        var value: ButtonThemeType {
            switch self {
            case .green:
                return .pink
            case .violet:
                return .purple
            }
        }
        
        static func toThemeType(with theme: ButtonThemeType) -> ThemeType {
            switch theme {
            case .pink:
                return .green
            case .purple:
                return .violet
            }
        }
    }
}

//MARK: - Image
extension SDSButtonViewController {
    enum ImageContentType: String, CaseIterable {
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
        
        static func toImageType(with image: UIImage?) -> ImageContentType {
            guard let image = image else { return .ic_chevronrt_line }
               
               // 이미지 데이터와 비교
               for type in ImageContentType.allCases {
                   if let typeImage = type.image,
                      typeImage.pngData() == image.pngData() {
                       return type
                   }
               }
               
            return .ic_chevronrt_line // 매칭되는 ImageType이 없으면 nil 반환
        }
    }
}
