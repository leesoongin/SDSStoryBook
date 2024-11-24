//
//  SDSColorComponent.swift
//  SoongBook
//
//  Created by 이숭인 on 11/14/24.
//
import UIKit
import Combine
import SnapKit
import Then

struct SDSColorComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .adaptive
    
    var identifier: String
    let color: UIColor
    let title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(title)
    }
}

extension SDSColorComponent {
    typealias ContentType = SDSColorComponentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(with: context.color, title: context.title)
    }
}

final class SDSColorComponentView: BaseView {
    let containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
    }
    let colorView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray900.cgColor
        $0.layer.cornerRadius = 48 / 2
    }
    
    let colorTitleLabel = SDSLabel(typography: Constants.colorTitleTypo)
    
    override func setup() {
        super.setup()
        
        containerStackView.setCustomSpacing(16, after: colorView)
    }
    
    override func setupSubviews() {
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(colorView)
        containerStackView.addArrangedSubview(colorTitleLabel)
    }
    
    override func setupConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        colorView.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
    }
    
    func bind(with color: UIColor, title: String) {
        colorView.backgroundColor = color
        colorTitleLabel.text = title
    }
}

extension SDSColorComponentView {
    private enum Constants {
        static let colorTitleTypo = Typography(token: .smallSubTitle, colorStyle: .grayPrimary)
    }
}
