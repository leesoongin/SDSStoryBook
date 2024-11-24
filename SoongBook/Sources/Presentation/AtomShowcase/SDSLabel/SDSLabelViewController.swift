//
//  SDSLabelViewController.swift
//  SoongBook
//
//  Created by 이숭인 on 11/14/24.
//

import UIKit
import SnapKit
import Then
import Combine

final class SDSLabelView: BaseView {
    let contentCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: UICollectionViewFlowLayout())
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

final class SDSLabelViewController: ViewController<SDSLabelView> {
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var contentAdapter = CollectionViewAdapter(with: contentView.contentCollectionView)
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView).then {
        $0.pinToVisibleBoundsSectionHeader()
    }
    private let converter = SDSLabelSectionConverter()
    
    private let labelModelPublisher = CurrentValueSubject<SDSLabelComponentModel, Never>(SDSLabelComponentModel(
        text: "Label",
        typoStyle: .largeTitle,
        textColorStyle: .grayPrimary,
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        alignment: .left)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        labelModelPublisher
            .sink { [weak self] model in
                let component = SDSLabelComponent(
                    identifier: "label_component",
                    componentModel: model
                )
                
                let section = SectionModel(
                    identifier: "label_component_section",
                    itemModels: [component]
                )
                
                _ = self?.contentAdapter.receive([section])
            }
            .store(in: &cancellables)
        
        labelModelPublisher
            .sink { [weak self] model in
                let sections = self?.converter.createSections(
                    with: model,
                    typoMenus: TypographyMenu.allCases,
                    numberOfLinesMenus: NumberOfLinesMenu.allCases,
                    lineBreakModelMenus: LineBreakModeMenu.allCases,
                    textAlignmentMenus: AlignmentMenu.allCases
                )
                
                _ = self?.adapter.receive(sections ?? [])
            }
            .store(in: &cancellables)
            
        adapter.actionEventPublisher
            .sink { [weak self] action in
                switch action {
                case let action as SDSPickerEvent:
                    switch action.item {
                    case let item where TypographyMenu(rawValue: action.item).isNotNil:
                        let menu = TypographyMenu(rawValue: item) ?? .largeTitle
                        self?.labelModelPublisher.value.typoStyle = menu.typo
                    case let item where NumberOfLinesMenu(rawValue: item).isNotNil:
                        let menu = NumberOfLinesMenu(rawValue: item) ?? .zero
                        self?.labelModelPublisher.value.numberOfLines = menu.value
                    case let item where LineBreakModeMenu(rawValue: item).isNotNil:
                        let menu = LineBreakModeMenu(rawValue: item) ?? .byWordWrapping
                        self?.labelModelPublisher.value.lineBreakMode = menu.value
                    case let item where AlignmentMenu(rawValue: item).isNotNil:
                        let menu = AlignmentMenu(rawValue: item) ?? .center
                        self?.labelModelPublisher.value.alignment = menu.value
                    default:
                        break
                    }
                case let action as SDSChangeUserInputEvent:
                    self?.labelModelPublisher.value.text = action.text
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - alignment
extension SDSLabelViewController {
    enum AlignmentMenu: String, CaseIterable {
        case left
        case center
        case right 
        case justified
        case natural
        
        var value: NSTextAlignment {
            switch self {
            case .left:
                return .left
            case .center:
                return .center
            case .right:
                return .right
            case .justified:
                return .justified
            case .natural:
                return .natural
            }
        }
        
        static func toAlignmentMenu(with alignment: NSTextAlignment) -> AlignmentMenu {
            switch alignment {
            case .left:
                return .left
            case .center:
                return .center
            case .right:
                return .right
            case .justified:
                return .justified
            case .natural:
                return .natural
            default:
                return .natural
            }
        }
    }
}

//MARK: - LineBreakMode
extension SDSLabelViewController {
    enum LineBreakModeMenu: String, CaseIterable {
        case byWordWrapping
        case byCharWrapping
        case byClipping
        case byTruncatingHead
        case byTruncatingMiddle
        case byTruncatingTail
        
        var value: NSLineBreakMode {
            switch self {
            case .byWordWrapping:
                return .byWordWrapping
            case .byCharWrapping:
                return .byCharWrapping
            case .byClipping:
                return .byClipping
            case .byTruncatingHead:
                return .byTruncatingHead
            case .byTruncatingMiddle:
                return .byTruncatingMiddle
            case .byTruncatingTail:
                return .byTruncatingTail
            }
        }
        
        static func toLineBreakModeMenu(with breakMode: NSLineBreakMode) -> LineBreakModeMenu {
            switch breakMode {
            case .byWordWrapping:
                return .byWordWrapping
            case .byCharWrapping:
                return .byCharWrapping
            case .byClipping:
                return .byClipping
            case .byTruncatingHead:
                return .byTruncatingHead
            case .byTruncatingTail:
                return .byTruncatingTail
            case .byTruncatingMiddle:
                return .byTruncatingMiddle
            default:
                return .byTruncatingTail
            }
        }
    }
}

//MARK: - NumberOfLines
extension SDSLabelViewController {
    enum NumberOfLinesMenu: String, CaseIterable {
        case zero = "0"
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        
        var value: Int {
            switch self {
            case .zero:
                return 0
            case .one:
                return 1
            case .two:
                return 2
            case .three:
                return 3
            case .four:
                return 4
            case .five:
                return 5
            }
        }
        
        static func toMenu(with numberOfLines: Int) -> NumberOfLinesMenu {
            switch numberOfLines {
            case 0:
                return .zero
            case 1:
                return .one
            case  2:
                return .two
            case 3:
                return .three
            case 4:
                return .four
            case 5:
                return .five
            default:
                return .zero
            }
        }
    }
}

//MARK: - TypographyMenu
extension SDSLabelViewController {
    enum TypographyMenu: String, CaseIterable {
        // title
        case xlargeTitle
        case largeTitle
        case mediumTitle
        case smallTitle
        case xsmallTitle
        
        // subtitle
        case xlargeSubTitle
        case largeSubTitle
        case mediumSubTitle
        case smallSubTitle
        case xsmallSubTitle
        
        // body
        case xlargeBody
        case largeBody
        case mediumBody
        case smallBody
        case xsmallBody
        
        // semiboldButtonTitle
        case xlargeSemiboldButton
        case largeSemiboldButton
        case mediumSemiboldButton
        case smallSemiboldButton
        case xsmallSemiboldButton
        
        // mediumButtonTitle
        case xlargeMediumButton
        case largeMediumButton
        case mediumMediumButton
        case smallMediumButton
        case xsmallMediumButton
        
        var typo: SDSTypographyToken {
            switch self {
                // Title
            case .xlargeTitle: return .xlargeTitle
            case .largeTitle: return .largeTitle
            case .mediumTitle: return .mediumTitle
            case .smallTitle: return .smallTitle
            case .xsmallTitle: return .xsmallTitle
                
                // SubTitle
            case .xlargeSubTitle: return .xlargeSubTitle
            case .largeSubTitle: return .largeSubTitle
            case .mediumSubTitle: return .mediumSubTitle
            case .smallSubTitle: return .smallSubTitle
            case .xsmallSubTitle: return .xsmallSubTitle
                
                // Body
            case .xlargeBody: return .xlargeBody
            case .largeBody: return .largeBody
            case .mediumBody: return .mediumBody
            case .smallBody: return .smallBody
            case .xsmallBody: return .xsmallBody
                
                // SemiboldButtonTitle
            case .xlargeSemiboldButton: return .xlargeSemiboldButton
            case .largeSemiboldButton: return .largeSemiboldButton
            case .mediumSemiboldButton: return .mediumSemiboldButton
            case .smallSemiboldButton: return .smallSemiboldButton
            case .xsmallSemiboldButton: return .xsmallSemiboldButton
                
                // MediumButtonTitle
            case .xlargeMediumButton: return .xlargeMediumButton
            case .largeMediumButton: return .largeMediumButton
            case .mediumMediumButton: return .mediumMediumButton
            case .smallMediumButton: return .smallMediumButton
            case .xsmallMediumButton: return .xsmallMediumButton
            }
        }
        
        static func tokenToTypoMenu(with typoToken: SDSTypographyToken) -> TypographyMenu {
            switch typoToken {
                // Title
            case .xlargeTitle: return .xlargeTitle
            case .largeTitle: return .largeTitle
            case .mediumTitle: return .mediumTitle
            case .smallTitle: return .smallTitle
            case .xsmallTitle: return .xsmallTitle
                
                // SubTitle
            case .xlargeSubTitle: return .xlargeSubTitle
            case .largeSubTitle: return .largeSubTitle
            case .mediumSubTitle: return .mediumSubTitle
            case .smallSubTitle: return .smallSubTitle
            case .xsmallSubTitle: return .xsmallSubTitle
                
                // Body
            case .xlargeBody: return .xlargeBody
            case .largeBody: return .largeBody
            case .mediumBody: return .mediumBody
            case .smallBody: return .smallBody
            case .xsmallBody: return .xsmallBody
                
                // SemiboldButtonTitle
            case .xlargeSemiboldButton: return .xlargeSemiboldButton
            case .largeSemiboldButton: return .largeSemiboldButton
            case .mediumSemiboldButton: return .mediumSemiboldButton
            case .smallSemiboldButton: return .smallSemiboldButton
            case .xsmallSemiboldButton: return .xsmallSemiboldButton
                
                // MediumButtonTitle
            case .xlargeMediumButton: return .xlargeMediumButton
            case .largeMediumButton: return .largeMediumButton
            case .mediumMediumButton: return .mediumMediumButton
            case .smallMediumButton: return .smallMediumButton
            case .xsmallMediumButton: return .xsmallMediumButton
            }
        }
    }
}
