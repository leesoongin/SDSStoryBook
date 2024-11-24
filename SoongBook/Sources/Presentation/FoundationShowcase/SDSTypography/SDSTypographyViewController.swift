//
//  ViewController.swift
//  SoongBook
//
//  Created by 이숭인 on 11/4/24.
//

import UIKit
import Combine
import SnapKit
import Then

final class SDSTypographyView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setup() {
        super.setup()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionInsetReference = .fromSafeArea
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

class SDSTypographyViewController: ViewController<SDSTypographyView> {
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
    }
    
    private func bindAction() {
        Just(createSections())
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
    }
    
    private func createSections() -> [SectionModelType] {
        var sections: [SectionModelType] = []
        
        sections.append(contentsOf: createTypographySection(
            with: [.xlargeTitle, .largeTitle, .mediumTitle, .smallTitle, .xsmallTitle],
            sectionTitle: "Title",
            sectionIdentifier: "title_typo_section",
            headerIdentifier: "title_typo_section_header")
        )
        
        sections.append(contentsOf: createTypographySection(
            with: [.xlargeSubTitle, .largeSubTitle, .mediumSubTitle, .smallSubTitle, .xsmallSubTitle],
            sectionTitle: "SubTitle",
            sectionIdentifier: "sub_title_typo_section",
            headerIdentifier: "sub_title_typo_section_header")
        )
        
        sections.append(contentsOf: createTypographySection(
            with: [.xlargeBody, .largeBody, .mediumBody, .smallBody, .xsmallBody],
            sectionTitle: "Body",
            sectionIdentifier: "body_typo_section",
            headerIdentifier: "body_typo_section_header")
        )
        
        sections.append(contentsOf: createTypographySection(
            with: [.xlargeMediumButton, .largeMediumButton, .mediumMediumButton, .smallMediumButton, .xsmallMediumButton],
            sectionTitle: "ButtonMedium",
            sectionIdentifier: "button_medium_typo_section",
            headerIdentifier: "button_medium_typo_section_header")
        )
        
        sections.append(contentsOf: createTypographySection(
            with: [.xlargeSemiboldButton, .largeSemiboldButton, .mediumSemiboldButton, .smallSemiboldButton, .xsmallSemiboldButton],
            sectionTitle: "ButtonSemibold",
            sectionIdentifier: "button_semibold_typo_section",
            headerIdentifier: "button_semibold_typo_section_header")
        )
        
        return sections
    }
    
    private func createTypographySection(with typoStyles: [SDSTypographyToken], sectionTitle: String, sectionIdentifier: String, headerIdentifier: String) -> [SectionModelType] {
        let header = TypographyHeaderComponent(identifier: headerIdentifier, title: sectionTitle)
        
        let components: [TypographyComponent] = typoStyles.map {
            TypographyComponent(
                identifier: UUID().uuidString,
                typographyToken: $0,
                textColorStyle: .grayPrimary
            )
        }
        
        let section = SectionModel(
            identifier: sectionIdentifier,
            header: header,
            itemModels: components
        )
        
        return [section]
    }

}
