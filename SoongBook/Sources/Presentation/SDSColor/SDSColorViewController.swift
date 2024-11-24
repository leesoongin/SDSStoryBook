//
//  SDSColorViewController.swift
//  SoongBook
//
//  Created by 이숭인 on 11/14/24.
//

import UIKit
import Combine
import SnapKit
import Then

final class SDSColorView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setup() {
        super.setup()
        
        backgroundColor = .white000
    }
    
    override func setupSubviews() {
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

final class SDSColorViewController: ViewController<SDSColorView> {
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView).then {
        $0.pinToVisibleBoundsSectionHeader()
    }
    private var cancellables = Set<AnyCancellable>()
    
    let colors: [any ColorProvidable.Type] = [
        GrayColor.self,
        BrownColor.self,
        EmeraldColor.self,
        RedColor.self,
        GreenColor.self,
        VioletColor.self
    ]
    
    var colorSections: [SectionModelType] {
        colors.flatMap { colorType -> [SectionModelType] in
            let header = SDSColorHeaderComponent(identifier: colorType.category, title: colorType.category)
            let components: [SDSColorComponent] = colorType.allCases.compactMap { colorCase in
                guard let colorCase = colorCase as? (any ColorProvidable) else { return nil }
                return SDSColorComponent(
                    identifier: colorCase.rawValue,
                    color: colorCase.color,
                    title: colorCase.rawValue
                )
            }
            
            let section = SectionModel(
                identifier: colorType.category,
                header: header,
                itemModels: components
            )
            
            return [section]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        Just(colorSections)
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
    }
}



extension SDSColorViewController {
    protocol ColorProvidable: CaseIterable {
        var color: UIColor { get }
        var rawValue: String { get }
        static var category: String { get set }
    }
    
    enum BrownColor: String, ColorProvidable {
        case brown050
        case brown100
        case brown200
        case brown300
        case brown400
        case brown500
        case brown600
        case brown700
        case brown800
        
        static var category: String = "Brown"
        
        var color: UIColor {
            switch self {
            case .brown050: return .brown050
            case .brown100: return .brown100
            case .brown200: return .brown200
            case .brown300: return .brown300
            case .brown400: return .brown400
            case .brown500: return .brown500
            case .brown600: return .brown600
            case .brown700: return .brown700
            case .brown800: return .brown800
            }
        }
    }
    
    enum EmeraldColor: String, ColorProvidable {
        case emerald050
        case emerald100
        case emerald200
        case emerald300
        case emerald400
        case emerald500
        case emerald600
        case emerald700
        case emerald800

        static var category: String = "Emerald"
        
        var color: UIColor {
            switch self {
            case .emerald050: return .emerald050
            case .emerald100: return .emerald100
            case .emerald200: return .emerald200
            case .emerald300: return .emerald300
            case .emerald400: return .emerald400
            case .emerald500: return .emerald500
            case .emerald600: return .emerald600
            case .emerald700: return .emerald700
            case .emerald800: return .emerald800
            }
        }
    }

    enum GrayColor: String, ColorProvidable {
        case gray050
        case gray100
        case gray200
        case gray300
        case gray400
        case gray500
        case gray600
        case gray700
        case gray800
        
        static var category: String = "Gray"

        var color: UIColor {
            switch self {
            case .gray050: return .gray050
            case .gray100: return .gray100
            case .gray200: return .gray200
            case .gray300: return .gray300
            case .gray400: return .gray400
            case .gray500: return .gray500
            case .gray600: return .gray600
            case .gray700: return .gray700
            case .gray800: return .gray800
            }
        }
    }

    enum GreenColor: String, ColorProvidable {
        case green050
        case green100
        case green200
        case green300
        case green400
        case green500
        case green600
        case green700
        case green800
        
        static var category: String = "Green"

        var color: UIColor {
            switch self {
            case .green050: return .green050
            case .green100: return .green100
            case .green200: return .green200
            case .green300: return .green300
            case .green400: return .green400
            case .green500: return .green500
            case .green600: return .green600
            case .green700: return .green700
            case .green800: return .green800
            }
        }
    }

    enum RedColor: String, ColorProvidable {
        case red050
        case red100
        case red200
        case red300
        case red400
        case red500
        case red600
        case red700
        case red800

        static var category: String = "Red"
        
        var color: UIColor {
            switch self {
            case .red050: return .red050
            case .red100: return .red100
            case .red200: return .red200
            case .red300: return .red300
            case .red400: return .red400
            case .red500: return .red500
            case .red600: return .red600
            case .red700: return .red700
            case .red800: return .red800
            }
        }
    }

    enum VioletColor: String, ColorProvidable {
        case violet050
        case violet100
        case violet200
        case violet300
        case violet400
        case violet500
        case violet600
        case violet700
        case violet800

        static var category: String = "Violet"
        
        var color: UIColor {
            switch self {
            case .violet050: return .violet050
            case .violet100: return .violet100
            case .violet200: return .violet200
            case .violet300: return .violet300
            case .violet400: return .violet400
            case .violet500: return .violet500
            case .violet600: return .violet600
            case .violet700: return .violet700
            case .violet800: return .violet800
            }
        }
    }

}
//{
//    let grayComponents = GrayColor.allCases.map { colorType in
//        SDSColorComponent(
//            identifier: colorType.rawValue,
//            color: colorType.color,
//            title: colorType.rawValue
//        )
//    }
//    
//    let brownComponents = BrownColor.allCases.map { colorType in
//        SDSColorComponent(
//            identifier: colorType.rawValue,
//            color: colorType.color,
//            title: colorType.rawValue
//        )
//    }
//
//    let emeraldComponents = EmeraldColor.allCases.map { colorType in
//        SDSColorComponent(
//            identifier: colorType.rawValue,
//            color: colorType.color,
//            title: colorType.rawValue
//        )
//    }
//
//    let redComponents = RedColor.allCases.map { colorType in
//        SDSColorComponent(
//            identifier: colorType.rawValue,
//            color: colorType.color,
//            title: colorType.rawValue
//        )
//    }
//
//    let greenComponents = GreenColor.allCases.map { colorType in
//        SDSColorComponent(
//            identifier: colorType.rawValue,
//            color: colorType.color,
//            title: colorType.rawValue
//        )
//    }
//
//    let violetComponents = VioletColor.allCases.map { colorType in
//        SDSColorComponent(
//            identifier: colorType.rawValue,
//            color: colorType.color,
//            title: colorType.rawValue
//        )
//    }
//
//    
//    return grayComponents + brownComponents + emeraldComponents + redComponents + greenComponents + violetComponents
//}
