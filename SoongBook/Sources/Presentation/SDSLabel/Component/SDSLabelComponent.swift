//
//  SDSLabelComponent.swift
//  SoongBook
//
//  Created by 이숭인 on 11/15/24.
//

import UIKit
import Combine
import SnapKit
import Then

struct SDSLabelComponentModel: Hashable {
    var text: String
    var typoStyle: SDSTypographyToken
    var textColorStyle: SDSColorToken.Text
    var numberOfLines: Int
    
    var lineBreakMode: NSLineBreakMode
    var alignment: NSTextAlignment
}

struct SDSLabelComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .ratioWithCollectionView(1.0)
    
    var identifier: String
    let componentModel: SDSLabelComponentModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(componentModel)
    }
}

extension SDSLabelComponent {
    typealias ContentType = SDSLabelComponentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(with: context.componentModel)
    }
}

final class SDSLabelComponentView: BaseView {
    let itemLabel = SDSLabel(typography: Constants.itemTypo)
    let bottomDivider = UIView().then {
        $0.backgroundColor = .gray300
    }
    
    override func setup() {
        super.setup()
        
        backgroundColor = .white000
    }
    
    override func setupSubviews() {
        addSubview(itemLabel)
        addSubview(bottomDivider)
    }
    
    override func setupConstraints() {
        itemLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.greaterThanOrEqualToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        bottomDivider.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func bind(with model: SDSLabelComponentModel) {
        let newTypo = Typography(
            token: model.typoStyle,
            colorStyle: model.textColorStyle,
            alignment: model.alignment
        )
        
        itemLabel.applyTypography(with: newTypo)
        
        itemLabel.text = model.text
        itemLabel.numberOfLines = model.numberOfLines
        itemLabel.lineBreakMode = model.lineBreakMode
    }
}

extension SDSLabelComponentView {
    private enum Constants {
        static let itemTypo = Typography(token: .largeTitle, colorStyle: .grayPrimary)
    }
}
