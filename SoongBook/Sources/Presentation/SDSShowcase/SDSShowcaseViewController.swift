//
//  SDSShowcaseViewController.swift
//  SoongBook
//
//  Created by 이숭인 on 11/11/24.
//

import UIKit
import SnapKit
import Then
import Combine

final class SDSShowcaseView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setupSubviews() {
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SDSShowcaseViewController {
    private enum ComponentIdentifier {
        static let foundationTypography = "foundation_typography"
        static let foundationIcon = "foundation_icon"
        static let foundationColor = "foundation_color"
        
        static let atomLabel = "atom_sds_label"
        static let atomButton = "atom_sds_button"
        static let atomTextField = "atom_sds_textField"
        
        static let componentSearchBar = "component_searchBar"
        static let componentToast = "component_toast"
        
        static let componentPlayground = "component_playground"
    }
}

final class SDSShowcaseViewController: ViewController<SDSShowcaseView> {
    var cancellables = Set<AnyCancellable>()
    
    let foundationComponents: [SDSShowcaseMenuComponent] = [
        SDSShowcaseMenuComponent(
            identifier: ComponentIdentifier.foundationTypography,
            title: "Typography"
        ),
        SDSShowcaseMenuComponent(
            identifier: ComponentIdentifier.foundationIcon,
            title: "Icon"
        ),
        SDSShowcaseMenuComponent(
            identifier: ComponentIdentifier.foundationColor,
            title: "Color"
        )
    ]
    
    let atomComponents: [SDSShowcaseMenuComponent] = [
        SDSShowcaseMenuComponent(
            identifier: ComponentIdentifier.atomLabel,
            title: "Label"
        ),
        SDSShowcaseMenuComponent(
            identifier: ComponentIdentifier.atomButton,
            title: "Button"
        ),
        SDSShowcaseMenuComponent(
            identifier: ComponentIdentifier.atomTextField,
            title: "TextField"
        ),
    ]
    
    let componentComponents: [SDSShowcaseMenuComponent] = [
        SDSShowcaseMenuComponent(
            identifier: ComponentIdentifier.componentSearchBar,
            title: "SearchBar ( SDSButton + SDSTextField )"
        ),
        SDSShowcaseMenuComponent(
            identifier: ComponentIdentifier.componentToast,
            title: "Toast ( SDSButton + SDSLabel )"
        )
    ]
    
    let playgroundComponents: [SDSShowcaseMenuComponent] = [
        SDSShowcaseMenuComponent(
            identifier: ComponentIdentifier.componentPlayground,
            title: "Component Playground"
        )
    ]
    
    var sections: [SectionModelType] {
        let foundationHeaderComponent = SDSShowcaseHeaderComponent(identifier: "foundation_header", title: "Foundation")
        let foundationSections = SectionModel(
            identifier: "foundation_section",
            header: foundationHeaderComponent,
            itemModels: foundationComponents
        )
        
        let atomHeaderComponent = SDSShowcaseHeaderComponent(identifier: "atom_header", title: "Atom")
        let atomSections = SectionModel(
            identifier: "atom_section",
            header: atomHeaderComponent,
            itemModels: atomComponents
        )
        let componentHeaderComponent = SDSShowcaseHeaderComponent(
            identifier: "component_header",
            title: "Component"
        )
        let componentSections = SectionModel(
            identifier: "component_section",
            header: componentHeaderComponent,
            itemModels: componentComponents
        )
        
        let playgroundHeaderComponent = SDSShowcaseHeaderComponent(
            identifier: "component_playground_header",
            title: "Playground"
        )
        
        let playgroundSections = SectionModel(
            identifier: "component_playground_section",
            header: playgroundHeaderComponent,
            itemModels: playgroundComponents
        )
        
        return [foundationSections] + [atomSections] + [componentSections] + [playgroundSections]
    }
    
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.title = "Showcase Menu"
        
        // Appearance 객체 생성
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 불투명한 배경으로 설정
        
        
        // 타이틀 텍스트와 색상 설정
        appearance.titleTextAttributes = [
            .font: SDSTypographyToken.Title.small.font,
            .foregroundColor: SDSColorToken.Text.grayPrimary.color
        ]
        
        appearance.buttonAppearance.normal.titleTextAttributes = [
            .foregroundColor: SDSColorToken.Text.grayPrimary.color
        ]
        
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: SDSColorToken.Text.grayPrimary.color
        ]
        
        // 배경색 설정
        appearance.backgroundColor = UIColor.gray100
        
        // 그림자 설정
        appearance.shadowColor = UIColor.gray900
//        appearance.shadowImage = nil  기본 그림자를 사용하지 않으려면 nil로 설정
        
        // Standard, Scroll Edge Appearance 설정
        navigationController?.navigationBar.tintColor = UIColor.gray900
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func bind() {
        Just(sections)
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        adapter.actionEventPublisher
            .sink { [weak self] action in
                switch action {
                case let action as SDSShowcaseMenuAction:
                    self?.moveToDetailIfNeeded(with: action.identifier)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func moveToDetailIfNeeded(with identifier: String) {
        switch identifier {
        case ComponentIdentifier.foundationTypography:
            let typoVC = SDSTypographyViewController()
            
            navigationController?.pushViewController(typoVC, animated: true)
        case ComponentIdentifier.foundationIcon:
            let iconVC = SDSIconViewController()
            
            navigationController?.pushViewController(iconVC, animated: true)
        case ComponentIdentifier.foundationColor:
            let colorVC = SDSColorViewController()
            
            navigationController?.pushViewController(colorVC, animated: true)
        case ComponentIdentifier.atomLabel:
            let labelVC = SDSLabelViewController()
            
            navigationController?.pushViewController(labelVC, animated: true)
        case ComponentIdentifier.atomButton:
            let buttonVC = SDSButtonViewController()
            
            navigationController?.pushViewController(buttonVC, animated: true)
        case ComponentIdentifier.atomTextField:
            let textFieldVC = SDSTextFieldViewController()
            
            navigationController?.pushViewController(textFieldVC, animated: true)
        case ComponentIdentifier.componentSearchBar:
            let searchbarComponentVC = SDSSearchBarViewController()
            
            navigationController?.pushViewController(searchbarComponentVC, animated: true)
        case ComponentIdentifier.componentToast:
            let toastComponentVC = ToastShowcaseViewController()
            
            navigationController?.pushViewController(toastComponentVC, animated: true)
        case ComponentIdentifier.componentPlayground:
            let componentPlaygroundVC = SDSComponentPlaygroundViewController()
            
            navigationController?.pushViewController(componentPlaygroundVC, animated: true)
        default:
            break
        }
        
    }
}
