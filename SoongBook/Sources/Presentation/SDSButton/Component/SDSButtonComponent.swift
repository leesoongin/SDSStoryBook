//
//  SDSButtonComponent.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import UIKit
import Combine
import SnapKit
import Then

struct SDSButtonComponentModel: Hashable {
    var theme: ButtonThemeType
    var variant: CommonButton.Variant
    var style: CommonButton.Style
    var size: CommonButton.Size
    var state: CommonButton.State
    var shape: SDSButton.Shape
    var buttonText: String
    var leftIcon: UIImage?
    var rightIcon: UIImage?
}

struct SDSButtonComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .static(300)
    
    let identifier: String
    let componentModel: SDSButtonComponentModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(componentModel)
    }
    
    func prepareForReuse(content: SDSButtonComponentView) {
        content.contentStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension SDSButtonComponent {
    typealias ContentType = SDSButtonComponentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(with: context.componentModel)
    }
}

final class SDSButtonComponentView: BaseView {
    let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    let bottomDivider = UIView().then {
        $0.backgroundColor = .gray300
    }
    
    override func setupSubviews() {
        addSubview(contentStackView)
        addSubview(bottomDivider)
    }
    
    override func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.leading.greaterThanOrEqualToSuperview().inset(16)
            make.bottom.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        bottomDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func bind(with model: SDSButtonComponentModel) {
        let sdsButton = SDSButton(
            theme: model.theme,
            variant: model.variant,
            style: model.style,
            size: model.size,
            state: model.state
        )
        
        sdsButton.text = model.buttonText
        sdsButton.buttonShape = model.shape
        
        sdsButton.image = model.leftIcon
        sdsButton.additionalImage = model.rightIcon
        
        contentStackView.addArrangedSubview(sdsButton)
    }
}

