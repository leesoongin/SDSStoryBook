//
//  TypographyHeaderComponent.swift
//  SoongBook
//
//  Created by 이숭인 on 11/14/24.
//

import UIKit
import Combine
import SnapKit
import Then

struct TypographyHeaderComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .adaptive
    
    var identifier: String
    let title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

extension TypographyHeaderComponent {
    typealias ContentType = TypographyHeaderView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(with: context.title)
    }
}

final class TypographyHeaderView: BaseView {
    let titleLabel = SDSLabel(typography: Constants.titleTypo)
    
    override func setup() {
        super.setup()
        
        backgroundColor = .green050
    }
    
    override func setupSubviews() {
        addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func bind(with title: String) {
        titleLabel.text = title
    }
}

extension TypographyHeaderView {
    private enum Constants {
        static let titleTypo = Typography(token: .mediumSubTitle, colorStyle: .grayPrimary)
    }
}
