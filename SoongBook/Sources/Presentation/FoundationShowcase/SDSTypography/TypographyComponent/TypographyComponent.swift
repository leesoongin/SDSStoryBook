//
//  TypographyComponent.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import UIKit
import SnapKit
import Then
import Combine

extension TypographyComponent {
    enum TypoInfo: String, CaseIterable {
        case size
        case weight
        case lineHeight
    }
}

struct TypographyComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .adaptive
    
    var identifier: String
    let typoInfo: [TypoInfo] = [.size, .weight, .lineHeight]
    
    let typographyToken: SDSTypographyToken
    let textColorStyle: SDSColorToken.Text
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(typographyToken)
        hasher.combine(textColorStyle)
    }
    
    func prepareForReuse(content: TypographyView) {
        content.typoInfomationStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        content.typoContainer.subviews.last?.removeFromSuperview()
    }
}

extension TypographyComponent {
    typealias ContentType = TypographyView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(typoToken: context.typographyToken, colorStyle: context.textColorStyle, typoInfo: context.typoInfo)
    }
}

final class TypographyView: BaseView {
    let container = UIView()
    
    let typoContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
    }
    let refTypoNameLabel = SDSLabel(typography: Constants.referenceTokenNameTypo)
    let sysTypoNameLabel = SDSLabel(typography: Constants.systemTokenNameTypo)
    
    let divider = UIView().then {
        $0.backgroundColor = SDSColorToken.Background.greenPrimary.color
    }
    
    let typoInfomationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = SDSColorToken.Background.greenTinted.color
    }
    
    override func setup() {
        super.setup()
        
        typoContainer.setCustomSpacing(16, after: sysTypoNameLabel)
        typoContainer.setCustomSpacing(16, after: divider)
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(typoContainer)
        typoContainer.addArrangedSubview(sysTypoNameLabel)
        typoContainer.addArrangedSubview(divider)
        
        container.addSubview(typoInfomationStackView)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        typoContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        typoInfomationStackView.snp.makeConstraints { make in
            make.top.equalTo(typoContainer.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func bind(typoToken: SDSTypographyToken, colorStyle: SDSColorToken.Text, typoInfo: [TypographyComponent.TypoInfo]) {
        let newTypo = Typography(token: typoToken, colorStyle: colorStyle, applyLineHeight: true)
        let contentLabel = SDSLabel(typography: newTypo)
        contentLabel.text = "안녕하세요."
        typoContainer.addArrangedSubview(contentLabel)
        
        sysTypoNameLabel.text = getSystemTypoName(with: typoToken)
        
        addTypographyInfomationView(with: typoInfo, typoToken: typoToken)
    }
    
    private func addTypographyInfomationView(with typoInfos: [TypographyComponent.TypoInfo],
                     typoToken: SDSTypographyToken) {
        typoInfos.forEach { typoInfo in
            let horizontalStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.alignment = .fill
            }
            let titleLabel = SDSLabel(typography: Typography(token: .mediumBody, colorStyle: .grayPrimary))
            let contentLabel = SDSLabel(typography: Typography(token: .mediumBody, colorStyle: .grayPrimary))
            
            typoInfomationStackView.addArrangedSubview(horizontalStackView)
            horizontalStackView.addArrangedSubview(titleLabel)
            horizontalStackView.addArrangedSubview(contentLabel)
            
            titleLabel.text = typoInfo.rawValue
            
            switch typoInfo {
            case .size:
                let font = Typography.convertTypographyStyleToFont(with: typoToken.style)
                contentLabel.text = "\(font.pointSize)"
            case .weight:
                contentLabel.text = getWeightFromTypo(with: typoToken)
            case .lineHeight:
                let lineHeight = Typography.convertTypographyStyleToLineHeight(with: typoToken.style)
                contentLabel.text = "\(lineHeight)"
            }
        }
    }
    
    private func getWeightFromTypo(with typoToken: SDSTypographyToken) -> String {
        switch typoToken {
        case .xlargeTitle, .largeTitle, .mediumTitle, .smallTitle, .xsmallTitle: return "Bold"
        case .xlargeSubTitle, .largeSubTitle, .mediumSubTitle, .smallSubTitle, .xsmallSubTitle: return "Semibold"
        case .xlargeBody, .largeBody, .mediumBody, .smallBody, .xsmallBody: return "regular"
        case .xlargeSemiboldButton, .largeSemiboldButton, .mediumSemiboldButton, .smallSemiboldButton, .xsmallSemiboldButton: return "Semibold"
        case .xlargeMediumButton, .largeMediumButton, .mediumMediumButton, .smallMediumButton, .xsmallMediumButton: return "Medium"
        }
    }
    
    private func getSystemTypoName(with typoToken: SDSTypographyToken) -> String {
        switch typoToken {
        case .xlargeTitle: return "xlargeTitle"
        case .largeTitle: return "largeTitle"
        case .mediumTitle: return "mediumTitle"
        case .smallTitle: return "smallTitle"
        case .xsmallTitle: return "xsmallTitle"
        case .xlargeSubTitle: return "xlargeSubTitle"
        case .largeSubTitle: return "largeSubTitle"
        case .mediumSubTitle: return "mediumSubTitle"
        case .smallSubTitle: return "smallSubTitle"
        case .xsmallSubTitle: return "xsmallSubTitle"
        case .xlargeBody: return "xlargeBody"
        case .largeBody: return "largeBody"
        case .mediumBody: return "mediumBody"
        case .smallBody: return "smallBody"
        case .xsmallBody: return "xsmallBody"
        case .xlargeSemiboldButton: return "xlargeSemiboldButton"
        case .largeSemiboldButton: return "largeSemiboldButton"
        case .mediumSemiboldButton: return "mediumSemiboldButton"
        case .smallSemiboldButton: return "smallSemiboldButton"
        case .xsmallSemiboldButton: return "xsmallSemiboldButton"
        case .xlargeMediumButton: return "xlargeMediumButton"
        case .largeMediumButton: return "largeMediumButton"
        case .mediumMediumButton: return "mediumMediumButton"
        case .smallMediumButton: return "smallMediumButton"
        case .xsmallMediumButton: return "xsmallMediumButton"
        }
    }
    
    private func getReferenceTypoName(with typoToken: SDSTypographyToken) -> String {
        switch typoToken {
        case .xlargeTitle: return "title32"
        case .largeTitle: return "title28"
        case .mediumTitle: return "title26"
        case .smallTitle: return "title24"
        case .xsmallTitle: return "xsmallTitltitlr20"
        case .xlargeSubTitle: return "subTitle24"
        case .largeSubTitle: return "subTitle22"
        case .mediumSubTitle: return "subTitle20"
        case .smallSubTitle: return "subTitle18"
        case .xsmallSubTitle: return "subTitle16"
        case .xlargeBody: return "body20"
        case .largeBody: return "body18"
        case .mediumBody: return "body16"
        case .smallBody: return "body14"
        case .xsmallBody: return "body12"
        case .xlargeSemiboldButton: return "buttonSemibold20"
        case .largeSemiboldButton: return "buttonSemibold18"
        case .mediumSemiboldButton: return "buttonSemibold16"
        case .smallSemiboldButton: return "buttonSemibold14"
        case .xsmallSemiboldButton: return "buttonSemibold12"
        case .xlargeMediumButton: return "buttonMedium20"
        case .largeMediumButton: return "buttonMedium18"
        case .mediumMediumButton: return "buttonMedium16"
        case .smallMediumButton: return "buttonMedium14"
        case .xsmallMediumButton: return "buttonMedium12"
        }
    }
}


extension TypographyView {
    private enum Constants {
        static let systemTokenNameTypo = Typography(token: .mediumSubTitle, colorStyle: .grayPrimary)
        static let referenceTokenNameTypo = Typography(token: .smallSubTitle, colorStyle: .grayPrimary)
    }
}
